---
description: Quick repo stats — stars, open issues, open PRs, last release
allowed-tools: Bash(gh repo view:*), Bash(gh release list:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Repo stats: !`gh repo view --json stargazerCount,issues,pullRequests,visibility --jq '"visibility: \(.visibility)  stars: \(.stargazerCount)  open issues: \(.issues.totalCount)  open PRs: \(.pullRequests.totalCount)"' 2>&1 || true`
- Last release: !`gh release list --limit 1 2>&1 || true`

## Task
Report the stats from Context above as a few short lines: visibility (mention `/change-visibility` if they want to change it), stars, open issues, open PRs, last release + date (or "no releases yet"). Do not run any commands — the data is already there.
