---
description: List all tags with dates
allowed-tools: Bash(git tag:*)
model: haiku
disable-model-invocation: true
---
## Context
- Tags (newest first): !`git tag --sort=-creatordate --format='%(refname:short)  %(creatordate:short)' 2>/dev/null || true`

## Task
Show the tag list from Context above as-is. If it's empty, say there are no tags. Do not run any commands — the answer is already there.
