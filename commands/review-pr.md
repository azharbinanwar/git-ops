---
description: Check out a PR locally and show its diff, so you can actually read it before deciding
argument-hint: [PR number]
allowed-tools: Bash(gh pr checkout:*), Bash(gh pr diff:*), Bash(gh pr view:*)
model: haiku
disable-model-invocation: true
---
Run `gh pr view <number>` for title/description, then `gh pr checkout <number>` to switch to it locally, then `gh pr diff <number>` to show the actual changes. Report a summary of what changed, not the raw full diff if it's long.

PR number: $ARGUMENTS
