---
description: Detects the default branch, checks for a duplicate PR, then Create or Fix first — actually opens the PR
argument-hint: "[optional: target branch override]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git symbolic-ref:*), Bash(gh pr view:*), Bash(gh repo view:*), Bash(bash:*)
model: sonnet
disable-model-invocation: true
---
## Context
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Detected default branch: !`gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null || echo main`
- Remote branches (PR targets live on GitHub): !`git branch -r --format='%(refname:short)' 2>/dev/null | head -20 || true`
- Commits since origin/HEAD: !`git log origin/HEAD..HEAD --oneline -20 2>/dev/null || true`
- Diff stat since origin/HEAD: !`git diff origin/HEAD...HEAD --stat 2>/dev/null || true`
- Secrets: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/secrets-scan.sh"`
- Last commit on this branch: !`git log -1 --format="%h %s (%cr)" 2>/dev/null || true`
- Open PR for this branch: !`gh pr view --json url -q .url 2>/dev/null || echo "none"`

## Task
1. If "Current branch" above equals the detected default branch (no separate feature branch to PR from), report the "Last commit" and say there's nothing to open a PR for. Stop.
2. If "Commits since origin/HEAD" above is empty, report the "Last commit on this branch" and say there's nothing new to open a PR for. Stop.
3. If "Open PR for this branch" above is not "none", report that URL and say a PR already exists for this branch. Stop — do not draft anything or show a picker.
4. Pick the target branch: if $ARGUMENTS gives one, use it directly and skip the picker. Otherwise present a real option-picker with the "Detected default branch" clearly labeled as recommended, plus each of "Remote branches" as additional options (strip the `origin/` prefix for display, exclude `origin/HEAD`, the default branch, and the current branch). Only remote branches are offered — a PR can only target a branch that exists on GitHub, so local-only branches don't belong in this list.
5. Output exactly these five labeled sections, in this order, nothing else:
   - **Change list** — one line per changed file, vertical, as `Added: path` / `Modified: path` / `Deleted: path`.
   - **AI check** — one line per flagged file, "better excluded (add to .git/info/exclude): path" for anything that reads like an AI-tracking artifact (scratch notes, `PLAN.md`/`NOTES.md`/`SUMMARY.md`-style files, anything not clearly part of the real source tree). If none, say "None flagged."
   - **Secrets check** — reproduce the "Secrets" context block above exactly as printed (it is pre-aligned); if it says none found, output `Secrets check: none found.`
   - **pr-title** — the PR title, from the real diff/commits.
   - **pr-body** — a Summary section and a Test plan checklist. Never mention AI, Claude, or "generated with" anywhere.
   `pr-title` + `pr-body` together are the exact text passed to `gh pr create` — Change list and AI check are review-only.
6. Present three options via the option-picker tool (never plain text). Picker question and option labels must be plain short text — never objects, JSON, or templates — and each option's description must state in words exactly what will run:
   - **Create** — run exactly one command: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/create-pr.sh" <chosen target branch>` with `pr-title` + blank line + `pr-body` piped to stdin via heredoc. The script pushes the branch if needed and opens the PR with your logged-in gh identity, no AI attribution. Report its output verbatim — if it starts with "error:", relay it and stop, run nothing else.
   - **Create as draft** — same single command with `--draft` appended after the target branch: marks the PR not-ready-for-review; reviewers aren't notified until you mark it ready.
   - **Fix something first** — ends the turn immediately, no PR created. A typed correction = the fix: apply it, then re-show the corrected `pr-title`/`pr-body` with this picker.

Target branch override (optional): $ARGUMENTS
