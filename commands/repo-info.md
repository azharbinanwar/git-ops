---
description: Quick repo stats — stars, open issues, open PRs, last release
allowed-tools: Bash(gh repo view:*), Bash(gh release list:*)
model: haiku
disable-model-invocation: true
---
Run `gh repo view --json stargazerCount,issues,pullRequests` (or the closest available fields) plus `gh release list --limit 1`. Report as a few short lines: stars, open issues, open PRs, last release + date.
