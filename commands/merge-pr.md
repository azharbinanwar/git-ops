---
description: Merge a PR — choice of squash/rebase/merge, then Create/Fix-first
argument-hint: [PR number, or nothing for current branch's PR]
allowed-tools: Bash(gh pr view:*), Bash(gh pr merge:*), Bash(gh pr checks:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target PR (given number, or the current branch's). Show its title, CI status, and review status. If CI is failing or it isn't approved, flag that clearly before offering to merge — don't hide it.

Work out the merge method: squash, rebase, or merge commit — match the repo's existing history style if visible, otherwise ask in one line rather than guessing.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Merge** — runs `gh pr merge <n> --squash` (or `--rebase`/`--merge` per the chosen method). Report confirmation and the resulting commit.
- **Fix something first** — ends the turn immediately, nothing merged. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Target (optional): $ARGUMENTS
