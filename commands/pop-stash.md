---
description: Pick a stash from the list and restore it — pop (restore + remove) or apply (restore + keep)
argument-hint: "[optional: stash ref like stash@{1}, defaults to picker]"
allowed-tools: Bash(git stash:*), Bash(git status:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Stashes: !`git stash list --format='%gd | %cr | %gs' 2>/dev/null || true`
- Open changes: !`git status --porcelain 2>/dev/null | wc -l`

## Task
If "Stashes" above is empty, say `No stashes to restore.` and stop.

**Step 1 — which stash:** $ARGUMENTS if given, otherwise a real option-picker of the stashes above (label = name + age; most recent first, recommended).

**Step 2 — how**, via the option-picker:
- **Pop (Recommended)** — `git stash pop <ref>`: restores the changes and removes the stash.
- **Apply (keep the stash)** — `git stash apply <ref>`: restores but keeps the stash as a backup, e.g. to apply the same changes on another branch too.
- **Cancel** — ends the turn; nothing restored.

If "Open changes" is not 0, add one warning line before the Step 2 picker: restoring on top of open changes can conflict. On conflict: report the conflicting files and stop — the stash is NOT dropped on a failed pop, nothing is lost. On success report what was restored (and whether the stash was removed or kept).
