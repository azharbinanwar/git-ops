---
description: Pick a branch from a list and switch to it — guards your uncommitted work first
argument-hint: "[optional: branch name to switch to directly]"
allowed-tools: Bash(git branch:*), Bash(git checkout:*), Bash(git switch:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Open changes: !`git status --porcelain 2>/dev/null | wc -l`
- Local branches (recent first): !`git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | head -15`
- Remote-only branches: !`git branch -r --format='%(refname:short)' 2>/dev/null | head -15`

## Task
If "Open changes" above is not 0, warn in one line that switching risks uncommitted work (suggest `/stash` first) and stop.

If $ARGUMENTS names a branch, switch to it directly. Otherwise present the branches as a real option-picker: local branches first (exclude the current one), then remote-only ones (strip `origin/`, marked "remote — will be checked out tracking"). On pick, run `git checkout <name>` and report the branch you're now on. The Context above is the only data needed — run nothing else to gather.

Branch (optional): $ARGUMENTS
