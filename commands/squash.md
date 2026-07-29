---
description: Squash the last N commits into one — high-stakes, extra warning if pushed
argument-hint: [N]
allowed-tools: Bash(git log:*), Bash(git reset:*), Bash(git commit:*), Bash(git rev-parse:*)
disable-model-invocation: true
---
Show the last N commits that will be squashed. Check if any of them are already pushed — if so, warn clearly that this rewrites shared history and needs a force-push, which can break things for anyone else who pulled those commits.

Draft one combined commit message from all N commits' messages.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Squash** — runs `git reset --soft HEAD~N` then `git commit -m "<combined message>"`. Report the new single commit hash.
- **Fix something first** — ends the turn immediately, nothing squashed. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

N: $ARGUMENTS
