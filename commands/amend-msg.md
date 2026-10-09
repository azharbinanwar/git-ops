---
description: Change only the last commit's message — content untouched
argument-hint: "[new commit message]"
allowed-tools: Bash(git log:*), Bash(git rev-parse:*), Bash(bash:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the last commit's current message. Check if it's already pushed (compare to upstream) — if so, warn that amending rewrites the commit hash and needs a force-push to sync, which rewrites shared history.

If $ARGUMENTS is empty, ask for the new message instead of guessing one.

Present two options via the option-picker tool (never plain text):
- **Amend** — runs exactly one command: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/amend-msg.sh"` with the new message piped to stdin via heredoc. The script changes the message only — staged changes are never folded into the commit. Report its output verbatim.
- **Fix something first** — ends the turn immediately, nothing changed. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

New message: $ARGUMENTS
