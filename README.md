# git-ops

Typed, per-turn git commands for [Claude Code](https://claude.com/claude-code) — real Create/Fix pickers before anything risky happens, so you never have to re-explain the flow.

Split out from [claude-ops](https://github.com/azharbinanwar/claude-ops) once the git-related command set grew large enough to be its own thing.

## Install

```
/plugin marketplace add azharbinanwar/git-ops
```

```
/plugin install git-ops@git-ops
```

Then `/reload-plugins`.

## Commands

| Command | What it does |
|---|---|
| `/commit-msg` | Short + detailed message from your real open changes, flags AI-artifact files worth excluding, never commits, no AI sign |
| `/commit-only` | Lists changes + message, then a real Commit/Fix-first picker — commits locally, never pushes |
| `/commit-and-push` | Same flow, but the picker's Commit & Push option pushes too |
| `/create-release` | Shows the version + release notes, then Create/Fix-first — actually creates the GitHub release |
| `/create-pr` | Detects the real default branch, checks for a duplicate PR, shows title/description, then Create/Fix-first — actually opens the PR |
| `/pr-desc` | PR title + description from the branch diff (doesn't open it) |
| `/issue` | Ready-to-paste GitHub issue |

More on the way (stash, undo-commit, gitignore-fix, and others) — being built and tested before release.

## License

MIT
