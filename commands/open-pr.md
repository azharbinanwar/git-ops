---
description: Open the current branch's PR (not the whole list) in the browser
allowed-tools: Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Run `gh pr view --web`. If there's no PR for this branch, say so in one line instead of opening anything.
