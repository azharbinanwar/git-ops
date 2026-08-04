---
description: View one issue's full details — by number, or search by title text
argument-hint: "[issue number, or title text to search for]"
allowed-tools: Bash(gh issue view:*), Bash(gh issue list:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Issue (valid when a number was given): !`gh issue view $ARGUMENTS --json number,title,author,state,url,createdAt,labels,body,comments --jq '{n:.number,t:.title,by:.author.login,state:.state,url:.url,created:.createdAt,labels:[.labels[]?.name],body:.body,comments:[.comments[]?|{by:.author.login,text:.body}][-5:]}' 2>&1 || true`

## Task
If the "Issue" context above is valid JSON, render it — run nothing. If it shows an error (text was given instead of a number), search with `gh issue list --search "$ARGUMENTS"` and view the best match the same compact way — if several match closely, list them and ask which one instead of guessing.

Report: title, author, state, labels, created date, URL, then the body quoted, then the last comments (or "none"). Read-only, no actions offered.

Issue number or title text: $ARGUMENTS
