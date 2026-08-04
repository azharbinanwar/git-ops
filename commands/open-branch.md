---
description: Open a branch's file tree on GitHub — current branch if none given
argument-hint: "[optional: branch name]"
model: haiku
effort: low
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---
- Opened: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/open.sh" branch $ARGUMENTS`

Report the URL above in one line. If it starts with "error:", report that line instead. Do not run any commands — the script already did the work.
