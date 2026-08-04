---
description: Add labels to an issue, suggesting likely ones from context
argument-hint: "[issue number]"
allowed-tools: Bash(gh issue edit:*), Bash(gh label list:*), Bash(gh issue view:*)
model: haiku
effort: low
disable-model-invocation: true
---
List the repo's existing labels (`gh label list`), suggest 1-3 that plausibly fit based on the issue's title and body, then add them: `gh issue edit <n> --add-label "..."`. Report what was added.

Issue number: $ARGUMENTS
