#!/bin/bash
# push.sh — push existing commits, nothing else. Sets upstream when missing.
# Fails loud and stops — never retries, never --force (the flag doesn't exist here on purpose).
set -uo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo"; exit 0; }
br=$(git branch --show-current)
[ -n "$br" ] || { echo "error: detached HEAD — check out a branch first"; exit 0; }

if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  n=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
  [ "$n" != "0" ] || { echo "error: nothing to push — $br is even with $(git rev-parse --abbrev-ref '@{u}')"; exit 0; }
  out=$(git push 2>&1) || { echo "PUSH FAILED — fix manually, do not force:"; echo "$out"; exit 0; }
  echo "pushed: $n commit(s) -> $(git rev-parse --abbrev-ref '@{u}')"
else
  n=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  [ "$n" != "0" ] || { echo "error: nothing to push — no commits yet"; exit 0; }
  out=$(git push -u origin "$br" 2>&1) || { echo "PUSH FAILED — fix manually, do not force:"; echo "$out"; exit 0; }
  echo "pushed: $br -> origin/$br (new upstream, $n commit(s))"
fi
