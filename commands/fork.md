---
description: Fork a repo and clone it locally
argument-hint: [owner/repo, or nothing for the current repo]
allowed-tools: Bash(gh repo fork:*), Bash(git remote:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target repo — given `owner/repo`, or the current repo's remote if none given. Show what will happen: fork it under your account, and clone it into a new folder named after the repo (or add it as a remote if you're already inside a clone of the original).

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Fork it** — runs `gh repo fork <owner/repo> --clone` (or `--remote` if already inside a clone of the original). Report the resulting URL/path.
- **Fix something first** — ends the turn immediately, nothing forked. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Target (optional): $ARGUMENTS
