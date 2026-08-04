---
description: Hard-reset local branch to exactly match remote — discards all local commits and changes, high-stakes
allowed-tools: Bash(git fetch:*), Bash(git status:*), Bash(git log:*), Bash(git reset:*), Bash(git stash:*)
model: haiku
effort: low
disable-model-invocation: true
---
Run `git fetch` first. Show exactly what's at stake: any uncommitted changes (`git status --short`) and any local commits not on the remote (`git log @{u}..HEAD --oneline`). Be explicit that local-only commits are lost either way — stashing only protects uncommitted changes, not commits.

Present three real selectable options using the option-picker tool, not plain-text yes/no:
- **Reset anyway** — runs `git reset --hard @{u}`. Permanently discards everything local not on remote. Report that the branch now exactly matches the remote.
- **Stash first** — runs `git stash push -m "before reset-hard"` (saves uncommitted changes only, does NOT save local-only commits), then runs `git reset --hard @{u}`. Report that the stash is saved (`git stash pop` to bring it back) and that any local-only commits were still discarded.
- **Cancel** — ends the turn immediately, nothing reset, nothing lost.
