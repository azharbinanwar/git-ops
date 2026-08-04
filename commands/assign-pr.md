---
description: Assign a PR to yourself or another developer
argument-hint: "[PR number, or nothing for current branch's PR] [username, or "me"]"
allowed-tools: Bash(gh pr edit:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's if none given). Work out who: "me"/"myself"/empty → `@me`; otherwise the given username. Run `gh pr edit <n> --add-assignee <who>`. Report confirmation.

PR number and assignee: $ARGUMENTS
