---
description: Create a new GitHub repo — pick name + visibility first, then a clear details-confirm picker
argument-hint: [repo name, or nothing to get a suggestion]
allowed-tools: Bash(git remote:*), Bash(git rev-parse:*), Bash(gh repo create:*)
disable-model-invocation: true
---
If this folder already has a git remote pointing to a real repo (`git remote -v`), stop immediately and say so — this command is for creating a brand-new repo, not one that already exists. Suggest the user run this from a different folder instead.

This is a two-step flow — never skip straight to creating:

**Step 1 — lock in name and visibility.** The repo name is never left blank: if $ARGUMENTS gives one, use it; otherwise suggest one based on the current folder name/project content. Then present a real option-picker for visibility:
- **Private**
- **Public**

**Step 2 — confirm with full details shown.** After the name and visibility are both settled, show them clearly:
```
Repo name: <name>
Visibility: <private/public>
```
Then present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Create** — if this folder is already a git repo (but has no remote), runs `gh repo create <name> --public/--private --source=. --remote=origin --push`; otherwise `gh repo create <name> --public/--private`. Report the repo URL.
- **Fix something first** — ends the turn immediately, nothing created. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then re-show the Step 2 details and this picker again, don't just stop.

Repo name (optional): $ARGUMENTS
