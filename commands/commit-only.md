---
description: List changes + message, pick Commit or Fix first — commits locally, never pushes
argument-hint: "[optional: anything to emphasize]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git rm:*), Bash(bash:*), Bash(printf:*), Write, Edit
model: sonnet
disable-model-invocation: true
---
## Context
- Status: !`git status --short`
- File count: !`git status --porcelain 2>/dev/null | wc -l | tr -d ' '`
- Changes: !`git diff HEAD --shortstat 2>/dev/null || git diff --cached --shortstat 2>/dev/null || true`
- Untracked folders: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/untracked-scan.sh"`
- Secrets: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/secrets-scan.sh"`
- Recent style: !`git log --oneline -10 2>/dev/null || true`
- Last commit: !`git log -1 --format="%h %s (%cr)" 2>/dev/null || true`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" commit-only`

## Task
1. If "Status"/"Changes" above show no open changes, report the "Last commit" above (hash, message, how long ago) and say there's nothing new to commit. Stop — do not write a message or show the picker.
2. Output exactly these three labeled sections, in this order, then the Write in step 2b, nothing else. Mandatory on every invocation, even if shown earlier in this conversation (the state may have changed); run no extra commands — the Context above is the only data needed:
   - **Change list** — one line per file, vertical, as `Added: path` / `Modified: path` / `Deleted: path` (covers staged + unstaged + untracked — the diff is the truth, not this conversation). For an untracked directory, one line with its file count from "Untracked folders" above: `Added: dir/ (N files)`.
   - **AI check** — one line per flagged file, "better excluded (add to .git/info/exclude): path" for anything that reads like an AI-tracking artifact (scratch notes, `PLAN.md`/`NOTES.md`/`SUMMARY.md`-style files, anything not clearly part of the real source tree), and every "suspicious:" entry from "Untracked folders" above (build output, IDE metadata, keys/secrets riding inside a folder). If none, say "None flagged."
   - **Secrets check** — reproduce the "Secrets" context block above exactly as printed (it is pre-aligned); if it says none found, output `Secrets check: none found.`
2b. Write the commit message once, with the Write tool, to `.git/GITOPS_COMMITMSG` (no Read beforehand — only if the Write is refused because the file already exists, Read it once and Write again). Line 1 = title, ≤72 chars, matching the repo's existing message style; then a blank line; then the body only if the diff genuinely needs one — plain `-` bullets, one change per bullet, no numbering, no paragraphs, ≤6 bullets unless the diff truly demands more. Hard rule: every path named in the message MUST appear in the Change list above. Paths outside it are forbidden — excluded, ignored, or unchanged files never appear in the message even when an added file's own text references them (describe the added file's purpose, not its contents or its links). Never include AI attribution of any kind (no "Co-Authored-By: Claude", no "Generated with" lines). The Write display is the review copy — never repeat the message as chat text.
3. In the same turn, immediately after step 2b, present the options via the option-picker tool (never plain text). Steps 2–3 are one turn: ending the turn after the sections without the picker is a failure — the user cannot act. For any file number in the picker text use "File count" from Context, never a count of rows you made yourself. Picker question and option labels must be plain short text — never objects, JSON, or templates — and each option's description must state in words exactly what will run, naming the exact files it excludes. Build the option list from what steps above flagged — "junk" = AI check rows, "secret" = Secrets check rows (`[secret]` and `[review]` alike):
   The order below is fixed — exclude options always come first, whatever was flagged and whether the files are tracked or not. Never reorder by your own judgement:
   - Nothing flagged → **Commit** / **Fix something first** only.
   - Junk only → **Exclude junk & commit** / **Commit anyway** / **Fix something first**.
   - Secret only → **Exclude secret & commit** / **Commit anyway** / **Fix something first**.
   - Both → **Exclude junk + secret & commit** / **Exclude junk only & commit** / **Exclude secret only & commit** / **Commit anyway** (Fix first still works: the picker's built-in typed answer = a correction).
   How each option runs:
   - **Exclude … & commit** — first, for the named files: untracked ones get `printf '%s\n' <each path, one per printf arg> >> .git/info/exclude`; tracked ones get `git rm --cached -- <path>` *and* the same printf — the description must say the commit will record that file's removal from the repo (it stays on disk, and old contents stay in past history — a tracked `[secret]` is already leaked, rotate it). Then run the same script call as Commit.
   - **Commit** (or **Commit anyway**) — run exactly one command: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/commit-only.sh" .git/GITOPS_COMMITMSG` — the message comes from the file (the script deletes it on success). The script stages everything — including any flagged files — and commits; it never pushes, and refuses `--no-verify` by construction. Report its output verbatim and nothing else — no summary sentence of your own, no repeated file list. If it starts with "error:", that is the full story: relay it and stop, run nothing else.
   - **Fix something first** — ends the turn immediately, nothing committed. A typed correction is applied to the commit-title/commit-body text only — run no commands in response to it (the Context above stays the truth) unless it explicitly names files to add or exclude. Apply it with Edit to `.git/GITOPS_COMMITMSG` (only the changed lines), then re-show this picker.

Emphasis (optional): $ARGUMENTS

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim. Omit it entirely — silently, never mentioning it — if it is empty, shows an error, or failed to load, and when the action failed or was cancelled.
