---
description: Change this repo's visibility (public/private) — shows consequences first, real picker
allowed-tools: Bash(gh repo view:*), Bash(gh repo edit:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Repo: !`gh repo view --json nameWithOwner,visibility,stargazerCount,forkCount --jq '"\(.nameWithOwner) — currently \(.visibility) (stars:\(.stargazerCount) forks:\(.forkCount))"' 2>&1 || true`

## Task
Report the current visibility from Context above. Then present two options via the option-picker tool (never plain text) — only offer the direction that changes something:
- **Make private** (when currently public) — warn in the option description: existing stars, forks, and watchers are permanently lost.
- **Make public** (when currently private) — warn in the option description: the ENTIRE history becomes visible to everyone — any secret ever committed leaks; check old commits first.
- **Fix something first** — ends the turn; nothing changes; wait. A typed correction = the fix: apply it, then re-show this picker.

On pick, run: `gh repo edit --visibility <private|public> --accept-visibility-change-consequences` (retry once without the flag if an older gh rejects it). Report the result and the new visibility.
