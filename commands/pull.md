---
description: Safe pull — fetch + merge, offers Pull anyway / Stash first / Cancel if it could conflict
argument-hint: "[branch name, defaults to current branch]"
allowed-tools: Bash(git fetch:*), Bash(git status:*), Bash(git log:*), Bash(git pull:*), Bash(git stash:*)
model: haiku
effort: low
disable-model-invocation: true
---
Target: $ARGUMENTS if given (a branch name), otherwise the current branch.

Run `git fetch` first. Report how many commits behind/ahead the target is versus its remote counterpart.

If there are uncommitted local changes that could conflict, present three real selectable options using the option-picker tool, not plain-text yes/no:
- **Pull anyway** — if targeting the current branch, runs `git pull`; if targeting another branch, runs `git fetch origin <branch>:<branch>` (a direct fast-forward update without switching branches — fails safely rather than guessing if it isn't a fast-forward). If it results in a conflict, report the exact conflicting files and stop — never auto-resolve; tell the user to resolve manually or `git merge --abort`.
- **Stash first** — runs `git stash push -m "before pull"`, then does the pull above, then tells the user the stash is saved (`git stash pop` to bring it back).
- **Cancel** — ends the turn immediately, nothing pulled, nothing changed.

If there are no uncommitted changes at all, skip the picker and just do the pull directly (same logic as "Pull anyway" above), reporting the result.

Branch (optional, defaults to current): $ARGUMENTS
