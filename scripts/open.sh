#!/bin/bash
# open.sh <page> [args] — builds the GitHub URL and opens it in the browser.
# Repo pages:  repo | prs | issues | actions | releases | tags
#              issue <n> | pr <n> | commit <hash> | file-history <path>
#              compare [a...b] [file]
# Global pages (no repo needed): notifications | gist <id>
# Prints the URL (or a one-line error) — the command file just echoes this output.
set -euo pipefail

open_url() {
  # cross-platform: macOS / Linux / Windows (git-bash, WSL)
  if command -v open >/dev/null 2>&1; then open "$1" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$1" >/dev/null 2>&1 || true
  elif command -v cmd.exe >/dev/null 2>&1; then cmd.exe /c start "" "$1" >/dev/null 2>&1 || true
  fi
  echo "$1"
}

# pages that need no repo at all
case "${1:-repo}" in
  notifications) open_url "https://github.com/notifications"; exit 0 ;;
  gist)
    [ -n "${2:-}" ] || { echo "error: gist id required — /view-gists lists them"; exit 0; }
    open_url "https://gist.github.com/$2"; exit 0 ;;
esac

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
  tags)     out="$base/tags" ;;
  issue)
    [ -n "${2:-}" ] || { echo "error: issue number required"; exit 0; }
    out="$base/issues/$2" ;;
  pr)
    [ -n "${2:-}" ] || { echo "error: PR number required"; exit 0; }
    out="$base/pull/$2" ;;
  commit)
    [ -n "${2:-}" ] || { echo "error: commit hash required"; exit 0; }
    out="$base/commit/$2" ;;
  file-history)
    [ -n "${2:-}" ] || { echo "error: file path required"; exit 0; }
    br=$(git branch --show-current 2>/dev/null)
    [ -n "$br" ] || br=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##')
    [ -n "$br" ] || br=main
    out="$base/commits/$br/$2" ;;
  compare)
    range=""; file=""
    case "${2:-}" in
      *...*) range="$2"; file="${3:-}" ;;
      "")    ;;
      *)     file="$2" ;;
    esac
    if [ -z "$range" ]; then
      def=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##')
      [ -n "$def" ] || def=main
      cur=$(git branch --show-current 2>/dev/null)
      [ -n "$cur" ] || { echo "error: detached HEAD — check out a branch or pass a range (a...b)"; exit 0; }
      range="$def...$cur"
    fi
    out="$base/compare/$range"
    if [ -n "$file" ]; then
      # GitHub anchors each file's diff by sha256 of its path
      if command -v shasum >/dev/null 2>&1; then h=$(printf '%s' "$file" | shasum -a 256 | cut -d' ' -f1)
      else h=$(printf '%s' "$file" | sha256sum | cut -d' ' -f1); fi
      out="$out#diff-$h"
    fi ;;
  *) echo "error: unknown page '$1' (repo|prs|issues|actions|releases|tags|issue|pr|commit|file-history|compare|notifications|gist)"; exit 0 ;;
esac

open_url "$out"
