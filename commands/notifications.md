---
description: Check unread GitHub notifications
allowed-tools: Bash(gh api:*)
model: haiku
disable-model-invocation: true
---
Run `gh api notifications`. List each unread notification's repo, type (PR/issue/mention), and title, newest first. If none, say so.
