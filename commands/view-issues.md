---
description: List open issues (companion to /pr-status)
allowed-tools: Bash(gh issue list:*)
model: haiku
disable-model-invocation: true
---
## Context
- Open issues: !`gh issue list 2>&1 || true`

## Task
From Context above, show each issue as one line: number, title, labels, how long ago opened. If there are none, say so. Then say `/view-issue <number-or-text>` to see one in full. Do not run any commands — the data is already there.
