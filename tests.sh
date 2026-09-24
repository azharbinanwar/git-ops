#!/bin/bash
# tests.sh — self-contained checks for every script in scripts/.
# No network, no GitHub: pushes go to a local bare repo. Run: bash tests.sh
set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
S="$ROOT/scripts"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
PASS=0; FAIL=0
export GIT_OPS_NO_OPEN=1  # never launch a real browser from tests

check() { # check <name> <expected-substring> <<< actual
  local name="$1" want="$2" got; got=$(cat)
  if printf '%s' "$got" | grep -qF "$want"; then
    PASS=$((PASS+1)); echo "ok: $name"
  else
    FAIL=$((FAIL+1)); echo "FAIL: $name"; echo "  wanted: $want"; echo "  got: $(printf '%s' "$got" | head -3)"
  fi
}

# --- workbench: repo with a local bare "origin" so pushes are real but offline ---
git init -q --bare "$TMP/origin.git"
git init -q "$TMP/repo"; cd "$TMP/repo"
git config user.email t@t; git config user.name t
git remote add origin "$TMP/origin.git"
echo base > f.txt; git add -A; git commit -qm init; git push -qu origin main 2>/dev/null || git push -qu origin master

# open.sh
check "open: builds url, .git stripped" "/origin"                   < <(bash "$S/open.sh" repo)
check "open: bad page errors"       "error: unknown page"           < <(bash "$S/open.sh" banana)
check "open: no repo errors"        "error: not a git repo"         < <(cd "$TMP" && bash "$S/open.sh" repo)
check "open: issue url"             "/issues/7"                     < <(bash "$S/open.sh" issue 7)
check "open: commit url"            "/commit/abc123"                < <(bash "$S/open.sh" commit abc123)
check "open: collaborators url"     "/settings/access"              < <(bash "$S/open.sh" collaborators)
check "open: network url"           "/network"                      < <(bash "$S/open.sh" network)
check "open: gist needs no repo"    "gist.github.com/xyz"           < <(cd "$TMP" && bash "$S/open.sh" gist xyz)
check "open: notifications global"  "github.com/notifications"      < <(cd "$TMP" && bash "$S/open.sh" notifications)
check "open: compare file anchor"   "#diff-"                        < <(bash "$S/open.sh" compare "a...b" f.txt)
check "open: pr number required"    "error: PR number required"     < <(bash "$S/open.sh" pr)
check "open: branches page"         "/branches"                     < <(bash "$S/open.sh" branches)
check "open: branch tree default"   "/tree/"                        < <(bash "$S/open.sh" branch)
check "vbranches: shows current"    "[current]"                     < <(bash "$S/view-branches.sh")
check "vbranches: not a repo"       "error: not a git repo"         < <(cd "$TMP" && bash "$S/view-branches.sh")

# untracked-scan.sh
mkdir -p sub/build; echo x > sub/keep.txt; echo y > sub/build/junk.bin; echo z > sub/local.properties
check "scan: counts files"          "sub/ — 3 files"                < <(bash "$S/untracked-scan.sh")
check "scan: flags junk"            "suspicious: sub/build/junk.bin" < <(bash "$S/untracked-scan.sh")
rm -rf sub
check "scan: clean says none"       "none"                          < <(bash "$S/untracked-scan.sh")

# secrets-scan.sh
echo "sdk.dir=/x" > local.properties; echo k > sign.jks; echo "{}" > google-services.json
check "secrets: flags local.properties" "[secret]"                  < <(bash "$S/secrets-scan.sh")
check "secrets: names the file"     "local.properties"              < <(bash "$S/secrets-scan.sh")
check "secrets: review for firebase" "[review]"                     < <(bash "$S/secrets-scan.sh")
rm -f local.properties sign.jks google-services.json
check "secrets: clean says none"    "none found."                   < <(bash "$S/secrets-scan.sh")

# stash.sh / unstage.sh
echo change >> f.txt
check "stash: no name lists files"  "error: stash name required"    < <(bash "$S/stash.sh")
check "stash: works with name"      'stashed 1 files as "t1"'       < <(bash "$S/stash.sh" t1)
git stash pop -q
git add f.txt
check "unstage: works"              "unstaged: f.txt"               < <(bash "$S/unstage.sh" f.txt)
check "unstage: not staged errors"  "not staged"                    < <(bash "$S/unstage.sh" f.txt)
check "unstage: no arg errors"      "error: no file given"          < <(bash "$S/unstage.sh")

# commit-only.sh
check "commit-only: success"        "committed:"                    < <(printf 'test: co\n' | bash "$S/commit-only.sh")
check "commit-only: lists files"    "f.txt"                         < <(git show --name-only --format= HEAD)
check "commit-only: empty msg"      "error: empty commit message"   < <(printf '' | bash "$S/commit-only.sh")
check "commit-only: clean tree"     "error: nothing to commit"      < <(printf 'x\n' | bash "$S/commit-only.sh")

# commit-and-push.sh — real push to the local bare origin
echo more >> f.txt
check "commit-push: success+push"   "committed and pushed:"         < <(printf 'test: cp\n' | bash "$S/commit-and-push.sh")
echo viafile > f.txt; printf 'test: via file\n\n- body line\n' > "$TMP/msg.txt"
check "commit-push: message file"   "committed and pushed:"         < <(bash "$S/commit-and-push.sh" "$TMP/msg.txt")
check "commit-push: file deleted"   "EMPTY"                         < <([ ! -f "$TMP/msg.txt" ] && echo EMPTY)
check "commit-push: missing file"   "error: commit message file not found" < <(bash "$S/commit-and-push.sh" "$TMP/nope.txt")
# push failure: point origin somewhere dead
git remote set-url origin "$TMP/nowhere.git"
echo again >> f.txt
check "commit-push: push fails loud" "PUSH FAILED"                  < <(printf 'test: fail\n' | bash "$S/commit-and-push.sh")
git remote set-url origin "$TMP/origin.git"

# create-pr.sh / create-release.sh — offline error paths only (gh needs network)
check "create-pr: no base errors"   "error: no target branch"       < <(bash "$S/create-pr.sh" < /dev/null)
check "create-pr: empty title"      "error: empty PR title"         < <(printf '\n\n\n' | bash "$S/create-pr.sh" main)
check "create-pr: missing file"     "error: PR text file not found" < <(bash "$S/create-pr.sh" main "$TMP/nope.md")
printf '\n\nbody\n' > "$TMP/pr-empty.md"
check "create-pr: empty title file" "error: empty PR title"         < <(bash "$S/create-pr.sh" main "$TMP/pr-empty.md")

# change-list.sh
git checkout -qb cl-test
mkdir -p biglist; for i in $(seq 1 35); do echo x > "biglist/f$i.txt"; done
git add -A; git commit -qm "cl big"
check "change-list: groups big sets" "biglist/ (35 files)"          < <(bash "$S/change-list.sh" "HEAD~1...HEAD")
check "change-list: total noted"     "files total"                  < <(bash "$S/change-list.sh" "HEAD~1...HEAD")
git rm -q biglist/f1.txt; echo y >> f.txt; git add -A; git commit -qm "cl small"
check "change-list: deleted line"    "Deleted:  biglist/f1.txt"     < <(bash "$S/change-list.sh" "HEAD~1...HEAD")
check "change-list: modified line"   "Modified: f.txt"              < <(bash "$S/change-list.sh" "HEAD~1...HEAD")
check "change-list: empty range"     "(no changes)"                 < <(bash "$S/change-list.sh" "HEAD...HEAD")
check "create-release: no tag"      "error: no version tag"         < <(bash "$S/create-release.sh" < /dev/null)
check "create-release: empty title" "error: empty release title"    < <(printf '\n\n\n' | bash "$S/create-release.sh" v0)

# push.sh
echo pushme > p.txt; git add p.txt; git commit -qm "push test"
check "push: pushes commits"        "pushed:"                       < <(bash "$S/push.sh")
check "push: nothing to push"       "error: nothing to push"        < <(bash "$S/push.sh")
git remote set-url origin "$TMP/nowhere.git"
echo again > p.txt; git add p.txt; git commit -qm "push fail test"
check "push: fails loud"            "PUSH FAILED"                   < <(bash "$S/push.sh")
git remote set-url origin "$TMP/origin.git"
bash "$S/push.sh" >/dev/null 2>&1

# branch-history.sh
main_br=$(git branch --format='%(refname:short)' | grep -E '^(main|master)$' | head -1)
git checkout -qb bh-feat "$main_br"
echo bh1 > bh.txt; git add bh.txt; git commit -qm "bh: first"
echo bh2 >> bh.txt; git add bh.txt; git commit -qm "bh: second"
check "bhist: timeline created"     "created      from" < <(bash "$S/branch-history.sh" bh-feat "$main_br")
check "bhist: not merged status"    "not merged     ahead of $main_br by 2" < <(bash "$S/branch-history.sh" bh-feat "$main_br")
check "bhist: work commits"         "bh: second"                    < <(bash "$S/branch-history.sh" bh-feat "$main_br")
check "bhist: graph fork point"     "fork point"                    < <(bash "$S/branch-history.sh" bh-feat "$main_br")
git checkout -q "$main_br"; git merge -q --no-ff bh-feat -m "Merge branch 'bh-feat'" 2>/dev/null
check "bhist: merged into"          "merged       into $main_br"    < <(bash "$S/branch-history.sh" bh-feat "$main_br")
check "bhist: unknown branch"       "error: no branch named"        < <(bash "$S/branch-history.sh" zz-none "$main_br")

# ignore-scan.sh / add-to-ignore.sh
echo secret > sec.jks; git add sec.jks
check "iscan: finds + staged"        "sec.jks | staged (never committed) | NOT ignored" < <(bash "$S/ignore-scan.sh" jks)
check "iscan: no match"              "no match on disk"              < <(bash "$S/ignore-scan.sh" zz-nope)
check "iscan: empty term"            "(no pattern given)"            < <(bash "$S/ignore-scan.sh" "")
check "ati: adds + untracks"         "untracked: sec.jks"            < <(bash "$S/add-to-ignore.sh" gitignore "*.jks" sec.jks)
check "ati: dedup"                   "already present"               < <(bash "$S/add-to-ignore.sh" gitignore "*.jks")
check "iscan: now ignored"           "sec.jks | untracked | ignored" < <(bash "$S/ignore-scan.sh" jks)
check "ati: bad dest"                "error: destination"            < <(bash "$S/add-to-ignore.sh" nowhere "*.jks")
rm -f sec.jks; git checkout -q -- .gitignore 2>/dev/null || rm -f .gitignore

# suggest.sh
check "suggest: default-branch pair" '/git-ops:create-release` — cut a release' < <(bash "$S/suggest.sh" commit-and-push)
git checkout -q bh-feat
check "suggest: related lines"      '/git-ops:create-pr` — turn this branch into a PR' < <(bash "$S/suggest.sh" commit-and-push)
check "suggest: related header"     "**Tips**"                      < <(bash "$S/suggest.sh" stash)
check "suggest: big cmds 4 lines"   "5"                             < <(bash "$S/suggest.sh" commit-only | wc -l | tr -d " ")
check "suggest: unknown cmd empty"  "EMPTY"                         < <(out=$(bash "$S/suggest.sh" open-repo); [ -z "$out" ] && echo EMPTY)
git stash push -qm "suggest test" >/dev/null 2>&1 || true
if git stash list | grep -q .; then
  check "suggest: stash trigger"    '/git-ops:pop-stash` — you have 1 stash waiting' < <(bash "$S/suggest.sh" commit-and-push)
  git stash drop -q >/dev/null 2>&1 || true
fi
check "suggest: no tip on small"    "EMPTY"                         < <(out=$(bash "$S/suggest.sh" stash | awk 'NR>3' || true); [ -z "$out" ] && echo EMPTY)
echo
echo "passed: $PASS, failed: $FAIL"
[ "$FAIL" = 0 ]
