---
description: Create a new GitHub repo — pick name + visibility first, then a clear details-confirm picker
argument-hint: "[repo name, or nothing to get a suggestion]"
allowed-tools: Bash(git remote:*), Bash(git rev-parse:*), Bash(git init:*), Bash(gh repo create:*)
model: haiku
effort: low
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
- **Create** — runs `gh repo create <name> --public/--private` only. Never `--source`, `--remote`, or `--push` here, and never commit anything on the user's behalf — this step only creates the empty GitHub repo and reports its URL.
- **Fix something first** — ends the turn immediately, nothing created. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then re-show the Step 2 details with this picker.

**Step 3 — after Create succeeds, ask about the local remote separately.** Present a real option-picker:
- **Yes, set up remote** — `git init` this folder if it isn't a repo yet, then `git remote add origin <url>` (or `set-url` if `origin` already exists). Wiring only — never push, never commit, even if the folder already has commits ready to go. Tell the user `/commit-and-push` (or `/commit-only` then `/create-pr` etc.) is the next step whenever they're ready to push.
- **No** — end here. Report the repo URL only; the user can run `/add-remote` later whenever they want the local folder connected.

Repo name (optional): $ARGUMENTS
