---
description: Push existing commits — shows exactly what goes out first, sets upstream if missing, never forces
allowed-tools: Bash(bash:*), Bash(git log:*), Bash(git rev-parse:*), Bash(git branch:*), Bash(git rev-list:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Branch: !`git branch --show-current 2>/dev/null || echo "detached"`
- Upstream: !`git rev-parse --abbrev-ref '@{u}' 2>/dev/null || echo "none set"`
- Unpushed: !`git log '@{u}..HEAD' --oneline 2>/dev/null | head -10 || git log --oneline -5 2>/dev/null`
- Behind: !`git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo "-"`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" push`

## Task
From Context only (run nothing to gather data):
- Nothing in "Unpushed" (and an upstream exists) → say the branch is even with its upstream; stop.
- "Behind" greater than 0 → flag it clearly: the push may be rejected; suggest `/pull-rebase` first. Still offer the picker.
- No upstream → say the push will create `origin/<branch>` and set tracking.

Show the unpushed commits (reproduce the "Unpushed" lines) and present two options via the option-picker tool (never plain text):
- **Push** — runs exactly one command: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/push.sh"`. The script sets upstream when missing and refuses to force by construction. Report its output verbatim; if it contains "PUSH FAILED", relay it and stop — run nothing else.
- **Cancel** — ends the turn immediately, nothing pushed.

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim. Omit it entirely — silently, never mentioning it — if it is empty, shows an error, or failed to load, and when the action failed or was cancelled.
