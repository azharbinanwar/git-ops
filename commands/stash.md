---
description: Stash your changes with a name, so you can find it later
argument-hint: [stash name]
model: haiku
effort: low
allowed-tools: Bash(bash:*)
disable-model-invocation: true
---
- Result: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/stash.sh" $ARGUMENTS`

Report the result above in one line. If it says a name is required, suggest one short kebab-case name derived from the listed changed files and ask in one line — e.g. `Name for the stash? (suggestion: readme-tweaks)` — then wait; stash nothing until the user answers. When they answer (or their message reads as a request rather than a name, like "can you stash for me"), use the suggestion or their actual words as a proper name — never a conversational sentence. For any other "error:" line, report it as is. Do not run any commands yourself except, after the user confirms a name, exactly: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/stash.sh" <name>`.
