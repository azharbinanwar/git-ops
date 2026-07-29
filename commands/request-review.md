---
description: Request review from someone on the current branch's PR
argument-hint: [github username]
allowed-tools: Bash(gh pr edit:*), Bash(gh pr view:*)
model: haiku
disable-model-invocation: true
---
If there's no PR for this branch, say so and stop. If $ARGUMENTS is empty, ask for the GitHub username in one line instead of guessing. Run `gh pr edit --add-reviewer <username>` against the current branch's PR. Report confirmation.

Reviewer username: $ARGUMENTS
