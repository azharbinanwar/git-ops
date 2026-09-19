---
description: A branch's life story in chat — created from where, merges in and out, work totals, annotated graph
argument-hint: "[branch, defaults to current] [base branch]"
allowed-tools: Bash(bash:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- History: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/branch-history.sh" $ARGUMENTS`

## Task
Reproduce the History block above verbatim inside a single code fence — it is already formatted (Timeline, Status, Work, Graph). Run no commands. If it starts with "error:", report that line alone and, when the branch name looks mistyped, suggest `/view-branches` to list real ones.
