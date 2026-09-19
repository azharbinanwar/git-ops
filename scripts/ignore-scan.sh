#!/usr/bin/env bash
# ignore-scan.sh <term> — resolve a name/pattern against disk and report, per candidate,
# whether git already ignores or tracks it. One shot; the model runs no discovery.
set -uo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo"; exit 0; }
term="${1:-}"
[ -n "$term" ] || { echo "(no pattern given)"; exit 0; }

candidates=""
if [ -e "$term" ]; then
  candidates="$term"
else
  # bounded case-insensitive name search; never wanders into junk dirs
  candidates=$(find . -maxdepth 4 \( -path ./.git -o -name node_modules -o -name build -o -name .gradle -o -name .idea \) -prune -o -iname "*${term}*" -print 2>/dev/null | sed 's#^\./##' | head -10)
fi
[ -n "$candidates" ] || { echo "no match on disk for: $term"; exit 0; }

printf '%s\n' "$candidates" | while IFS= read -r f; do
  [ -n "$f" ] || continue
  if git check-ignore -q -- "$f" 2>/dev/null; then ig="ignored"; else ig="NOT ignored"; fi
  if git ls-files --error-unmatch -- "$f" >/dev/null 2>&1; then
    tr="tracked"
    st=$(git status --porcelain -- "$f" 2>/dev/null | cut -c1-2)
    case "$st" in A*) tr="staged (never committed)";; esac
    if [ "$tr" = "tracked" ] && ! git log --all --oneline -1 -- "$f" 2>/dev/null | grep -q .; then tr="staged (never committed)"; fi
  else
    tr="untracked"
  fi
  printf '%s | %s | %s\n' "$f" "$tr" "$ig"
done
