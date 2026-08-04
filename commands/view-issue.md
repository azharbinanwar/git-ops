---
description: View one issue's full details — by number, or search by title text
argument-hint: [issue number, or title text to search for]
allowed-tools: Bash(gh issue view:*), Bash(gh issue list:*)
model: haiku
effort: low
disable-model-invocation: true
---
If $ARGUMENTS is a number, run `gh issue view <number>` directly. If it's text instead, search open issues by title (`gh issue list --search "<text>"`) and show the best match's full details the same way — or, if more than one is a close match, list those few candidates and ask which one instead of guessing.

Report: title, author, status, labels, body, and recent comments — read-only, no actions offered.

Issue number or title text: $ARGUMENTS
