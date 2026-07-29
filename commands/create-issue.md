---
description: Describe a bug/feature, then Create/Fix-first — actually creates the GitHub issue
argument-hint: [bug/feature description, or nothing = current discussion]
allowed-tools: Bash(gh issue create:*)
disable-model-invocation: true
---
Draft a title (≤70 chars) and body from the description below, using only the sections that actually apply — don't invent detail that wasn't given:
- Bug → **Steps to reproduce** / **Expected** / **Actual** / **Environment**
- Feature request → **Problem** / **Proposed solution**

If nothing is given below, draft it from what was just discussed in this conversation. Never mention AI, Claude, or "generated with" anywhere.

Present two real selectable options using the option-picker tool, not plain-text yes/no:
- **Create** — runs `gh issue create --title "<title>" --body "<body>"`. Report the issue URL.
- **Fix something first** — ends the turn immediately, nothing created. Do not guess what's wrong, do not ask follow-ups. Wait for the next message. If instead the user types a correction directly (the picker's built-in free-text option) rather than picking this, treat that text as the fix itself — apply it, then show the corrected title/body and this picker again, don't just stop.

Description: $ARGUMENTS
