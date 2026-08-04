---
description: Suggest a branch name from what you're about to do, create and switch to it
argument-hint: [what you're about to work on]
model: haiku
effort: low
allowed-tools: Bash(git branch:*), Bash(git checkout:*)
disable-model-invocation: true
---
## Context
- Open changes: !`git status --porcelain 2>/dev/null | wc -l`
- Recent branches: !`git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | head -8`

## Task
If "Open changes" above is not 0, warn in one line that switching branches would put uncommitted work at risk and stop. Otherwise suggest a short kebab-case branch name from the description below (e.g. "fix login bug" → `fix/login-bug`), matching the style visible in "Recent branches", then run `git checkout -b <name>` and report the branch name. The Context above is the only data needed — run nothing else.

What you're about to work on: $ARGUMENTS
