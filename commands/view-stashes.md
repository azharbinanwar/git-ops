---
description: List all stashes with names, age, and what's inside each
allowed-tools: Bash(git stash:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Stashes: !`git stash list --format='%gd | %cr | %gs' 2>/dev/null || true`

## Task
From Context above only (run nothing), show one line per stash: reference, age, name/message. If empty: say `No stashes.` End with: `/pop-stash` to restore one.
