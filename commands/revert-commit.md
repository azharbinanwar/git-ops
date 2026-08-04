---
description: Safely undo a pushed commit by creating an opposite commit — history stays intact
argument-hint: [commit hash, or nothing for the last commit]
allowed-tools: Bash(git log:*), Bash(git revert:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Recent commits: !`git log --oneline -5 2>/dev/null || true`

## Task
Target: $ARGUMENTS if it names a commit from the log above (or any valid hash), otherwise the most recent commit. Show the target commit (hash + message) plainly.

Present two options via the option-picker tool (never plain text):
- **Revert it** — runs `git revert <hash> --no-edit`, creating a new commit that undoes it. History is preserved — this is the safe undo for commits that are already pushed (unlike `/undo-commit`, which rewrites and is only for unpushed ones). The revert commit itself is NOT pushed — `/commit-and-push` flow or `git push` when ready.
- **Fix something first** — ends the turn; nothing reverted; wait. A typed correction = the fix: apply it, then re-show this picker.

On conflict: report the exact conflicting files and stop — never auto-resolve; mention `git revert --abort`. On success report the new revert commit's hash.

Commit (optional, defaults to last): $ARGUMENTS
