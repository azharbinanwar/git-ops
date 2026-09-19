#!/usr/bin/env bash
# suggest.sh <command-name> — prints a Related/Tip suggestion block for the command.
# Lines are markdown (backticked commands render styled in the terminal).
# Related is fixed per command; Tip is state-triggered (stash / behind / merged
# branches), falling back to a rotating discovery line. Unknown command -> no output.
set -euo pipefail

cmd="${1:-}"
G='`/git-ops:'   # open: backtick + namespace
E='`'            # close backtick

related() {
  case "$1" in
    commit-and-push) printf '%s\n' \
      "${G}create-pr${E} — turn this branch into a PR" \
      "${G}pr-status${E} — check PR state for this branch" ;;
    push) printf '%s\n' \
      "${G}pr-status${E} — check PR state for this branch" \
      "${G}view-branch-history${E} — this branch's life story in chat" ;;
    commit-only) printf '%s\n' \
      "${G}commit-and-push${E} — commit and push in one go" \
      "${G}amend-msg${E} — reword the last commit" ;;
    create-pr) printf '%s\n' \
      "${G}view-pr${E} — see PR details in chat" \
      "${G}merge-pr${E} — merge when checks pass" ;;
    merge-pr) printf '%s\n' \
      "${G}create-release${E} — cut a release from the base branch" \
      "${G}clean-branches${E} — delete merged branches" ;;
    create-release) printf '%s\n' \
      "${G}view-releases${E} — list releases in chat" \
      "${G}open-releases${E} — open the releases page in the browser" ;;
    create-branch) printf '%s\n' \
      "${G}commit-only${E} — commit your changes here" \
      "${G}checkout-branch${E} — jump back to another branch" ;;
    stash) printf '%s\n' \
      "${G}pop-stash${E} — restore this stash later" \
      "${G}view-stashes${E} — list stashes in chat" ;;
    pull-rebase) printf '%s\n' \
      "${G}view-branches${E} — list branches with state in chat" \
      "${G}update-branch${E} — sync this branch with its base" ;;
    squash) printf '%s\n' \
      "${G}amend-msg${E} — reword the last commit" \
      "${G}undo-commit${E} — undo the last commit, keep the changes" ;;
    remove-collaborator) printf '%s\n' \
      "${G}view-collaborators${E} — list collaborators with status in chat" \
      "${G}add-collaborator${E} — invite someone new" ;;
    add-collaborator) printf '%s\n' \
      "${G}request-review${E} — request a PR review from a collaborator" \
      "${G}view-collaborators${E} — list collaborators with status in chat" ;;
    create-repo) printf '%s\n' \
      "${G}commit-and-push${E} — commit everything and push to the new repo" \
      "${G}init-gitignore${E} — set up .gitignore for this stack" ;;
    init-gitignore) printf '%s\n' \
      "${G}commit-only${E} — commit the ignore setup" \
      "${G}refresh-ignore${E} — re-apply ignore rules to already-tracked files" ;;
    update-branch) printf '%s\n' \
      "${G}pull-rebase${E} — pull with rebase, keep history linear" \
      "${G}merge-branch${E} — merge another branch into this one" ;;
    *) return 1 ;;
  esac
}

tip_enabled() {
  case "$1" in
    commit-and-push|commit-only|create-pr|merge-pr|create-release|push) return 0 ;;
    *) return 1 ;;
  esac
}

rel="$(related "$cmd" 2>/dev/null)" || exit 0
printf '**Tips**\n'
printf '%s\n' "$rel" | sed 's/^/  /'

tip_enabled "$cmd" || exit 0
git_dir="$(git rev-parse --git-dir 2>/dev/null)" || exit 0

tips=()
# state triggers in priority order; skip one whose command is already in Related
n=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -gt 0 ] && ! printf '%s' "$rel" | grep -q "pop-stash"; then
  [ "$n" = 1 ] && tips+=("${G}pop-stash${E} — you have 1 stash waiting") || tips+=("${G}pop-stash${E} — you have $n stashes waiting")
fi
if [ "${#tips[@]}" -lt 2 ] && git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  n=$(git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)
  if [ "$n" -gt 0 ] && ! printf '%s' "$rel" | grep -q "pull-rebase"; then
    tips+=("${G}pull-rebase${E} — origin is $n commit(s) ahead of you")
  fi
fi
if [ "${#tips[@]}" -lt 2 ]; then
  n=$(git branch --merged 2>/dev/null | grep -vcE '^\*|^\s*(main|master|develop)$' || true)
  if [ "$n" -gt 0 ] && ! printf '%s' "$rel" | grep -q "clean-branches"; then
    tips+=("${G}clean-branches${E} — $n merged branch(es) can be deleted")
  fi
fi

# rotation fallback fills up to 2 total; counter kept in .git
if [ "${#tips[@]}" -lt 2 ]; then
  lines=(
    "${G}blame${E} — who last touched each line of a file"
    "${G}squash${E} — squash the last N commits into one"
    "${G}cherry-pick${E} — apply a commit from another branch"
    "${G}add-to-ignore${E} — add a path to .gitignore properly"
    "${G}repo-info${E} — repo summary in chat"
    "${G}view-notifications${E} — GitHub notifications in chat"
    "${G}open-compare${E} — open a branch comparison in the browser"
    "${G}open-file-history${E} — open a file's history on GitHub"
    "${G}create-gist${E} — share a file as a gist"
    "${G}rename-branch${E} — rename local + remote branch safely"
    "${G}pr-desc${E} — rewrite a PR description"
    "${G}view-tags${E} — list tags in chat"
  )
  f="$git_dir/git-ops-suggest-idx"
  i=$(cat "$f" 2>/dev/null | tr -dc '0-9' || true); i="${i:-0}"
  while [ "${#tips[@]}" -lt 2 ]; do
    tips+=("${lines[$(( i % ${#lines[@]} ))]}")
    i=$(( (i + 1) % ${#lines[@]} ))
  done
  echo "$i" > "$f" 2>/dev/null || true
fi

printf '  %s\n' "${tips[@]}"
