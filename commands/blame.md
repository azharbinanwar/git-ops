---
description: Who last touched each line of a file, quickly
argument-hint: [file path, optional line range e.g. 10-20]
allowed-tools: Bash(git blame:*)
model: haiku
effort: low
disable-model-invocation: true
---
Run `git blame` on the file (add `-L <range>` if a line range was given). Report each line's author, date, and commit hash in a compact format — don't dump the whole file if it's long, focus on the requested range or a reasonable default (~30 lines) if none was given.

File (and optional range): $ARGUMENTS
