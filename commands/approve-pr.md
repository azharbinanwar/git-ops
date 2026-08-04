---
description: Approve a PR, with an optional comment
argument-hint: [PR number, or nothing for current branch's PR] [comment]
allowed-tools: Bash(gh pr review:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's). Show its title and CI status — flag clearly if CI is still failing before offering to approve. If a comment is given, never mention AI, Claude, or "generated with" in it.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Approve** — runs `gh pr review <n> --approve --body "<comment>"` (or without `--body` if no comment given). Report confirmation.
- **Fix something first** — ends the turn immediately, nothing approved. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Target and comment: $ARGUMENTS
