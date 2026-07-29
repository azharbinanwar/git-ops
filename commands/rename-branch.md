---
description: Rename the current branch, locally and on the remote
argument-hint: [new branch name]
allowed-tools: Bash(git branch:*), Bash(git push:*), Bash(git rev-parse:*)
disable-model-invocation: true
---
Show the current branch name. If $ARGUMENTS is empty, ask for the new name instead of guessing. Check if the current name is already pushed (has an upstream) — if so, note that the remote branch will need updating too (delete old, push new), and any open PR from this branch will need its head ref to catch up (GitHub usually handles this automatically once the new branch is pushed and old one deleted, but flag it).

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Rename it** — runs `git branch -m <new name>`. If there's an upstream, also pushes the new name (`git push -u origin <new name>`) and deletes the old remote branch (`git push origin --delete <old name>`). Report what changed.
- **Fix something first** — ends the turn immediately, nothing renamed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

New name: $ARGUMENTS
