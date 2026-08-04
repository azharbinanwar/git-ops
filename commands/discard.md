---
description: Discard uncommitted changes to one file — this loses that work, confirm first
argument-hint: [file path]
allowed-tools: Bash(git diff:*), Bash(git restore:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show what will be lost — a short summary of `git diff <file>`, not the whole diff if it's long.

Present two options via the option-picker tool (never plain text):
- **Discard** — runs `git restore <file>`, permanently reverting it to the last committed version. This deletes the uncommitted changes — there is no undo.
- **Fix something first** — ends the turn immediately, nothing discarded. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

File: $ARGUMENTS
