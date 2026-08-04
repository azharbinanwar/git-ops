---
description: Bring one commit over from another branch
argument-hint: "[commit hash, or branch name to pick its latest commit]"
allowed-tools: Bash(git log:*), Bash(git cherry-pick:*), Bash(git status:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target commit — a given hash, or the latest commit on a given branch name. Show its message and the files it touches. Warn if the current working tree has uncommitted changes that could conflict.

Present two options via the option-picker tool (never plain text):
- **Cherry-pick it** — runs `git cherry-pick <hash>`. If it conflicts, report the exact conflict and stop — never auto-resolve or force through it; tell the user to resolve manually or `git cherry-pick --abort`.
- **Fix something first** — ends the turn immediately, nothing picked. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Commit or branch: $ARGUMENTS
