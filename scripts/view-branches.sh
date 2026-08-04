#!/bin/bash
# view-branches.sh — one pre-formatted row per local branch:
# name | age by author (· started from X when the reflog knows) | merged/pushed state
# then "---" and remote-only branch names. The command reproduces this output.
set -uo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo"; exit 0; }
def=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##'); [ -n "$def" ] || def=main
cur=$(git branch --show-current 2>/dev/null || true)
merged=$(git branch --merged "origin/$def" --format='%(refname:short)' 2>/dev/null \
      || git branch --merged "$def" --format='%(refname:short)' 2>/dev/null || true)

# one call: branch -> its PR (number + state), any author
prs=$(gh pr list --state all --limit 100 --json number,state,headRefName \
      --jq '.[] | "\(.headRefName)|#\(.number) \(.state|ascii_downcase)"' 2>/dev/null || true)

git for-each-ref refs/heads --sort=-committerdate \
  --format='%(refname:short)|%(committerdate:relative)|%(authorname)|%(upstream:short)|%(upstream:track)' |
while IFS='|' read -r name age author up track; do
  flags=""
  [ "$name" = "$cur" ] && flags="current"
  [ "$name" = "$def" ] && flags="${flags:+$flags · }default"
  if [ "$name" = "$def" ]; then m=""
  elif printf '%s\n' "$merged" | grep -qx "$name"; then m="merged ✓"
  else m="NOT merged"; fi
  if [ -n "$up" ]; then r="pushed${track:+ $track}"; else r="local only"; fi
  # ponytail: creation info from the local reflog — absent for branches created elsewhere
  from=$(git reflog show "$name" --format='%gs' 2>/dev/null | tail -1 \
       | sed -n 's/^branch: Created from \(.*\)$/from \1/p')
  extra=""
  if [ "$name" != "$def" ]; then
    n=$(git rev-list --count "$name" --not "origin/$def" 2>/dev/null || echo "")
    creator=$(git log "$name" --not "origin/$def" --format='%an' 2>/dev/null | tail -1)
    [ -n "$n" ] && [ "$n" != "0" ] && extra="$n commits${creator:+ · created by $creator}"
  fi
  pr=$(printf '%s\n' "$prs" | sed -n "s#^$name|##p" | head -1)
  echo "${flags:+[$flags] }$name | $age by $author${from:+ · started $from} | ${m:+$m · }$r${extra:+ · $extra}${pr:+ · PR $pr}"
done

echo "---remote-only---"
git branch -r --format='%(refname:short)' 2>/dev/null | sed 's#^origin/##' | grep -v -e '^HEAD$' -e '^origin$' | head -15
