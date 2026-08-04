#!/bin/bash
# create-release.sh <tag> — the approved Create step as one deterministic call.
# Reads release title (line 1), blank line, then notes from stdin.
set -uo pipefail

tag="${1:-}"
[ -n "$tag" ] || { echo "error: no version tag given"; exit 0; }
input=$(cat)
title=$(printf '%s\n' "$input" | head -1)
notes=$(printf '%s\n' "$input" | tail -n +3)
[ -n "$title" ] || { echo "error: empty release title"; exit 0; }

out=$(gh release create "$tag" --title "$title" --notes "$notes" 2>&1) || {
  echo "error: gh release create failed:"; echo "$out"; exit 0
}
echo "release created: $out  |  undo: gh release delete $tag --cleanup-tag"
