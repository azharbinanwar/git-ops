---
description: Show version + notes, pick Create or Fix first — actually creates the GitHub release
argument-hint: "[optional: version override, e.g. 1.4.0]"
allowed-tools: Bash(git tag:*), Bash(git log:*), Bash(git describe:*), Bash(git remote:*), Bash(gh auth status:*), Bash(bash:*)
model: sonnet
disable-model-invocation: true
---
## Context
- GitHub auth: !`gh auth status >/dev/null 2>&1 && echo "logged in" || echo "not logged in"`
- Remote: !`git remote get-url origin 2>/dev/null || echo "none"`
- Latest tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "none yet"`
- Recent commits: !`git log --oneline -15 2>/dev/null || true`
- Existing tags: !`git tag --sort=-creatordate 2>/dev/null | head -5 || true`

## Task
1. If "GitHub auth" above shows "not logged in", or "Remote" shows "none", report that exact problem in one line and stop — do not attempt anything else.
2. Work out the version: prefer a version field already in the repo (`plugin.json`, `package.json`, etc.) or the top dated section of `CHANGELOG.md`. If truly ambiguous, ask for it in one line instead of guessing. Use $ARGUMENTS as an override if given.
3. Check "Existing tags" above. If a tag matching this version already exists, present two different options instead of the ones below:
   - **Bump version & prepare** — update only the version field in the matching file (`plugin.json`/`package.json`/etc.), nothing else — do not touch `CHANGELOG.md` or any other file, that's the user's call. Then stop: tell them to test locally, and to run `/create-release` again when ready. Do not create a release now.
   - **Fix something first** — ends the turn immediately, no changes. Wait for the next message.
   Then stop — do not continue to steps 4-5 below.
4. Output exactly these four labeled sections, in this order, nothing else:
   - **Change list** — one line per commit since the last release (from "Recent commits" above, only the ones before the "Latest tag" commit — all of them if there's no tag yet).
   - **AI check** — always "Not applicable — release notes never reference AI/Claude."
   - **release-title** — `v<version>`.
   - **release-notes** — built from the matching `CHANGELOG.md` section (or the commits above if there's no changelog entry yet). Never mention AI, Claude, or "generated with" anywhere.
   `release-title` + `release-notes` together are the exact text passed to `gh release create` — Change list and AI check are review-only.
5. Present two options via the option-picker tool (never plain text):
   - **Create** — run exactly one command: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/create-release.sh" v<version>` with `release-title` + blank line + `release-notes` piped to stdin via heredoc. Uses your logged-in gh identity, no AI attribution. Report its output verbatim — if it starts with "error:", relay it and stop, run nothing else.
   - **Fix something first** — ends the turn immediately, no tag or release created. A typed correction = the fix: apply it, then re-show the corrected `release-title`/`release-notes` with this picker.

Version override (optional): $ARGUMENTS
