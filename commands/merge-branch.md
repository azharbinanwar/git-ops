---
description: Merge one local branch into another — direct git merge, not a PR
argument-hint: "[branch to merge in]"
allowed-tools: Bash(git branch:*), Bash(git log:*), Bash(git merge:*), Bash(git status:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the current branch, the branch to merge in, and how many commits it's ahead by. Warn if there are uncommitted local changes that could conflict.

Present two options via the option-picker tool (never plain text):
- **Merge it** — runs `git merge <branch>`. If it results in a conflict, report the exact conflicting files and stop — never auto-resolve; tell the user to resolve manually or `git merge --abort`.
- **Fix something first** — ends the turn immediately, nothing merged. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Branch to merge in: $ARGUMENTS
