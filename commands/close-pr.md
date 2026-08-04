---
description: Close a PR without merging
argument-hint: "[PR number, or nothing for current branch's PR] [reason]"
allowed-tools: Bash(gh pr close:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's). Show its title. If a reason/comment is given, never mention AI, Claude, or "generated with" in it.

Present two options via the option-picker tool (never plain text):
- **Close** — runs `gh pr close <n> --comment "<reason>"` if a reason was given, else just `gh pr close <n>`. Report confirmation.
- **Fix something first** — ends the turn immediately, nothing closed. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Target and reason: $ARGUMENTS
