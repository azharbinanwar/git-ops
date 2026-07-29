---
description: List open issues (companion to /pr-status)
allowed-tools: Bash(gh issue list:*)
model: haiku
disable-model-invocation: true
---
Run `gh issue list`. Show each as one line: number, title, labels, how long ago opened. If there are none, say so. Then say `/view-issue <number-or-text>` to see one in full.
