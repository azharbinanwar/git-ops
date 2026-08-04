---
description: Unread GitHub notifications — what needs you first, watching-noise after
allowed-tools: Bash(gh api:*), Bash(date:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Now (UTC): !`date -u '+%Y-%m-%dT%H:%MZ' 2>/dev/null || true`
- Unread: !`gh api notifications --jq '.[] | {repo:.repository.full_name,type:.subject.type,title:.subject.title,reason:.reason,at:.updated_at,num:(.subject.url//"" | split("/") | last)}' 2>&1 || true`

## Task
From Context above only (run nothing), render exactly this shape — reasons `review_requested`, `mention`, `assign`, `author`, `team_mention` go under **Needs you**; everything else (`subscribed`, `state_change`, …) under **Just watching** (omit an empty group):

```
Needs you
  - <reason in plain words>   <repo short name> #<num>  <title>   <age from at vs Now>
Just watching
  - <reason>   <repo short name> #<num>  <title>   <age>

<N> unread — /open-notifications to act on them
```

Plain-words reasons: review_requested → "review requested", mention → "mentioned you", assign → "assigned to you", author → "your thread", subscribed → "subscribed". Shorten repo to its name only when all notifications share one owner. If empty: say `No unread notifications.`
