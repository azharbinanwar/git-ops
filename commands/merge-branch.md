---
description: Merge one local branch into another — direct git merge, not a PR
argument-hint: [branch to merge in]
allowed-tools: Bash(git branch:*), Bash(git log:*), Bash(git merge:*), Bash(git status:*)
disable-model-invocation: true
---
Show the current branch, the branch to merge in, and how many commits it's ahead by. Warn if there are uncommitted local changes that could conflict.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Merge it** — runs `git merge <branch>`. If it results in a conflict, report the exact conflicting files and stop — never auto-resolve; tell the user to resolve manually or `git merge --abort`.
- **Fix something first** — ends the turn immediately, nothing merged. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Branch to merge in: $ARGUMENTS
