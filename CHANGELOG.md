# Changelog

## 1.0.0 — 2026-07-29

First full release — 58 commands, organized into three tiers:

**Basics** (moved from claude-ops, unchanged): `/commit-msg`, `/commit-only`, `/commit-and-push`, `/create-release`, `/create-pr`, `/pr-desc`

**Risky — real Create/Fix (or 3-way) picker before anything happens**: `/create-issue`, `/ignore-fix`, `/undo-commit`, `/merge-pr`, `/new-repo`, `/amend-msg`, `/new-gist`, `/discard`, `/squash`, `/clean-branches`, `/close-pr`, `/close-issue`, `/rename-branch`, `/fork`, `/cherry-pick`, `/pull`, `/pull-rebase`, `/reset-hard`, `/merge-branch`, `/approve-pr`

**Everyday — quick, low-cost, no confirmation needed**: `/help`, `/stash`, `/new-branch`, `/unstage`, `/pr-status`, `/add-label-issue`, `/add-label-pr`, `/assign-issue`, `/assign-pr`, `/request-review`, `/workflow-status`, `/repo-info`, `/mark-draft`, `/tags`, `/remote-url`, `/notifications`, `/open-repo`, `/open-pr`, `/open-pull-requests`, `/open-issues`, `/open-actions`, `/open-releases`, `/open-compare`, `/open-file`, `/view-issues`, `/view-issue`, `/view-pr`, `/blame`, `/clone`, `/fetch`, `/review-pr`

Design decisions baked in from the start:
- No AI attribution anywhere — commits, releases, PRs, issues, gists, comments
- Risky/history-rewriting actions (`reset-hard`, `squash`, `amend-msg`, force-adjacent ones) always warn if already pushed, and always offer Stash-first where relevant
- Commands that could apply to either an issue or a PR are kept as separate commands (`/close-issue` vs `/close-pr`, `/assign-issue` vs `/assign-pr`, `/add-label-issue` vs `/add-label-pr`) rather than one auto-detecting command — no guessing, one direct `gh` call each
- Requires `gh` (GitHub CLI) installed and logged in for anything GitHub-facing
