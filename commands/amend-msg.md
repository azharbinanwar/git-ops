---
description: Change only the last commit's message — content untouched
argument-hint: "[new commit message]"
allowed-tools: Bash(git log:*), Bash(git commit:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the last commit's current message. Check if it's already pushed (compare to upstream) — if so, warn that amending rewrites the commit hash and needs a force-push to sync, which rewrites shared history.

If $ARGUMENTS is empty, ask for the new message instead of guessing one.

Present two options via the option-picker tool (never plain text):
- **Amend** — runs `git commit --amend -m "<new message>"` (content unchanged). Report the new commit hash.
- **Fix something first** — ends the turn immediately, nothing changed. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

New message: $ARGUMENTS
