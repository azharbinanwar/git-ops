---
description: Bring one commit over from another branch
argument-hint: [commit hash, or branch name to pick its latest commit]
allowed-tools: Bash(git log:*), Bash(git cherry-pick:*), Bash(git status:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target commit — a given hash, or the latest commit on a given branch name. Show its message and the files it touches. Warn if the current working tree has uncommitted changes that could conflict.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Cherry-pick it** — runs `git cherry-pick <hash>`. If it conflicts, report the exact conflict and stop — never auto-resolve or force through it; tell the user to resolve manually or `git cherry-pick --abort`.
- **Fix something first** — ends the turn immediately, nothing picked. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Commit or branch: $ARGUMENTS
