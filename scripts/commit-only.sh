#!/bin/bash
# commit-only.sh — the approved Commit step as one deterministic call.
# Reads the full commit message from stdin (title, blank line, body).
# Stages everything and commits. Never pushes. Fails loud and stops —
# no --no-verify, no bypasses (those flags don't exist here on purpose).
set -uo pipefail

msg=$(cat)
[ -n "$msg" ] || { echo "error: empty commit message — nothing done"; exit 0; }

git add -A 2>&1 || { echo "error: git add failed"; exit 0; }

count=$(git diff --cached --name-only | wc -l | tr -d ' ')
[ "$count" != "0" ] || { echo "error: nothing to commit — working tree clean"; exit 0; }
staged=$(git diff --cached --name-status | head -20)
[ "$count" -le 20 ] || staged="$staged
... and $((count - 20)) more"

out=$(printf '%s\n' "$msg" | git commit -F - 2>&1) || {
  echo "error: commit failed (changes remain staged):"
  echo "$out"
  exit 0
}
echo "committed: $(git rev-parse --short HEAD) ($count files) — not pushed  |  undo: git reset --soft HEAD~1"
echo "$staged"
