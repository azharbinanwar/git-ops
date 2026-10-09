#!/bin/bash
# stash.sh <name...> — stash all open changes under a findable name.
set -uo pipefail

name="${*:-}"
if [ -z "$name" ]; then
  echo "error: stash name required — open changes:"
  git status --porcelain 2>/dev/null | head -5
  exit 0
fi
git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo"; exit 0; }
count=$(git status --porcelain -uall | wc -l | tr -d ' ')
[ "$count" != "0" ] || { echo "error: no open changes to stash"; exit 0; }
before=$(git rev-parse -q --verify refs/stash 2>/dev/null || true)
# -u: new files are part of "open changes"; without it they silently stay behind
out=$(git stash push -u -m "$name" 2>&1) || { echo "error: stash failed:"; echo "$out"; exit 0; }
after=$(git rev-parse -q --verify refs/stash 2>/dev/null || true)
[ -n "$after" ] && [ "$after" != "$before" ] || { echo "error: nothing was stashed:"; echo "$out"; exit 0; }
left=$(git status --porcelain -uall | wc -l | tr -d ' ')
echo "stashed $count files as \"$name\" (stash@{0})  |  restore: git stash pop"
[ "$left" = 0 ] || echo "note: $left file(s) still open (ignored or unstashable)"
