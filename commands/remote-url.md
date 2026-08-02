---
description: Print the remote URL (https or ssh)
allowed-tools: Bash(git remote:*)
model: haiku
disable-model-invocation: true
---
## Context
- Remote URL: !`git remote get-url origin 2>/dev/null || echo "no origin remote set"`

## Task
Output just the URL from Context above, nothing else. Do not run any commands — the answer is already there.
