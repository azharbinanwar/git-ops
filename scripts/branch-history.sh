#!/bin/bash
# branch-history.sh <branch> [base] — a branch's life: Timeline, Status, Work,
# and a word-annotated graph. All facts from git, one shot.
# ponytail: merges-out matched by merge-commit subject naming the branch — squash
# merges leave no merge commit, so they show as "fully merged" without a dated line.
set -uo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo"; exit 0; }
br="${1:-$(git branch --show-current)}"
git rev-parse --verify -q "$br" >/dev/null || { echo "error: no branch named '$br'"; exit 0; }
base="${2:-$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##')}"
[ -n "$base" ] && git rev-parse --verify -q "$base" >/dev/null || base=main
git rev-parse --verify -q "$base" >/dev/null || { echo "error: base branch '$base' not found"; exit 0; }
[ "$br" = "$base" ] && { echo "error: '$br' is the base branch — pass a feature branch"; exit 0; }

tip=$(git rev-parse "$br")
fork=$(git merge-base "$base" "$br" 2>/dev/null)
[ -n "$fork" ] || { echo "error: no common history between $br and $base"; exit 0; }
fmt_d(){ date -r "$1" "+%b %d" 2>/dev/null || date -d "@$1" "+%b %d"; }

# merges of THIS branch into base: subject names the branch, and not "into <branch>"
merge_events=$(git log --merges --format='%ct|%h|%s' "$base" 2>/dev/null | awk -F'|' -v b="$br" \
  'index($3, "\x27" b "\x27") || $3 ~ ("[ /]" b "$") { if ($3 !~ ("into " b "$")) print }')
mh=$(printf '%s\n' "$merge_events" | head -1 | cut -d'|' -f2)
fully_merged=no
git merge-base --is-ancestor "$tip" "$base" 2>/dev/null && fully_merged=yes

# effective fork + the branch's own commit set, correct even after a full merge
if [ "$fully_merged" = yes ] && [ -n "$mh" ]; then
  eff_fork=$(git merge-base "$mh^1" "$tip" 2>/dev/null || echo "$fork")
else
  eff_fork="$fork"
fi
branch_set=$(git rev-list "$tip" --not "$base" 2>/dev/null)
[ -z "$branch_set" ] && branch_set=$(git rev-list "$tip" --not "$eff_fork^@" 2>/dev/null)

echo "$br"
echo "=============================================================="
echo
echo "Timeline"
events=$(
printf '%s\n' "$merge_events" | grep . | while IFS='|' read -r ts h s; do
  printf '%s|%s   %-12s into %s (%s)\n' "$ts" "$(fmt_d "$ts")" "merged" "$base" "$h"
done
git log --first-parent --merges --format='%ct|%h|%s' "$eff_fork".."$br" 2>/dev/null | while IFS='|' read -r ts h s; do
  printf '%s|%s   %-12s %s (%s)\n' "$ts" "$(fmt_d "$ts")" "pulled in" "$(printf '%s' "$s" | sed -E "s/^Merge (remote-tracking )?branch '([^']+)'.*/\2/; s/^Merge pull request [^ ]+ from (.*)/\1/" | cut -c1-40)" "$h"
done
n_new=$(git rev-list --count "$base".."$br")
if [ "$n_new" -gt 0 ]; then
  ts=$(git log --format=%ct --reverse "$base".."$br" 2>/dev/null | head -1)
  printf '%s|%s   %-12s %s commit(s) not yet in %s\n' "$ts" "$(fmt_d "$ts")" "new work" "$n_new" "$base"
fi
)
events=$(printf '%s\n' "$events" | grep . | sort -n)
first_ts=$(printf '%s\n' "$events" | head -1 | cut -d'|' -f1)
cre=$(git reflog show --format='%ct|%gs' "$br" 2>/dev/null | tail -1)
if printf '%s' "$cre" | grep -q "branch: Created from" && { [ -z "$first_ts" ] || [ "${cre%%|*}" -le "$first_ts" ]; }; then
  ts=${cre%%|*}
  src=$(printf '%s' "$cre" | sed 's/.*Created from //' | cut -c1-30)
  at=$(git reflog show --format='%h' "$br" 2>/dev/null | tail -1)
  [ "$src" = "HEAD" ] && src="commit $at"
  printf '%s   %-12s from %s\n' "$(fmt_d "$ts")" "created" "$src"
else
  printf '         %-12s %s\n' "created" "(before local history — branch predates this clone's reflog)"
fi
printf '%s\n' "$events" | cut -d'|' -f2-

echo
echo "Status"
a=$(git rev-list --count "$base".."$br"); b=$(git rev-list --count "$br".."$base")
if [ "$fully_merged" = yes ]; then
  echo "merged into    $base (fully — every commit is in it)"
elif [ -n "$mh" ]; then
  echo "not fully merged   $a commit(s) not in $base yet (older work was merged), behind by $b"
else
  echo "not merged     ahead of $base by $a, behind by $b"
fi
if git rev-parse --verify -q "origin/$br" >/dev/null; then
  up=$(git rev-list --count "origin/$br".."$br" 2>/dev/null || echo 0)
  [ "$up" = 0 ] && echo "remote         origin/$br, nothing unpushed" || echo "remote         origin/$br, $up commit(s) unpushed"
else
  echo "remote         not pushed"
fi

echo
if [ "$fully_merged" = yes ] || [ -z "$mh" ]; then echo "Work"; else echo "Work (since the last merge into $base)"; fi
n=$(git rev-list --count --no-merges "$eff_fork".."$br")
stat=$(git diff --shortstat "$eff_fork" "$br" 2>/dev/null | sed 's/^ *//')
echo "$n commits · ${stat:-no file changes}"
git log --no-merges --format='%ad  %h  %s' --date=format:'%b %d' "$eff_fork".."$br" 2>/dev/null | head -5 | cut -c1-78
[ "$n" -gt 5 ] && echo "         … $((n-5)) more"

echo
echo "Graph (base = $base · branch = $br — read the middle column, last 12)"
if [ "$fully_merged" = yes ] && [ -n "$mh" ]; then
  graph=$(git log --graph --format='%h %s' "$mh" --not "$eff_fork^@" 2>/dev/null)
else
  graph=$(git log --graph --format='%h %s' "$base" "$br" --not "$eff_fork^@" 2>/dev/null)
fi
if ! printf '%s\n' "$graph" | head -12 | grep -qE '[\\/|]'; then
  echo "linear — nothing has diverged, so there are no rails to draw ($base is at the fork point)"
  exit 0
fi
printf '%s\n' "$graph" | head -12 | while IFS= read -r line; do
  h=$(printf '%s' "$line" | grep -oE '[0-9a-f]{7,}' | head -1)
  if [ -z "$h" ]; then echo "$line"; continue; fi
  full=$(git rev-parse "$h" 2>/dev/null)
  side="$base"
  printf '%s\n' "$branch_set" | grep -q "^$full" && side="branch"
  [ "$(git rev-list --no-walk --merges "$h" 2>/dev/null | wc -l | tr -d ' ')" != "0" ] && side="MERGE"
  [ "$full" = "$(git rev-parse "$eff_fork")" ] && side="fork point"
  pad=$(printf '%-11s' "$side")
  printf '%s\n' "$line" | sed -E "s/([0-9a-f]{7,}) /\1  $pad /" | cut -c1-90
done
