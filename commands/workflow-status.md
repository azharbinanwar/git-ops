---
description: Check the latest GitHub Actions runs' pass/fail status
allowed-tools: Bash(gh run list:*)
model: haiku
disable-model-invocation: true
---
Run `gh run list --limit 5`. Report each run's workflow name, status (success/failure/in-progress), and how long ago, newest first.
