---
description: List your open PRs with CI/review status at a glance
allowed-tools: Bash(gh pr list:*), Bash(date:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Now (UTC): !`date -u '+%Y-%m-%dT%H:%MZ' 2>/dev/null || true`
- Open PRs: !`gh pr list --author "@me" --json number,title,headRefName,baseRefName,url,createdAt,reviewDecision,mergeable,statusCheckRollup --jq '.[] | {n:.number,t:.title,from:.headRefName,to:.baseRefName,url:.url,created:.createdAt,review:(.reviewDecision//"none"),mergeable:.mergeable,checks:[.statusCheckRollup[]?|(.conclusion//.status)][0:12]}' 2>&1 || true`

## Task
From Context above only (run nothing), render each PR in exactly this 3-line shape:

```
- #<n>  <title>    OPEN · <age: Now minus created, e.g. "2h old" / "3d old">
      <from> → <to> · CI <✓ passing | ✗ failing | … pending | none> · review: <approved | changes requested | none yet> · mergeable <✓|✗|?>
      <url>
```

CI: ✗ if any check is FAILURE/ERROR; … if any is PENDING/IN_PROGRESS/QUEUED; ✓ if all SUCCESS/SKIPPED/NEUTRAL; "none" if the checks list is empty. mergeable: ✓ MERGEABLE, ✗ CONFLICTING, ? otherwise.

If there are no PRs: say `No open PRs.` End with: `/view-pr <number-or-text>` to see one in full.
