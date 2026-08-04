---
description: Delete local branches already merged into the default branch — lists them first
allowed-tools: Bash(git branch:*), Bash(git symbolic-ref:*)
model: haiku
effort: low
disable-model-invocation: true
---
Detect the default branch (`git symbolic-ref refs/remotes/origin/HEAD`, fall back to `main`). List local branches already merged into it (`git branch --merged <default>`), excluding the default branch itself and the current branch.

Present two options via the option-picker tool (never plain text):
- **Delete them** — runs `git branch -d <each>` for every branch listed (safe delete, only succeeds if actually merged). Report which were deleted.
- **Fix something first** — ends the turn immediately, nothing deleted. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.
