---
description: List changes + message, pick Commit & Push or Fix first — commits locally then pushes
argument-hint: [optional: anything to emphasize]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git rev-parse:*), Bash(git branch:*)
disable-model-invocation: true
---
## Context
- Status: !`git status --short`
- Changes: !`git diff HEAD --stat 2>/dev/null || git diff --cached --stat 2>/dev/null || true`
- Recent style: !`git log --oneline -10 2>/dev/null || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Upstream: !`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "none set"`
- Last commit: !`git log -1 --format="%h %s (%cr)" 2>/dev/null || true`

## Task
1. If "Status"/"Changes" above show no open changes, report the "Last commit" above (hash, message, how long ago) and whether it's already pushed (compare to Upstream). Say there's nothing new to commit. Stop — do not write a message or show the picker.
2. Output exactly these four labeled sections, in this order, nothing else:
   - **Change list** — one line per file, vertical, as `Added: path` / `Modified: path` / `Deleted: path` (covers staged + unstaged + untracked — the diff is the truth, not this conversation).
   - **AI check** — one line per flagged file, "better excluded (add to .git/info/exclude): path" for anything that reads like an AI-tracking artifact (scratch notes, `PLAN.md`/`NOTES.md`/`SUMMARY.md`-style files, anything not clearly part of the real source tree). If none, say "None flagged."
   - **commit-title** — the subject line, ≤72 chars, matching the repo's existing message style.
   - **commit-body** — the rest of the message, only if the diff genuinely needs one. Never include AI attribution of any kind (no "Co-Authored-By: Claude", no "Generated with" lines).
   `commit-title` + `commit-body` together are the exact text that goes into `git commit` — Change list and AI check are review-only, never part of the commit.
3. Present two real selectable options using the option-picker tool, not plain-text yes/no:
   - **Commit & Push** — stages exactly the files listed above (never `git add -A` or `git add .`), runs `git commit` with `commit-title` + `commit-body` via heredoc. If the commit fails (e.g. a pre-commit hook rejects it), report the exact error and stop — never retry with `--no-verify`. Then pushes (use the existing upstream if set, otherwise `git push -u origin <current branch>`). If the push is rejected (e.g. non-fast-forward, remote has commits you don't have locally), report the exact error and stop — never `--force`/`--force-with-lease`; tell the user to pull/rebase first. On success, report the commit hash, confirm the push, and a one-line undo hint: `git reset --soft HEAD~1` (local only — coordinate before rewriting already-pushed history).
   - **Fix something first** — ends the turn immediately, nothing committed, nothing pushed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected `commit-title`/`commit-body` and this picker again, don't just stop.

Emphasis (optional): $ARGUMENTS
