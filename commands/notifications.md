---
description: Check unread GitHub notifications
allowed-tools: Bash(gh api:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Unread notifications: !`gh api notifications --jq '.[] | .repository.full_name + "  " + .subject.type + "  " + .subject.title' 2>&1 || true`

## Task
List each unread notification from Context above: repo, type (PR/issue/mention), title, newest first. If empty, say there are none. Do not run any commands — the data is already there.
