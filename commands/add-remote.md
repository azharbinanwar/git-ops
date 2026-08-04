---
description: Connect this local folder to an existing GitHub repo — adds or updates the remote URL
argument-hint: [owner/repo or URL]
allowed-tools: Bash(git remote:*), Bash(git init:*)
model: haiku
effort: low
disable-model-invocation: true
---
Check if this folder is already a git repo (`git rev-parse --is-inside-work-tree`) — if not, note that `git init` will run first. Check if a remote named `origin` already exists (`git remote -v`) and show its current URL if so.

If $ARGUMENTS is empty, ask for the repo (`owner/repo` or full URL) instead of guessing.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Connect it** — runs `git init` first if this isn't a git repo yet, then `git remote add origin <url>` if no remote exists, or `git remote set-url origin <url>` if one already exists (replacing it). Report the resulting remote URL.
- **Fix something first** — ends the turn immediately, nothing connected. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Repo (owner/repo or URL): $ARGUMENTS
