---
description: PR title + description from the branch diff — no AI sign
argument-hint: [optional extra context]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git merge-base:*), Bash(git symbolic-ref:*)
disable-model-invocation: true
---
Write a PR title and description for the current branch. Steps:
1. Find the default branch (main or master), then look at `git log <default>..HEAD --oneline` and `git diff <default>...HEAD --stat` (full diff for small changes).
2. Write: a title ≤70 chars, then sections **Summary** (2–3 lines), **Changes** (bullets), **Testing** (how it was/should be verified).

The diff is the truth, not this conversation. Never include AI attribution of any kind. Output only the title + description in a code block — do not create the PR.

Extra context: $ARGUMENTS
