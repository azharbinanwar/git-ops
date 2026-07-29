---
description: Create a new GitHub repo — suggests a name, asks public/private, then Create/Fix-first
argument-hint: [repo name, or nothing to get a suggestion]
allowed-tools: Bash(git remote:*), Bash(git rev-parse:*), Bash(gh repo create:*)
disable-model-invocation: true
---
If $ARGUMENTS gives a name, use it. Otherwise suggest one based on the current folder name/project content, and show it for confirmation rather than assuming it's right.

Work out public or private — infer from context if genuinely obvious (e.g. a personal experiment vs. something clearly meant to be shared), otherwise ask in one line.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Create** — if this folder is already a git repo, runs `gh repo create <name> --public/--private --source=. --remote=origin --push`; otherwise `gh repo create <name> --public/--private`. Report the repo URL.
- **Fix something first** — ends the turn immediately, nothing created. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Repo name (optional): $ARGUMENTS
