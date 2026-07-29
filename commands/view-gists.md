---
description: List your gists
allowed-tools: Bash(gh gist list:*)
model: haiku
disable-model-invocation: true
---
Run `gh gist list`. Show each as one line: ID, description, visibility (public/secret), file count, how long ago updated. If there are none, say so. Then say `/view-gist <id>` to see one in full.
