---
description: Rename the current branch, locally and on the remote
argument-hint: [new branch name]
allowed-tools: Bash(git branch:*), Bash(git push:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the current branch name. If $ARGUMENTS is empty, ask for the new name instead of guessing. Check if the current name is already pushed (has an upstream) — if so, note that the remote branch will need updating too (delete old, push new), and any open PR from this branch will need its head ref to catch up (GitHub usually handles this automatically once the new branch is pushed and old one deleted, but flag it).

Present two options via the option-picker tool (never plain text):
- **Rename it** — runs `git branch -m <new name>`. If there's an upstream, also pushes the new name (`git push -u origin <new name>`) and deletes the old remote branch (`git push origin --delete <old name>`). Report what changed.
- **Fix something first** — ends the turn immediately, nothing renamed. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

New name: $ARGUMENTS
