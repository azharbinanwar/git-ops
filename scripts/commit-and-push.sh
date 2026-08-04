#!/bin/bash
# commit-and-push.sh — the approved Commit & Push step as one deterministic call.
# Reads the full commit message from stdin (title, blank line, body).
# Stages everything, commits, pushes. Fails loud and stops — never retries,
# never --no-verify, never --force (those flags don't exist here on purpose).
set -uo pipefail

msg=$(cat)
[ -n "$msg" ] || { echo "error: empty commit message — nothing done"; exit 0; }

git add -A 2>&1 || { echo "error: git add failed"; exit 0; }

count=$(git diff --cached --name-only | wc -l | tr -d ' ')
[ "$count" != "0" ] || { echo "error: nothing to commit — working tree clean"; exit 0; }
# the staged list is part of the output contract: the user sees exactly what went in,
# even if the model skipped displaying a change list
staged=$(git diff --cached --name-status | head -20)
[ "$count" -le 20 ] || staged="$staged
... and $((count - 20)) more"

out=$(printf '%s\n' "$msg" | git commit -F - 2>&1) || {
  echo "error: commit failed (nothing pushed):"
  echo "$out"
  exit 0
}
hash=$(git rev-parse --short HEAD)

if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  pout=$(git push 2>&1) || {
    echo "committed $hash ($count files) but PUSH FAILED — fix manually, do not force:"
    echo "$pout"
    exit 0
  }
else
  br=$(git branch --show-current)
  pout=$(git push -u origin "$br" 2>&1) || {
    echo "committed $hash ($count files) but PUSH FAILED — fix manually, do not force:"
    echo "$pout"
    exit 0
  }
fi

echo "committed and pushed: $hash ($count files) -> $(git rev-parse --abbrev-ref '@{u}')  |  undo (local only): git reset --soft HEAD~1"
echo "$staged"
