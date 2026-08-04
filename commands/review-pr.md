---
description: Check out a PR locally and show its diff, so you can actually read it before deciding
argument-hint: [PR number]
allowed-tools: Bash(gh pr checkout:*), Bash(gh pr diff:*), Bash(gh pr view:*)
model: haiku
effort: low
context: fork
background: false
disable-model-invocation: true
---
Run `gh pr view <number>` for title/description, then `gh pr checkout <number>` to switch to it locally, then `gh pr diff <number>` to read the actual changes. Your final report is what the user sees — the raw diff stays here in the fork, so summarize properly: what changed, where, anything risky. Note that the PR's branch is now checked out locally.

PR number: $ARGUMENTS
