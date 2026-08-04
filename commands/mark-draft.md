---
description: Convert an existing PR back to draft status (not for creating a new PR as draft)
allowed-tools: Bash(gh pr ready:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
If there's no PR for this branch, say so and stop. Otherwise run `gh pr ready --undo` (converts the existing open PR back to draft status). Report confirmation.
