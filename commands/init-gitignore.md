---
description: Set up .gitignore for a new project — detects the stack, shows what's tracked vs ignored, one confirm applies both
allowed-tools: Bash(git ls-files:*), Bash(git rm:*), Bash(ls:*), Bash(find:*)
model: sonnet
disable-model-invocation: true
---
Detect the project's stack from what's actually present (`package.json` → Node, `Cargo.toml` → Rust, `*.xcodeproj` → Xcode, `build.gradle`/`build.gradle.kts` → Kotlin/Android, `requirements.txt`/`pyproject.toml` → Python, etc. — multiple can apply at once).

Generate the appropriate `.gitignore` patterns for the detected stack(s), plus universal ones (`.DS_Store`, `.idea/`, etc. as applicable).

Output two labeled sections:
- **Will be ignored** — the full list of patterns, as they'll appear in `.gitignore`.
- **Currently tracked that matches these patterns** — run `git ls-files` and check each entry against the patterns; list the ones that would need untracking (with file count/size for noisy matches like build folders, not every single file). If nothing tracked matches, say "None — clean already."

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Apply** — writes `.gitignore` with the listed patterns, then runs `git rm --cached` on every currently-tracked match in the same step (files stay on disk, just untracked). This is one action, not two — the user should never need to run this again separately for the same setup. Report what was written and what was untracked. Remind them a commit is needed afterward to finalize the untracking (or that `/commit-only`/`/commit-and-push` is the natural next step).
- **Fix something first** — ends the turn immediately, nothing written, nothing untracked. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this — e.g. "also ignore *.log" or "don't ignore local.properties" — treat that text as the fix itself: adjust the pattern list, then show the corrected Will-be-ignored/Currently-tracked sections and this picker again, don't just stop.
