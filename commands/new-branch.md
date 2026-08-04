---
description: Suggest a branch name from what you're about to do, create and switch to it
argument-hint: [what you're about to work on]
allowed-tools: Bash(git branch:*), Bash(git checkout:*), Bash(git status:*)
model: haiku
effort: low
disable-model-invocation: true
---
If there are uncommitted changes that switching branches would put at risk, warn in one line and stop instead of switching. Otherwise suggest a short kebab-case branch name from the description (e.g. "fix login bug" → `fix/login-bug`), following the repo's existing branch naming style if visible in recent branches. Create and switch to it: `git checkout -b <name>`. Report the branch name.

What you're about to work on: $ARGUMENTS
