---
description: Close an issue with a closing comment
argument-hint: "[issue number] [reason]"
allowed-tools: Bash(gh issue close:*), Bash(gh issue view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Confirm the issue exists and show its title. If a reason/comment is given, never mention AI, Claude, or "generated with" in it.

Present two options via the option-picker tool (never plain text):
- **Close** — runs `gh issue close <n> --comment "<reason>"` if a reason was given, else just `gh issue close <n>`. Report confirmation.
- **Fix something first** — ends the turn immediately, nothing closed. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Issue number and reason: $ARGUMENTS
