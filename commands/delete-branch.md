---
description: Delete one branch — pick it, then pick scope: local only (default) or local + remote
argument-hint: [optional: branch name]
allowed-tools: Bash(git branch:*), Bash(git push:*), Bash(git symbolic-ref:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Default branch: !`git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##' || echo main`
- Merged into default: !`git branch --merged origin/HEAD --format='%(refname:short)' 2>/dev/null || true`
- All local branches: !`git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | head -15`
- Remote branches: !`git branch -r --format='%(refname:short)' 2>/dev/null | head -15`

## Task
Never offer the current branch or the default branch — if $ARGUMENTS names one of those, refuse in one line ("switch first" / "the default branch is not deletable here") and stop.

**Step 1 — which branch:** if $ARGUMENTS gives one, use it. Otherwise a real option-picker of local branches (current + default excluded), each label showing its state from Context: `merged ✓` or `NOT merged — its commits may be lost`, and whether it also exists on the remote.

**Step 2 — scope**, via the option-picker:
- **Local only (Recommended)** — `git branch -d <name>` (or `-D` only if it's unmerged AND the user picked it seeing that warning). Reversible — the remote still has it.
- **Local + remote** — one compound command: the local delete, then `&& git push origin --delete <name>`. Also deletes it on GitHub for everyone — not reversible from here.
- **Fix something first** — ends the turn; nothing deleted; wait. A typed correction = the fix: apply it, then re-show this picker.

Report exactly what was deleted where. If the remote delete fails, report the error and stop — the local delete stands.

Branch (optional): $ARGUMENTS
