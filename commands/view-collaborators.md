---
description: List this repo's collaborators in chat — permission level and invite status for each
allowed-tools: Bash(gh api:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Collaborators: !`gh api 'repos/{owner}/{repo}/collaborators' --jq '.[] | "\(.login) | \(.role_name) | active"' 2>/dev/null || true`
- Pending invites: !`gh api 'repos/{owner}/{repo}/invitations' --jq '.[] | "\(.invitee.login) | \(.permissions) | pending since \(.created_at[:10])"' 2>/dev/null || true`

## Task
From Context above only (run nothing), show one line per person, collaborators first then pending invites:
`<username> — <permission> (active)` / `<username> — <permission> (invite pending since <date>)`.
If both lists are empty: say `No collaborators besides the owner.` End with: `/git-ops:add-collaborator` to invite someone.
