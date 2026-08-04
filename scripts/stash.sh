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
count=$(git status --porcelain | wc -l | tr -d ' ')
[ "$count" != "0" ] || { echo "error: no open changes to stash"; exit 0; }
out=$(git stash push -m "$name" 2>&1) || { echo "error: stash failed:"; echo "$out"; exit 0; }
echo "stashed $count files as \"$name\" ($(git stash list --format='%gd' -1))  |  restore: git stash pop"
