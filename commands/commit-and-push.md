---
description: List changes + message, pick Commit & Push or Fix first — commits locally then pushes
argument-hint: "[optional: anything to emphasize]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git rev-parse:*), Bash(git branch:*), Bash(git rm:*), Bash(bash:*), Bash(printf:*)
model: sonnet
disable-model-invocation: true
---
## Context
- Status: !`git status --short`
- Changes: !`git diff HEAD --shortstat 2>/dev/null || git diff --cached --shortstat 2>/dev/null || true`
- Untracked folders: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/untracked-scan.sh"`
- Secrets: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/secrets-scan.sh"`
- Recent style: !`git log --oneline -10 2>/dev/null || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`
- Upstream: !`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "none set"`
- Last commit: !`git log -1 --format="%h %s (%cr)" 2>/dev/null || true`

## Task
1. If "Status"/"Changes" above show no open changes, report the "Last commit" above (hash, message, how long ago) and whether it's already pushed (compare to Upstream). Say there's nothing new to commit. Stop — do not write a message or show the picker.
2. Output exactly these five labeled sections, in this order, nothing else. This step is mandatory, never skipped or shortened: run no extra commands (the Context above is the only data needed) and never show the picker before all five sections are visible, and re-output them on every invocation even if shown earlier in this conversation (the state may have changed):
   - **Change list** — one line per file, vertical, as `Added: path` / `Modified: path` / `Deleted: path` (covers staged + unstaged + untracked — the diff is the truth, not this conversation). For an untracked directory, one line with its file count from "Untracked folders" above: `Added: dir/ (N files)`.
   - **AI check** — one line per flagged file, "better excluded (add to .git/info/exclude): path" for anything that reads like an AI-tracking artifact (scratch notes, `PLAN.md`/`NOTES.md`/`SUMMARY.md`-style files, anything not clearly part of the real source tree), and every "suspicious:" entry from "Untracked folders" above (build output, IDE metadata, keys/secrets riding inside a folder). If none, say "None flagged."
   - **Secrets check** — reproduce the "Secrets" context block above exactly as printed (it is pre-aligned); if it says none found, output `Secrets check: none found.`
   - **commit-title** — the subject line, ≤72 chars, matching the repo's existing message style.
   - **commit-body** — the rest of the message, only if the diff genuinely needs one — plain `-` bullets, one change per bullet, no numbering, no paragraphs, ≤6 bullets unless the diff truly demands more. Never include AI attribution of any kind (no "Co-Authored-By: Claude", no "Generated with" lines).
   `commit-title` + `commit-body` together are the exact text that goes into `git commit` — Change list and AI check are review-only, never part of the commit.
3. Present the options via the option-picker tool (never plain text). Picker question and option labels must be plain short text — never objects, JSON, or templates — and each option's description must state in words exactly what will run, naming the exact files it excludes. Build the option list from what steps above flagged — "junk" = AI check rows, "secret" = Secrets check rows (`[secret]` and `[review]` alike):
   - Nothing flagged → **Commit & Push** / **Fix something first** only.
   - Junk only → **Exclude junk & push** / **Commit & Push anyway** / **Fix something first**.
   - Secret only → **Exclude secret & push** / **Commit & Push anyway** / **Fix something first**.
   - Both → **Exclude junk + secret & push** / **Exclude junk only & push** / **Exclude secret only & push** / **Commit & Push anyway** (Fix first still works: the picker's built-in typed answer = a correction).
   How each option runs:
   - **Exclude … & push** — first, for the named files: untracked ones get `printf '%s\n' <each path, one per printf arg> >> .git/info/exclude`; tracked ones get `git rm --cached -- <path>` *and* the same printf — the description must say the commit will record that file's removal from the repo (it stays on disk, and old contents stay in past history — a tracked `[secret]` is already leaked, rotate it). Then run the same script call as Commit & Push.
   - **Commit & Push** (or **… anyway**) — run exactly one command: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/commit-and-push.sh"` with `commit-title` + blank line + `commit-body` piped to stdin via heredoc. The script stages everything — including any flagged files — commits, and pushes (or `-u origin <branch>` if no upstream), and refuses `--force`/`--no-verify` by construction. Report its output verbatim — if it starts with "error:" or contains "PUSH FAILED", that is the full story: relay it and stop, run nothing else.
   - **Fix something first** — ends the turn immediately, nothing committed, nothing pushed. A typed correction = the fix: apply it, then re-show the corrected `commit-title`/`commit-body` with this picker.

Emphasis (optional): $ARGUMENTS
