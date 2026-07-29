---
description: Create a GitHub gist from a file — suggests a description, asks public/secret, then Create/Fix-first
argument-hint: [file path]
allowed-tools: Bash(gh gist create:*)
disable-model-invocation: true
---
Suggest a one-line description from the file's actual content/purpose. Never mention AI, Claude, or "generated with" in the description. Work out public or secret — default to secret unless told otherwise, since that's the safer default for something not explicitly meant to be public.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Create** — runs `gh gist create <file> -d "<description>"` (add `--public` only if public was chosen). Report the gist URL.
- **Fix something first** — ends the turn immediately, nothing created. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected plan and this picker again, don't just stop.

File: $ARGUMENTS
