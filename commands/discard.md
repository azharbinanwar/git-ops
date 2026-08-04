---
description: Discard uncommitted changes to one file — this loses that work, confirm first
argument-hint: [file path]
allowed-tools: Bash(git diff:*), Bash(git restore:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show what will be lost — a short summary of `git diff <file>`, not the whole diff if it's long.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Discard** — runs `git restore <file>`, permanently reverting it to the last committed version. This deletes the uncommitted changes — there is no undo.
- **Fix something first** — ends the turn immediately, nothing discarded. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

File: $ARGUMENTS
