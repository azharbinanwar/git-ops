---
description: Merge a PR — choice of squash/rebase/merge, then Create/Fix-first
argument-hint: [PR number, or nothing for current branch's PR]
allowed-tools: Bash(gh pr view:*), Bash(gh pr merge:*), Bash(gh pr checks:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- PR: !`gh pr view $ARGUMENTS --json number,title,url,state,reviewDecision,mergeable -q '"#\(.number) \(.title) [\(.state)] review:\(.reviewDecision // "none") mergeable:\(.mergeable)"' 2>&1 || true`
- Checks: !`gh pr checks $ARGUMENTS 2>&1 | head -8 || true`
- Recent merge style: !`git log --oneline --merges -3 2>/dev/null || echo "no merge commits (squash/rebase style)"`

## Task
From Context above (run nothing else to gather data): show the PR's title, CI status, and review status. If CI is failing or it isn't approved, flag that clearly before offering to merge — don't hide it.

Work out the merge method: squash, rebase, or merge commit — match the style visible in "Recent merge style", otherwise ask in one line rather than guessing.

Present two options via the option-picker tool (never plain text):
- **Merge** — runs `gh pr merge <n> --squash` (or `--rebase`/`--merge` per the chosen method). Report confirmation and the resulting commit.
- **Fix something first** — ends the turn immediately, nothing merged. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Target (optional): $ARGUMENTS
