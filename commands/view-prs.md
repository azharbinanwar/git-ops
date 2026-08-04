---
description: List ALL open PRs in this repo (any author) with CI/review status
allowed-tools: Bash(gh pr list:*), Bash(date:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Now (UTC): !`date -u '+%Y-%m-%dT%H:%MZ' 2>/dev/null || true`
- Open PRs (all authors): !`gh pr list --json number,title,author,headRefName,baseRefName,url,createdAt,reviewDecision,mergeable,statusCheckRollup --jq '.[] | {n:.number,t:.title,by:.author.login,from:.headRefName,to:.baseRefName,url:.url,created:.createdAt,review:(.reviewDecision|if .==null or .=="" then "none" else . end),mergeable:.mergeable,checks:[.statusCheckRollup[]?|(.conclusion//.status)][0:12]}' 2>&1 || true`

## Task
From Context above only (run nothing), render each PR in exactly this 3-line shape:

```
- #<n>  <title>  (by <author>)    OPEN · <age from created vs Now>
      <from> → <to> · CI <✓ passing | ✗ failing | … pending | none> · review: <approved | changes requested | none yet> · mergeable <✓|✗|?>
      <url>
```

CI: ✗ if any check FAILURE/ERROR; … if any PENDING/IN_PROGRESS/QUEUED; ✓ if all SUCCESS/SKIPPED/NEUTRAL; "none" if empty. mergeable: ✓ MERGEABLE, ✗ CONFLICTING, ? otherwise.

If none: say `No open PRs in this repo.` End with: `/view-pr <number-or-text>` for one in full, `/pr-status` for just yours.
