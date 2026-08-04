#!/bin/bash
# UserPromptSubmit hook: intercepts the six script-backed /open-* commands,
# opens the page locally, and blocks the prompt — the model is never called.
# Exit 0 = not ours, let the prompt through. Exit 2 = handled, block it.
set -uo pipefail

input=$(cat)
prompt=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null) || exit 0

cmd="${prompt#/git-ops:}"        # accept both /git-ops:open-x and /open-x
cmd="${cmd#/}"

case "$cmd" in
  open-repo*)          page=repo ;;
  open-pull-requests*) page=prs ;;
  open-issues*)        page=issues ;;
  open-actions*)       page=actions ;;
  open-releases*)      page=releases ;;
  open-compare*)       page=compare ;;
  *) exit 0 ;;
esac

args=$(printf '%s' "$cmd" | sed -E 's#^open-[a-z-]+ ?##')

out=$(bash "$(cd "$(dirname "$0")" && pwd)/open.sh" "$page" $args)
echo "$out" >&2
exit 2
