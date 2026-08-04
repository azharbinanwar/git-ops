#!/bin/bash
# unstage.sh <file> — undo git add for one file, keep the changes.
set -uo pipefail

f="${*:-}"
[ -n "$f" ] || { echo "error: no file given — usage: /unstage <file>"; exit 0; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo"; exit 0; }
git diff --cached --name-only -- "$f" | grep -q . || { echo "error: '$f' is not staged — nothing to undo"; exit 0; }
git restore --staged -- "$f" 2>&1 || { echo "error: unstage failed for '$f'"; exit 0; }
echo "unstaged: $f (changes kept, just not staged)"
git status --short -- "$f"
