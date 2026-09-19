#!/usr/bin/env bash
# add-to-ignore.sh <gitignore|exclude> <pattern> [tracked-paths-to-untrack...]
# Appends the pattern (deduped), untracks the named paths, prints a one-line receipt each.
set -uo pipefail

git_dir=$(git rev-parse --git-dir 2>/dev/null) || { echo "error: not a git repo"; exit 0; }
dest="${1:-}"; pattern="${2:-}"
[ -n "$pattern" ] || { echo "error: usage: add-to-ignore.sh <gitignore|exclude> <pattern> [paths...]"; exit 0; }
case "$dest" in
  gitignore) file=".gitignore" ;;
  exclude)   file="$git_dir/info/exclude" ;;
  *) echo "error: destination must be gitignore or exclude"; exit 0 ;;
esac
shift 2

if [ -f "$file" ] && grep -qxF "$pattern" "$file"; then
  echo "already present: $pattern in $file"
else
  [ -f "$file" ] && [ -n "$(tail -c1 "$file" 2>/dev/null)" ] && echo >> "$file"
  printf '%s\n' "$pattern" >> "$file"
  echo "added: $pattern -> $file"
fi

for p in "$@"; do
  if git ls-files --error-unmatch -- "$p" >/dev/null 2>&1; then
    git rm --cached --quiet -- "$p" && echo "untracked: $p (still on disk; commit to finalize)"
  else
    echo "not tracked, nothing to untrack: $p"
  fi
done
