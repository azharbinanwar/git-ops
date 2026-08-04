---
description: Change only the last commit's message — content untouched
argument-hint: [new commit message]
allowed-tools: Bash(git log:*), Bash(git commit:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the last commit's current message. Check if it's already pushed (compare to upstream) — if so, warn that amending rewrites the commit hash and needs a force-push to sync, which rewrites shared history.

If $ARGUMENTS is empty, ask for the new message instead of guessing one.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Amend** — runs `git commit --amend -m "<new message>"` (content unchanged). Report the new commit hash.
- **Fix something first** — ends the turn immediately, nothing changed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

New message: $ARGUMENTS
