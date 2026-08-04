---
description: Describe a bug/feature, then Create/Fix-first — actually creates the GitHub issue
argument-hint: [bug/feature description, or nothing = current discussion]
allowed-tools: Bash(gh issue create:*)
model: sonnet
disable-model-invocation: true
---
Draft a title (≤70 chars) and body from the description below, using only the sections that actually apply — don't invent detail that wasn't given:
- Bug → **Steps to reproduce** / **Expected** / **Actual** / **Environment**
- Feature request → **Problem** / **Proposed solution**

If nothing is given below, draft it from what was just discussed in this conversation. Never mention AI, Claude, or "generated with" anywhere.

Present two options via the option-picker tool (never plain text):
- **Create** — runs `gh issue create --title "<title>" --body "<body>"`. Report the issue URL.
- **Fix something first** — ends the turn immediately, nothing created. A typed correction = the fix: apply it, then re-show the corrected title/body with this picker.

Description: $ARGUMENTS
