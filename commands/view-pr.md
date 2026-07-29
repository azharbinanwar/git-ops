---
description: View one PR's full details — by number, or search by title text
argument-hint: [PR number, or title text to search for]
allowed-tools: Bash(gh pr view:*), Bash(gh pr list:*)
model: haiku
disable-model-invocation: true
---
If $ARGUMENTS is a number, run `gh pr view <number>` directly. If it's text instead, search open PRs by title (`gh pr list --search "<text>"`) and show the best match's full details the same way — or, if more than one is a close match, list those few candidates and ask which one instead of guessing.

Report: title, author, branch, status, CI, review status, description, and recent comments — read-only, no actions offered.

PR number or title text: $ARGUMENTS
