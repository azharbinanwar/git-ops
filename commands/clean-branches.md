---
description: Delete local branches already merged into the default branch — lists them first
allowed-tools: Bash(git branch:*), Bash(git symbolic-ref:*)
disable-model-invocation: true
---
Detect the default branch (`git symbolic-ref refs/remotes/origin/HEAD`, fall back to `main`). List local branches already merged into it (`git branch --merged <default>`), excluding the default branch itself and the current branch.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Delete them** — runs `git branch -d <each>` for every branch listed (safe delete, only succeeds if actually merged). Report which were deleted.
- **Fix something first** — ends the turn immediately, nothing deleted. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.
