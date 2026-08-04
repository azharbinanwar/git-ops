---
description: Open a file's commit history on GitHub in the browser
argument-hint: "[file path]"
model: haiku
effort: low
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---
- Opened: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/open.sh" file-history $ARGUMENTS`

Report the URL above in one line. If it starts with "error:", report that line instead. Do not run any commands — the script already did the work.
