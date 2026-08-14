#!/bin/bash
# tests.sh — self-contained checks for every script in scripts/.
# No network, no GitHub: pushes go to a local bare repo. Run: bash tests.sh
set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
S="$ROOT/scripts"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
PASS=0; FAIL=0

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

echo
echo "passed: $PASS, failed: $FAIL"
[ "$FAIL" = 0 ]
