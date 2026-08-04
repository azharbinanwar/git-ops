---
description: Approve a PR, with an optional comment
argument-hint: "[PR number, or nothing for current branch's PR] [comment]"
allowed-tools: Bash(gh pr review:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's). Show its title and CI status — flag clearly if CI is still failing before offering to approve. If a comment is given, never mention AI, Claude, or "generated with" in it.

Present two options via the option-picker tool (never plain text):
- **Approve** — runs `gh pr review <n> --approve --body "<comment>"` (or without `--body` if no comment given). Report confirmation.
- **Fix something first** — ends the turn immediately, nothing approved. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Target and comment: $ARGUMENTS
