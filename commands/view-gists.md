---
description: List your gists
allowed-tools: Bash(gh gist list:*)
model: haiku
disable-model-invocation: true
---
## Context
- Gists: !`gh gist list 2>&1 || true`

## Task
From Context above, show each gist as one line: ID, description, visibility (public/secret), file count, how long ago updated. If there are none, say so. Then say `/view-gist <id>` to see one in full. Do not run any commands — the data is already there.
