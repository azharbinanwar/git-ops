---
description: Check the latest GitHub Actions runs' pass/fail status
allowed-tools: Bash(gh run list:*)
model: haiku
disable-model-invocation: true
---
## Context
- Latest runs: !`gh run list --limit 5 2>&1 || true`

## Task
From Context above, report each run's workflow name, status (success/failure/in-progress), and how long ago, newest first. If empty, say there are no workflow runs. Do not run any commands — the data is already there.
