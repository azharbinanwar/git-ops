#!/bin/bash
# untracked-scan.sh — one line per untracked directory: file count, plus any
# known junk/secret files hiding inside (build output, IDE metadata, keys).
set -uo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "none"; exit 0; }
dirs=$(git status --porcelain 2>/dev/null | sed -n 's/^?? \(.*\/\)$/\1/p')
[ -n "$dirs" ] || { echo "none"; exit 0; }

while IFS= read -r d; do
  files=$(git ls-files --others --exclude-standard -- "$d")
  count=$(printf '%s\n' "$files" | grep -c . || true)
  echo "$d — $count files"
  junk=$(printf '%s\n' "$files" | grep -E '(^|/)(build|\.gradle|\.idea|node_modules|DerivedData)/|local\.properties$|\.keystore$|\.jks$|\.env$|\.pem$' | head -5)
  [ -z "$junk" ] || printf '%s\n' "$junk" | sed 's/^/  suspicious: /'
done <<< "$dirs"
