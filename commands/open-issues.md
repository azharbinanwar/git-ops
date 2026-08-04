---
description: Open the issues list page on GitHub
model: haiku
effort: low
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---
- Opened: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/open.sh" issues`

Report the URL above in one line. If it starts with "error:", report that line instead. Do not run any commands — the script already did the work.
