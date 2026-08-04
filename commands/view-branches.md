---
description: All branches with age, author, created-from, merged and pushed state
allowed-tools: Bash(bash:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Branches: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/view-branches.sh"`

## Task
From Context above only (run nothing), render the local branch rows as printed (they are pre-formatted: flags, name, age/author/origin, state). After them, list names appearing under `---remote-only---` that have no local row, as `remote only: <name>` lines (omit if none).

End with: `<N> branches — /checkout-branch to switch · /delete-branch to clean up · /open-branches for GitHub`. If the context starts with "error:", report that line instead.
