---
description: List releases here in chat — latest first, with total count
allowed-tools: Bash(gh release list:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Releases (latest 15): !`gh release list --limit 15 --json tagName,name,isLatest,isPrerelease,isDraft,publishedAt --jq '.[] | "\(.tagName) | \(.name) | \(if .isDraft then "draft" elif .isPrerelease then "pre-release" elif .isLatest then "LATEST" else "" end) | \(.publishedAt[0:10])"' 2>&1 || true`
- Total: !`gh release list --limit 1000 --json tagName --jq 'length' 2>/dev/null || echo "?"`

## Task
From Context above only (run nothing), one line per release: tag, name, badge (LATEST / pre-release / draft, when present), date. If none: say `No releases yet.` and stop.

End with: `Showing <shown> of <Total>` (omit when all are shown) and `— /open-releases for the browser view, /create-release to publish a new one.`
