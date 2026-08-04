---
description: All branches as a table — age, state, PR, creator
allowed-tools: Bash(bash:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Branches: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/view-branches.sh"`

## Task
From Context above only (run nothing), render one aligned monospace table (pad columns with spaces, in a code block):

```
BRANCH                     AGE   STATE        PR         WHO
> feat/token-optimization  40s   ahead 2      #12 open   Azhar
  fix/dark-mode            3d    merged ✓     #9 merged  Azhar
  main (default)           2h    —            —          —
  hotfix/crash (remote)    —     not local    —          —
```

Rules: `>` marks the current branch; `(default)` and `(remote)` as suffixes; AGE compact (40s/2h/3d); STATE = `ahead N` (unpushed commits) / `merged ✓` / `not merged` / `local only` / `not local` / `—` for the default; PR = `#N state` or `—`; WHO = creator's first name or `—`. Remote-only names come from the `---remote-only---` section (skip ones that already have a local row).

End with: `<N> branches · /checkout-branch · /delete-branch · /open-branches`. If the context starts with "error:", report that line instead.
