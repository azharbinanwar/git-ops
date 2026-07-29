---
description: View one gist's full content, by ID
argument-hint: [gist ID]
allowed-tools: Bash(gh gist view:*)
model: haiku
disable-model-invocation: true
---
Run `gh gist view <id>`. Report its description, visibility, and file contents — read-only, no actions offered.

Gist ID: $ARGUMENTS
