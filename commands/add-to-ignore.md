---
description: Add a file/pattern to .gitignore or .git/info/exclude — untracking it too if git already tracks it
argument-hint: [file or pattern]
allowed-tools: Bash(git status:*), Bash(git ls-files:*), Bash(git rm:*), Bash(find:*), Bash(ls:*)
disable-model-invocation: true
---
First resolve what was actually typed against what's really on disk (`find`/`ls` from the repo root) — never assume the path means what it sounds like. Report plainly before anything else:
- **Interpreted as:** the exact pattern that will be written (e.g. typing `root/dev` is a literal path `root/dev` from the repo root, NOT "the `dev` folder at my project's root" — that would need just `dev` or `/dev` instead)
- **Found on disk:** what that exact path/pattern actually matches right now, if anything
- If nothing on disk matches what was typed, say so plainly and ask what was meant instead — do not guess or silently correct it, do not proceed to the picker

Once the path is confirmed correct, check whether it's already tracked (`git ls-files <pattern>`). Report:
- Currently tracked: yes/no
- If tracked, adding it will also run `git rm --cached <file>` to untrack it (keeps the file on disk, just stops tracking it) — note this needs a commit afterward to take effect

Present real selectable options using the option-picker tool, not plain-text yes/no — never assume or auto-pick the location, always ask:
- **Add to .gitignore** — a normal, shared, committed ignore rule everyone who clones the repo gets.
- **Add to .git/info/exclude** — a local-only ignore rule, never committed or shared — the right choice for personal/tool-specific noise (e.g. AI-assistant working files) you don't want showing up in the repo's own `.gitignore` for everyone else.
- **Fix something first** — ends the turn immediately, nothing changed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

Whichever location is picked: add the entry, run `git rm --cached` if it was tracked, then report what changed and remind the user a commit is needed afterward if anything was untracked.

File/pattern: $ARGUMENTS
