---
description: Squash the last N commits into one — high-stakes, extra warning if pushed
argument-hint: [N]
allowed-tools: Bash(git log:*), Bash(git reset:*), Bash(git commit:*), Bash(git rev-parse:*)
model: haiku
effort: low
disable-model-invocation: true
---
Show the last N commits that will be squashed. Check if any of them are already pushed — if so, warn clearly that this rewrites shared history and needs a force-push, which can break things for anyone else who pulled those commits.

Draft one combined commit message from all N commits' messages.

Present two options via the option-picker tool (never plain text):
- **Squash** — runs `git reset --soft HEAD~N` then `git commit -m "<combined message>"`. Report the new single commit hash.
- **Fix something first** — ends the turn immediately, nothing squashed. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

N: $ARGUMENTS
