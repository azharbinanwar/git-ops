#!/bin/bash
# create-pr.sh <base-branch> [--draft] — the approved Create step as one deterministic call.
# Reads PR title (line 1), blank line, then body from stdin.
# Pushes the branch if needed, then opens the PR. Fails loud, never forces.
set -uo pipefail

base="${1:-}"
[ -n "$base" ] || { echo "error: no target branch given"; exit 0; }
input=$(cat)
title=$(printf '%s\n' "$input" | head -1)
body=$(printf '%s\n' "$input" | tail -n +3)
[ -n "$title" ] || { echo "error: empty PR title"; exit 0; }

br=$(git branch --show-current)
if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  pout=$(git push 2>&1) || { echo "error: push failed — fix manually, do not force:"; echo "$pout"; exit 0; }
else
  pout=$(git push -u origin "$br" 2>&1) || { echo "error: push failed — fix manually, do not force:"; echo "$pout"; exit 0; }
fi

draft=""
[ "${2:-}" = "--draft" ] && draft="--draft"
url=$(gh pr create --title "$title" --body "$body" --base "$base" $draft 2>&1) || {
  echo "error: gh pr create failed:"; echo "$url"; exit 0
}
echo "PR created${draft:+ (draft)}: $url  |  undo: gh pr close ${url##*$'\n'}"
