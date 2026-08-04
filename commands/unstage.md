---
description: Unstage one specific file — undoes git add, keeps the changes
argument-hint: [file path]
model: haiku
effort: low
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---
- Result: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/unstage.sh" $ARGUMENTS`

Report the result above in one or two lines. If it starts with "error:", report that line instead. Do not run any commands — the script already did the work.
