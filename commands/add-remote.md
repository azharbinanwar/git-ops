---
description: Connect this local folder to an existing GitHub repo — adds or updates the remote URL
argument-hint: "[owner/repo or URL]"
allowed-tools: Bash(git remote:*), Bash(git init:*)
model: haiku
effort: low
disable-model-invocation: true
---
Check if this folder is already a git repo (`git rev-parse --is-inside-work-tree`) — if not, note that `git init` will run first. Check if a remote named `origin` already exists (`git remote -v`) and show its current URL if so.

If $ARGUMENTS is empty, ask for the repo (`owner/repo` or full URL) instead of guessing.

Present two options via the option-picker tool (never plain text):
- **Connect it** — runs `git init` first if this isn't a git repo yet, then `git remote add origin <url>` if no remote exists, or `git remote set-url origin <url>` if one already exists (replacing it). Report the resulting remote URL.
- **Fix something first** — ends the turn immediately, nothing connected. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Repo (owner/repo or URL): $ARGUMENTS
