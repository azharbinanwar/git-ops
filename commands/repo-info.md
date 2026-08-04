---
description: Repo card — visibility, branch, community, activity, last release, next actions
allowed-tools: Bash(gh repo view:*), Bash(gh release list:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Repo: !`gh repo view --json nameWithOwner,visibility,defaultBranchRef,stargazerCount,forkCount,watchers,issues,pullRequests,pushedAt,url --jq '"\(.nameWithOwner)|\(.visibility)|\(.defaultBranchRef.name)|\(.stargazerCount)|\(.forkCount)|\(.watchers.totalCount)|\(.issues.totalCount)|\(.pullRequests.totalCount)|\(.pushedAt)|\(.url)"' 2>&1 || true`
- Last release: !`gh release list --limit 1 2>&1 || true`

## Task
From Context above only (run nothing), render exactly this card (fields in order: name|visibility|default branch|stars|forks|watchers|issues|PRs|pushedAt|url):

```
Repo:        <name> (<VISIBILITY> — /change-visibility to change)
Branch:      <default> (default)
Community:   <stars> stars · <forks> forks · <watchers> watching
Activity:    <issues> open issues · <PRs> open PRs · last push <relative age from pushedAt>
Release:     <tag + date, or "none yet">
URL:         <url>

→ /view-prs · /view-issues · /open-releases · /open-repo
```
