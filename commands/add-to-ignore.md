---
description: Add a file/pattern to .gitignore or .git/info/exclude — untracking it too if git already tracks it
argument-hint: "[file or pattern]"
allowed-tools: Bash(bash:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Scan: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/ignore-scan.sh" "$ARGUMENTS"`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" add-to-ignore`

## Task
The Scan above already resolved the input against disk (each line: `path | tracked-state | ignore-state`). Run no discovery commands — the Scan is the whole truth.

- Scan says "(no pattern given)" → ask in one line what to ignore; stop.
- Scan says "no match on disk" → say so and ask what was meant; stop — never guess a pattern for a file that doesn't exist.
- Every candidate already `ignored` and `untracked` → say nothing needs doing; stop.

Otherwise, take the candidates that need action (NOT ignored, or still tracked/staged) and show a 2-3 line plan: the exact pattern(s) to write (root-anchor single files as `/name`; use a wildcard like `*.jks` only when the user's term implies a class of files), and which tracked paths will be untracked (note untracking needs a commit afterward).

Present the location via the option-picker tool (never plain text; never auto-pick):
- **Add to .gitignore** — shared, committed rule everyone gets.
- **Add to .git/info/exclude** — local-only, never committed — right for personal/tool noise.
- **Fix something first** — ends the turn, nothing changed. A typed correction = the fix: apply it, re-show this picker.

On pick run exactly one command per pattern: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/add-to-ignore.sh" <gitignore|exclude> "<pattern>" <tracked paths...>` — the script dedupes the entry and untracks the paths. Report its receipt lines verbatim, nothing more.

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim. Omit it entirely — silently, never mentioning it — if it is empty, shows an error, or failed to load, and when the action failed or was cancelled.

File/pattern: $ARGUMENTS
