---
description: Close a PR without merging
argument-hint: [PR number, or nothing for current branch's PR] [reason]
allowed-tools: Bash(gh pr close:*), Bash(gh pr view:*)
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's). Show its title. If a reason/comment is given, never mention AI, Claude, or "generated with" in it.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Close** — runs `gh pr close <n> --comment "<reason>"` if a reason was given, else just `gh pr close <n>`. Report confirmation.
- **Fix something first** — ends the turn immediately, nothing closed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Target and reason: $ARGUMENTS
