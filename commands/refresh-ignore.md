---
description: Re-check all existing .gitignore / .git/info/exclude patterns against currently tracked files, untrack anything that now matches
allowed-tools: Bash(git ls-files:*), Bash(git rm:*), Bash(cat:*)
model: sonnet
disable-model-invocation: true
---
No argument needed — this re-syncs against whatever ignore rules already exist, it doesn't add new patterns.

Read the existing patterns from both `.gitignore` and `.git/info/exclude` (if either exists; note which ones you found). Run `git ls-files` and check every tracked entry against those patterns.

Report two labeled sections:
- **Source of patterns checked** — `.gitignore` (y/n), `.git/info/exclude` (y/n).
- **Currently tracked that now matches an ignore pattern** — list them (file count/size for noisy matches like build folders). If none, say "None — nothing to untrack."

If nothing matches, stop here — no picker needed, nothing to do.

Otherwise present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Untrack all of these** — runs `git rm --cached` on every match in one step. Files stay on disk. Report what was untracked, and remind the user a commit is needed afterward to finalize it.
- **Fix something first** — ends the turn immediately, nothing untracked. A typed correction — e.g. "skip the build folder ones" — is the fix: adjust which matches will be untracked, then show the corrected list with this picker.
