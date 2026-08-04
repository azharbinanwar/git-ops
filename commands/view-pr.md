---
description: View one PR's full details — by number, or search by title text
argument-hint: [PR number, or title text to search for]
allowed-tools: Bash(gh pr view:*), Bash(gh pr list:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- PR (valid when a number was given): !`gh pr view $ARGUMENTS --json number,title,author,headRefName,baseRefName,state,url,mergedAt,mergeCommit,reviewDecision,body,statusCheckRollup,comments --jq '{n:.number,t:.title,by:.author.login,from:.headRefName,to:.baseRefName,state:.state,url:.url,merged:(.mergedAt//""),commit:((.mergeCommit.oid//"")[0:7]),review:(.reviewDecision|if .==null or .=="" then "none" else . end),checks:[.statusCheckRollup[]?|{c:.name,r:(.conclusion//.status)}][0:10],body:.body,comments:[.comments[]?|{by:.author.login,text:.body}][-5:]}' 2>&1 || true`

## Task
If the "PR" context above is valid JSON, render it — run nothing. If it shows an error (text was given instead of a number), search with `gh pr list --search "$ARGUMENTS"` and view the best match the same compact way — if several match closely, list them and ask which one instead of guessing.

Report: title, author, branch → base, state (+ merged at / squash commit when merged), CI per check, review status, URL, then the description quoted, then the last comments (or "none"). Read-only, no actions offered.

PR number or title text: $ARGUMENTS
