---
description: Bring the default branch's latest into your feature branch — merge or rebase, conflict-safe
allowed-tools: Bash(bash:*), Bash(git branch:*), Bash(git status:*), Bash(git fetch:*), Bash(git merge:*), Bash(git rebase:*), Bash(git rev-list:*), Bash(git symbolic-ref:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Default branch: !`git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's#.*/##' || echo main`
- Open changes: !`git status --porcelain 2>/dev/null | wc -l`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" update-branch`

## Task
If "Current branch" equals "Default branch", say there's nothing to update into itself (suggest `/pull`) and stop. If "Open changes" is not 0, warn that merging/rebasing with uncommitted work is risky (suggest `/stash` or committing first) and stop.

Present three options via the option-picker tool (never plain text):
- **Merge default in (Recommended)** — runs exactly one command: `git fetch origin && git merge origin/<default>`. Safe for branches already pushed/shared.
- **Rebase onto default** — runs exactly one command: `git fetch origin && git rebase origin/<default>`. Cleaner history, but rewrites this branch's commits — only right if the branch isn't shared (or you'll coordinate).
- **Cancel** — ends the turn; nothing fetched or changed.

On conflict: report the exact conflicting files and stop — never auto-resolve; mention `git merge --abort` / `git rebase --abort` as the way back. On success report how many commits came in.

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim (omit it entirely if empty, and omit it when the action failed or was cancelled).
