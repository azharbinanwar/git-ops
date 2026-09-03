---
description: Pull with rebase instead of merge — keeps history linear, offers Pull anyway / Stash first / Cancel
argument-hint: "[branch name, defaults to current branch]"
allowed-tools: Bash(bash:*), Bash(git fetch:*), Bash(git status:*), Bash(git log:*), Bash(git pull:*), Bash(git stash:*)
model: haiku
effort: low
disable-model-invocation: true
---

## Context
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" pull-rebase`

Target: $ARGUMENTS if given (a branch name), otherwise the current branch. Note: rebase requires the target to actually be checked out — if it isn't the current branch, say so and suggest checking it out first instead of guessing.

Run `git fetch` first. Report how many commits behind/ahead the target is, and how many of "ahead" are unpushed local commits (these get new hashes after rebasing).

If there are uncommitted local changes that could conflict, present three real selectable options using the option-picker tool, not plain-text yes/no:
- **Pull anyway** — runs `git pull --rebase`. If it results in a conflict, report the exact conflicting files and stop — never auto-resolve; tell the user to resolve manually or `git rebase --abort`.
- **Stash first** — runs `git stash push -m "before pull-rebase"`, then does the rebase pull above, then tells the user the stash is saved (`git stash pop` to bring it back).
- **Cancel** — ends the turn immediately, nothing pulled, nothing changed.

If there are no uncommitted changes at all, skip the picker and just do the pull directly (same logic as "Pull anyway" above), reporting the result.

Branch (optional, defaults to current): $ARGUMENTS

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim (omit it entirely if empty, and omit it when the action failed or was cancelled).
