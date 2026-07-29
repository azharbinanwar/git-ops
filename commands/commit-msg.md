---
description: Commit message from real open changes — never commits, no AI sign
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
disable-model-invocation: true
---
## Context
- Status: !`git status --short`
- Changes: !`git diff HEAD --stat 2>/dev/null || git diff --cached --stat 2>/dev/null || true`
- Recent style: !`git log --oneline -10 2>/dev/null || true`

## Task
Output exactly these four labeled sections, in this order, nothing else:
- **Change list** — one line per file, vertical, as `Added: path` / `Modified: path` / `Deleted: path` (covers staged + unstaged + untracked — the diff is the truth, not this conversation).
- **AI check** — one line per flagged file, "better excluded (add to .git/info/exclude): path" for anything that reads like an AI-tracking artifact (scratch notes, `PLAN.md`/`NOTES.md`/`SUMMARY.md`-style files, anything not clearly part of the real source tree). If none, say "None flagged."
- **short-commit-message** — one line, subject only, ≤72 chars, matching the repo's existing message style.
- **detailed-commit-message** — subject + body explaining what changed and why, only as long as the diff actually warrants.

Never include AI attribution of any kind (no "Co-Authored-By: Claude", no "Generated with" lines) in either message. Do NOT run git commit — this command only ever outputs text.
