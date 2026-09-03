#!/usr/bin/env bash
# suggest.sh <command-name> — prints a Related/Tip suggestion block for the command.
# Related lines are fixed per command; Tip is state-triggered (stash / behind / merged
# branches), falling back to a rotating discovery line. Unknown command -> no output.
set -euo pipefail

cmd="${1:-}"

related() {
  case "$1" in
    commit-and-push) printf '%s\n' \
      "/create-pr — turn this branch into a PR" \
      "/pr-status — check PR state for this branch" ;;
    commit-only) printf '%s\n' \
      "/commit-and-push — commit and push in one go" \
      "/amend-msg — reword the last commit" ;;
    create-pr) printf '%s\n' \
      "/view-pr — see PR details in chat" \
      "/merge-pr — merge when checks pass" ;;
    merge-pr) printf '%s\n' \
      "/create-release — cut a release from the base branch" \
      "/clean-branches — delete merged branches" ;;
    create-release) printf '%s\n' \
      "/view-releases — list releases in chat" \
      "/open-releases — open the releases page in the browser" ;;
    create-branch) printf '%s\n' \
      "/commit-only — commit your changes here" \
      "/checkout-branch — jump back to another branch" ;;
    stash) printf '%s\n' \
      "/pop-stash — restore this stash later" \
      "/view-stashes — list stashes in chat" ;;
    pull-rebase) printf '%s\n' \
      "/view-branches — list branches with state in chat" \
      "/update-branch — sync this branch with its base" ;;
    squash) printf '%s\n' \
      "/amend-msg — reword the last commit" \
      "/undo-commit — undo the last commit, keep the changes" ;;
    update-branch) printf '%s\n' \
      "/pull-rebase — pull with rebase, keep history linear" \
      "/merge-branch — merge another branch into this one" ;;
    *) return 1 ;;
  esac
}

# Commands that also get a Tip line
tip_enabled() {
  case "$1" in
    commit-and-push|commit-only|create-pr|merge-pr|create-release) return 0 ;;
    *) return 1 ;;
  esac
}

rel="$(related "$cmd" 2>/dev/null)" || exit 0
printf 'Related:\n'
printf '%s\n' "$rel" | sed 's/^/  /'

tip_enabled "$cmd" || exit 0
git_dir="$(git rev-parse --git-dir 2>/dev/null)" || exit 0

tip=""
# state triggers, first hit wins; skip a trigger whose command is already in Related
n=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -gt 0 ] && ! printf '%s' "$rel" | grep -q "/pop-stash "; then
  [ "$n" = 1 ] && tip="/pop-stash — you have 1 stash waiting" || tip="/pop-stash — you have $n stashes waiting"
fi
if [ -z "$tip" ] && git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  n=$(git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)
  if [ "$n" -gt 0 ] && ! printf '%s' "$rel" | grep -q "/pull-rebase "; then
    tip="/pull-rebase — origin is $n commit(s) ahead of you"
  fi
fi
if [ -z "$tip" ]; then
  n=$(git branch --merged 2>/dev/null | grep -vcE '^\*|^\s*(main|master|develop)$' || true)
  if [ "$n" -gt 0 ] && ! printf '%s' "$rel" | grep -q "/clean-branches "; then
    tip="/clean-branches — $n merged branch(es) can be deleted"
  fi
fi

# rotation fallback: cycle through discovery lines, counter kept in .git
if [ -z "$tip" ]; then
  lines=(
    "/blame — who last touched each line of a file"
    "/squash — squash the last N commits into one"
    "/cherry-pick — apply a commit from another branch"
    "/add-to-ignore — add a path to .gitignore properly"
    "/repo-info — repo summary in chat"
    "/view-notifications — GitHub notifications in chat"
    "/open-compare — open a branch comparison in the browser"
    "/open-file-history — open a file's history on GitHub"
    "/create-gist — share a file as a gist"
    "/rename-branch — rename local + remote branch safely"
    "/pr-desc — rewrite a PR description"
    "/view-tags — list tags in chat"
  )
  f="$git_dir/git-ops-suggest-idx"
  i=$(cat "$f" 2>/dev/null | tr -dc '0-9' || true); i="${i:-0}"
  tip="${lines[$(( i % ${#lines[@]} ))]}"
  echo $(( (i + 1) % ${#lines[@]} )) > "$f" 2>/dev/null || true
fi

printf 'Tip:\n  %s\n' "$tip"
