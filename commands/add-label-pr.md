---
description: Add labels to a PR, suggesting likely ones from context
argument-hint: "[PR number, or nothing for current branch's PR]"
allowed-tools: Bash(gh pr edit:*), Bash(gh label list:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's if none given). List the repo's existing labels (`gh label list`), suggest 1-3 that plausibly fit based on the PR's title and diff, then add them: `gh pr edit <n> --add-label "..."`. Report what was added.

PR number (optional): $ARGUMENTS
