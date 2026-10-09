#!/bin/bash
# amend-msg.sh — replace only the last commit's message (stdin). Staged changes are
# never folded in: --only with no paths records the message alone and leaves the index as is.
set -uo pipefail

git rev-parse --verify -q HEAD >/dev/null || { echo "error: no commit to amend"; exit 0; }
msg=$(cat)
[ -n "$msg" ] || { echo "error: empty commit message — nothing done"; exit 0; }
old=$(git rev-parse --short HEAD)
staged=$(git diff --cached --name-only | wc -l | tr -d ' ')
out=$(printf '%s\n' "$msg" | git commit --amend --only -F - 2>&1) || { echo "error: amend failed:"; echo "$out"; exit 0; }
echo "amended message: $old -> $(git rev-parse --short HEAD) (content unchanged)"
[ "$staged" = 0 ] || echo "note: $staged staged file(s) left staged, not added to the commit"
