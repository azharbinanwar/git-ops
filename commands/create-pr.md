---
description: Detects the default branch, checks for a duplicate PR, then Create or Fix first — actually opens the PR
argument-hint: [optional: target branch override]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git symbolic-ref:*), Bash(git push:*), Bash(gh pr create:*), Bash(gh pr list:*), Bash(gh repo view:*)
disable-model-invocation: true
---
## Context
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Detected default branch: !`gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null || echo main`
- Other local branches: !`git branch --format='%(refname:short)' 2>/dev/null || true`
- Commits since origin/HEAD: !`git log origin/HEAD..HEAD --oneline 2>/dev/null || true`
- Diff stat since origin/HEAD: !`git diff origin/HEAD...HEAD --stat 2>/dev/null || true`
- Last commit on this branch: !`git log -1 --format="%h %s (%cr)" 2>/dev/null || true`
- Open PRs (any branch): !`gh pr list --json url,headRefName,baseRefName,number 2>/dev/null || true`

## Task
1. If "Current branch" above equals the detected default branch (no separate feature branch to PR from), report the "Last commit" and say there's nothing to open a PR for. Stop.
2. If "Commits since origin/HEAD" above is empty, report the "Last commit on this branch" and say there's nothing new to open a PR for. Stop.
3. Cross-reference "Open PRs" above against "Current branch" — if one already has a matching `headRefName`, report its URL and say a PR already exists for this branch. Stop — do not draft anything or show a picker.
4. Pick the target branch: if $ARGUMENTS gives one, use it directly and skip the picker. Otherwise present a real option-picker with the "Detected default branch" clearly labeled as recommended, plus each of "Other local branches" (excluding the current branch) as additional options.
5. Output exactly these four labeled sections, in this order, nothing else:
   - **Change list** — one line per changed file, vertical, as `Added: path` / `Modified: path` / `Deleted: path`.
   - **AI check** — one line per flagged file, "better excluded (add to .git/info/exclude): path" for anything that reads like an AI-tracking artifact (scratch notes, `PLAN.md`/`NOTES.md`/`SUMMARY.md`-style files, anything not clearly part of the real source tree). If none, say "None flagged."
   - **pr-title** — the PR title, from the real diff/commits.
   - **pr-body** — a Summary section and a Test plan checklist. Never mention AI, Claude, or "generated with" anywhere.
   `pr-title` + `pr-body` together are the exact text passed to `gh pr create` — Change list and AI check are review-only.
6. Present two real selectable options using the option-picker tool, not plain-text yes/no:
   - **Create** — pushes the current branch if needed (`git push -u origin <branch>` if no upstream yet), then runs `gh pr create --title "<pr-title>" --body "<pr-body>" --base <chosen target branch>`, using your logged-in gh identity, no AI attribution. Report the PR URL and a one-line undo hint: close it with `gh pr close <url>`. Nothing else.
   - **Fix something first** — ends the turn immediately, no PR created. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected `pr-title`/`pr-body` and this picker again, don't just stop.

Target branch override (optional): $ARGUMENTS
