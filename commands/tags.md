---
description: List all tags with dates
allowed-tools: Bash(git tag:*), Bash(git log:*)
model: haiku
disable-model-invocation: true
---
Run `git tag --sort=-creatordate`, and for each tag show its date (`git log -1 --format=%ai <tag>`), newest first. If none exist, say so.
