---
description: Undo the last commit, keep changes staged — like GitHub Desktop's Undo button
allowed-tools: Bash(git log:*), Bash(git reset:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the last commit (`git log -1 --oneline`). Check if it's already pushed (compare HEAD to its upstream via `git rev-parse @{u}` if one is set). If it is, warn clearly: undoing it will put your local branch behind the remote — syncing back up would need a force-push, which rewrites shared history.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Undo it** — runs `git reset --soft HEAD~1`. Report that the commit is gone and its changes are now staged, ready to re-commit.
- **Fix something first** — ends the turn immediately, nothing undone. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.
