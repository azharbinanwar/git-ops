---
description: Create a GitHub gist from a file — suggests a description, then Create Secret/Public/Fix-first picker
argument-hint: "[file path]"
allowed-tools: Bash(gh gist create:*)
model: haiku
effort: low
disable-model-invocation: true
---
Suggest a one-line description from the file's actual content/purpose. Never mention AI, Claude, or "generated with" in the description.

Never infer or guess public vs. secret — always make it an explicit choice in the picker itself, never a separate plain-text question.

Present three options via the option-picker tool (never plain text):
- **Create secret** — runs `gh gist create <file> -d "<description>"` (secret is the default, no extra flag needed). Report the gist URL.
- **Create public** — same, with `--public` added.
- **Fix something first** — ends the turn immediately, nothing created. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

File: $ARGUMENTS
