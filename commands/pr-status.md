---
description: List your open PRs with CI/review status at a glance
allowed-tools: Bash(gh pr status:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- PR status: !`gh pr status 2>&1 || true`

## Task
From Context above, show each of your open PRs as one line: number, title, CI status (passing/failing/pending), review status. If there are none, say so. Then say `/view-pr <number-or-text>` to see one in full. Do not run any commands — the data is already there.
