---
description: List your open PRs with CI/review status at a glance
allowed-tools: Bash(gh pr status:*), Bash(gh pr list:*)
model: haiku
disable-model-invocation: true
---
Run `gh pr status`. Show each of your open PRs as one line: number, title, CI status (passing/failing/pending), review status. If there are none, say so. Then say `/view-pr <number-or-text>` to see one in full.
