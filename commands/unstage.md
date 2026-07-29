---
description: Unstage one specific file — undoes git add, keeps the changes
argument-hint: [file path]
allowed-tools: Bash(git restore:*), Bash(git status:*)
model: haiku
disable-model-invocation: true
---
Run `git restore --staged <file>`. Confirm it's unstaged (still modified, just not staged) via `git status --short` for that file. Nothing else — the changes themselves are untouched.

File: $ARGUMENTS
