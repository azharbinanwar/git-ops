---
description: Add a file/pattern to .gitignore, untracking it too if git already tracks it
argument-hint: [file or pattern]
allowed-tools: Bash(git status:*), Bash(git ls-files:*), Bash(git rm:*)
disable-model-invocation: true
---
Check whether the given file/pattern is already tracked (`git ls-files <pattern>`). Report:
- Currently tracked: yes/no
- Will add to `.gitignore` (or `.git/info/exclude` if this repo uses that convention instead — check which one it already relies on) — the exact pattern
- If tracked, will also run `git rm --cached <file>` to untrack it (keeps the file on disk, just stops tracking it) — note this needs a commit afterward to take effect

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Fix it** — adds the ignore entry, and `git rm --cached` if it was tracked. Report what changed, and remind the user a commit is needed afterward if anything was untracked.
- **Fix something first** — ends the turn immediately, nothing changed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

File/pattern: $ARGUMENTS
