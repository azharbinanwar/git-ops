---
description: Rename the current branch, locally and on the remote
argument-hint: [new branch name]
allowed-tools: Bash(git branch:*), Bash(git push:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the current branch name. If $ARGUMENTS is empty, ask for the new name instead of guessing. Check if the current name is already pushed (has an upstream) — if so, note that the remote branch will need updating too (delete old, push new), and any open PR from this branch will need its head ref to catch up (GitHub usually handles this automatically once the new branch is pushed and old one deleted, but flag it).

If there's NO upstream, present two options via the option-picker tool (never plain text): **Rename it** (`git branch -m <new name>`) / **Fix something first**.

If there IS an upstream, present three:
- **Rename local + remote (Recommended)** — one compound command: `git branch -m <new>`, then `&& git push -u origin <new> && git push origin --delete <old>`. Names stay in sync everywhere.
- **Rename local only** — `git branch -m <new>` only; the remote keeps the old name (the branch tracks a differently-named remote — flag that this confuses most workflows until pushed).
- **Fix something first** — ends the turn; nothing renamed; wait. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Report exactly what was renamed where.

New name: $ARGUMENTS
