#!/bin/bash
# create-pr.sh <base-branch> [pr-text-file] [--draft] — the approved Create step as one deterministic call.
# PR text (title on line 1, blank line, then body) comes from the file if given, else stdin.
# Pushes the branch if needed, then opens the PR. Fails loud, never forces.
set -uo pipefail

base="${1:-}"
[ -n "$base" ] || { echo "error: no target branch given"; exit 0; }
shift
draft=""; file=""
for a in "$@"; do
  if [ "$a" = "--draft" ]; then draft="--draft"; else file="$a"; fi
done
if [ -n "$file" ]; then
  [ -f "$file" ] || { echo "error: PR text file not found: $file"; exit 0; }
  input=$(cat "$file")
else
  input=$(cat)
fi
title=$(printf '%s\n' "$input" | head -1)
body=$(printf '%s\n' "$input" | tail -n +3)
[ -n "$title" ] || { echo "error: empty PR title"; exit 0; }

br=$(git branch --show-current)
if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  pout=$(git push 2>&1) || { echo "error: push failed — fix manually, do not force:"; echo "$pout"; exit 0; }
else
  pout=$(git push -u origin "$br" 2>&1) || { echo "error: push failed — fix manually, do not force:"; echo "$pout"; exit 0; }
fi

url=$(gh pr create --title "$title" --body "$body" --base "$base" $draft 2>&1) || {
  echo "error: gh pr create failed:"; echo "$url"; exit 0
}
if [ -n "$file" ]; then rm -f "$file"; fi
echo "PR created${draft:+ (draft)}: $url  |  undo: gh pr close ${url##*$'\n'}"
