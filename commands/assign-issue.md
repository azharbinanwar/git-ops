---
description: Assign an issue to yourself or another developer
argument-hint: "[issue number] [username, or "me"]"
allowed-tools: Bash(gh issue edit:*)
model: haiku
effort: low
disable-model-invocation: true
---
Work out who: "me"/"myself"/empty → `@me`; otherwise the given username. Run `gh issue edit <n> --add-assignee <who>`. Report confirmation.

Issue number and assignee: $ARGUMENTS
