---
description: Open a compare/diff view between two branches on GitHub
argument-hint: [branch1...branch2, defaults to default-branch...current]
model: haiku
effort: low
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---
- Opened: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/open.sh" compare $ARGUMENTS`

Report the URL above in one line. If it starts with "error:", report that line instead. Do not run any commands — the script already did the work.
