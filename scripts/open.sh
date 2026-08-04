#!/bin/bash
# open.sh <page> — builds the GitHub URL for this repo and opens it.
# Pages: repo | prs | issues | actions | releases | compare
# Prints the URL (or a one-line error) — the command file just echoes this output.
set -euo pipefail

url=$(git remote get-url origin 2>/dev/null) || {
  echo "error: not a git repo or no 'origin' remote — /add-remote can set one up"
  exit 0
}

# ssh (git@host:owner/repo.git) and https both normalize to https://host/owner/repo
base=$(printf '%s' "$url" | sed -E 's#^git@([^:]+):#https://\1/#; s#^ssh://git@#https://#; s#\.git$##')

case "${1:-repo}" in
  repo)     out="$base" ;;
  prs)      out="$base/pulls" ;;
  issues)   out="$base/issues" ;;
  actions)  out="$base/actions" ;;
  releases) out="$base/releases" ;;
  compare)
    range="${2:-}"
    if [ -z "$range" ]; then
      def=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##')
      [ -n "$def" ] || def=main
      cur=$(git branch --show-current 2>/dev/null)
      [ -n "$cur" ] || { echo "error: detached HEAD — check out a branch or pass a range (a...b)"; exit 0; }
      range="$def...$cur"
    fi
    out="$base/compare/$range" ;;
  *) echo "error: unknown page '$1' (repo|prs|issues|actions|releases|compare)"; exit 0 ;;
esac

# cross-platform browser open: macOS / Linux / Windows (git-bash, WSL)
if command -v open >/dev/null 2>&1; then open "$out" >/dev/null 2>&1 || true
elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$out" >/dev/null 2>&1 || true
elif command -v cmd.exe >/dev/null 2>&1; then cmd.exe /c start "" "$out" >/dev/null 2>&1 || true
fi
echo "$out"
