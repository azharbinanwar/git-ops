# git-ops

**Stop re-explaining your git safety rules every time — type the command once.**

Typed, per-turn git and GitHub commands for [Claude Code](https://claude.com/claude-code). Every risky command shows you exactly what will happen — the diff, the message, the branch, the file — and gives you a real Create/Fix (or Commit/Push/Cancel-style) picker before anything actually runs. Nothing destructive happens silently.

## Why

Ask a coding assistant to "commit this" or "clean up my branches" and you're rolling the dice: maybe it stages the wrong files, maybe it force-pushes, maybe it writes a commit message that sounds nothing like yours, maybe it just does the thing with no chance to say no. So you end up typing the same safety instructions over and over — *"show me the diff first," "don't force anything," "ask before you push," "no AI co-author line."*

`git-ops` is that instruction, said once, per command:

- Every commit/push/release/merge/reset shows what will happen first, then asks — never acts blind
- Nothing destructive runs without a real picker: **Commit & Push**, **Reset anyway / Stash first / Cancel**, **Merge / Fix something first** — actual choices, not a rhetorical "should I proceed?"
- No AI attribution, anywhere — no `Co-Authored-By: Claude`, no "Generated with," in commits, releases, PRs, issues, gists, or comments
- History-rewriting actions (`reset-hard`, `squash`, `amend-msg`, rebasing) always warn you first if the commit is already pushed
- Ambiguous commands are split, not guessed — `/close-issue` vs `/close-pr`, `/assign-issue` vs `/assign-pr` — one direct `gh` call each, no auto-detect roulette

Split out from [claude-ops](https://github.com/azharbinanwar/claude-ops) once the git-related command set grew past 50 and became its own thing.

## Install

Add the marketplace:

```
/plugin marketplace add azharbinanwar/git-ops
```

Install the plugin:

```
/plugin install git-ops@git-ops
```

Then `/reload-plugins` (or restart Claude Code).

**Requires `gh` (GitHub CLI) installed and logged in** (`gh auth login`) — nearly every command shells out to `gh` or `git`, and the GitHub-facing ones (release, PR, issue, gist, fork, notifications, etc.) won't work without it. **GitHub-only** — the plain-`git` commands (stash, pull, branch, cherry-pick, blame, etc.) work on any host, but anything using `gh` will not work against Bitbucket, GitLab, or other hosts.

Run `/help` anytime for the full cheat sheet below, right in chat.

### Update

```
/plugin marketplace update git-ops
```

Then `/reload-plugins`. New versions are listed in [CHANGELOG.md](CHANGELOG.md).

## Commands

### Basics
| Command | What you get |
|---|---|
| `/commit-msg` | Short + detailed message from your real open changes, flags AI-artifact files worth excluding, never commits, no AI sign |
| `/commit-only` | Lists changes + message, then a real Commit/Fix-first picker — commits locally, never pushes |
| `/commit-and-push` | Same flow, but the picker's Commit & Push option pushes too |
| `/create-release` | Shows the version + release notes, then Create/Fix-first — actually creates the GitHub release |
| `/create-pr` | Detects the real default branch, checks for a duplicate PR, shows title/description, then Create/Fix-first — actually opens the PR |
| `/pr-desc` | PR title + description from the branch diff (doesn't open it) |

### Risky actions — real Create/Fix-first (or 3-way) picker
| Command | What it does |
|---|---|
| `/create-issue [description]` | Describe a bug/feature, then Create/Fix-first — actually creates the issue |
| `/add-to-ignore <file>` | Picks `.gitignore` (shared) vs `.git/info/exclude` (local-only) instead of guessing, untracks it too (`git rm --cached`) if git already tracks it |
| `/refresh-ignore` | Re-checks existing `.gitignore`/`.git/info/exclude` patterns against currently tracked files, untracks anything that now matches — no argument needed |
| `/init-gitignore` | For a new project: detects the stack, shows tracked-vs-ignored, one confirm writes `.gitignore` and untracks matches together |
| `/undo-commit` | Undo the last commit, keep changes staged — like GitHub Desktop's Undo |
| `/revert-commit [hash]` | Safe undo for a pushed commit — creates an opposite commit, history intact |
| `/update-branch` | Bring the default branch's latest into your feature branch — merge (recommended) or rebase |
| `/delete-branch [name]` | Delete one branch — picker for which, then Local only (default) vs Local + remote |
| `/change-visibility` | Make the repo public/private — consequences shown in the picker first |
| `/merge-pr [number]` | Merge a PR — squash/rebase/merge choice |
| `/create-repo [name]` | Create a new GitHub repo — pick name + visibility, confirm and create, then a separate yes/no on wiring up the local remote. Never pushes or commits on your behalf — that's always a separate step |
| `/amend-msg <message>` | Change only the last commit's message, content untouched |
| `/create-gist <file>` | Create a gist from a file — suggests a description, then Create Secret/Public/Fix-first picker |
| `/discard <file>` | Discard uncommitted changes to one file — this loses that work |
| `/squash <N>` | Squash the last N commits into one |
| `/clean-branches` | Delete local branches already merged into the default branch |
| `/close-pr [number]` | Close a PR without merging |
| `/close-issue <number>` | Close an issue with a closing comment |
| `/rename-branch <name>` | Rename the current branch, locally and on the remote |
| `/fork [owner/repo]` | Fork a repo and clone it locally |
| `/cherry-pick <commit>` | Bring one commit over from another branch |
| `/pull [branch]` | Safe pull — fetch + merge; if it could conflict, offers **Pull anyway / Stash first / Cancel** |
| `/pull-rebase [branch]` | Pull with rebase instead of merge — same 3-way choice |
| `/reset-hard` | Hard-reset local branch to exactly match remote — discards all local commits/changes, offers **Reset anyway / Stash first / Cancel** |
| `/merge-branch <branch>` | Merge one local branch into another — direct git merge, not a PR |
| `/approve-pr [number]` | Approve a PR, with an optional comment |
| `/add-remote <owner/repo or URL>` | Connect this local folder to an existing GitHub repo (adds or updates `origin`) |

### Everyday — quick, low-cost, no confirmation needed
| Command | What it does |
|---|---|
| `/help` | This whole cheat sheet, in chat |
| `/stash <name>` | Stash your changes with a name |
| `/view-stashes` | List all stashes with names and age |
| `/pop-stash [ref]` | Pick a stash and restore it — pop (remove) or apply (keep as backup) |
| `/create-branch <description>` | Suggest a branch name, create + switch to it |
| `/checkout-branch [name]` | Pick a branch from a list (local + remote), switch safely |
| `/view-branches` | All branches with age, author, created-from, merged and pushed state |
| `/open-branches` | Open the branches page in the browser |
| `/open-branch [name]` | Open a branch's file tree in the browser — current branch default |
| `/view-prs` | List ALL open PRs (any author) with CI/review status |
| `/unstage <file>` | Undo `git add` on one file, keeps the changes |
| `/pr-status` | List your open PRs with CI/review status |
| `/add-label-issue <number>` | Add labels to an issue, suggests likely ones |
| `/add-label-pr [number]` | Add labels to a PR, suggests likely ones |
| `/assign-issue <number> <username\|"me">` | Assign an issue to yourself or another developer |
| `/assign-pr [number] <username\|"me">` | Assign a PR to yourself or another developer |
| `/request-review` | Pick reviewers from the collaborator list (multi-select) for the current PR |
| `/view-actions` | Latest GitHub Actions runs' pass/fail — pairs with `/open-actions` |
| `/repo-info` | Quick stats: stars, open issues, open PRs, last release |
| `/mark-draft` | Convert an existing PR back to draft status |
| `/view-tags` | List all tags with dates — pairs with `/open-tags` |
| `/remote-url` | Print the remote URL |
| `/view-notifications` | Unread GitHub notifications — pairs with `/open-notifications` |
| `/open-repo` | Open this repo's GitHub page in the browser |
| `/open-pr [n]` | Open a PR in the browser — by number, or the current branch's |
| `/open-pull-requests` | Open the PRs list page in the browser |
| `/open-issues` | Open the issues list page in the browser |
| `/open-actions` | Open the GitHub Actions/CI runs page in the browser |
| `/open-releases` | Open the releases page in the browser |
| `/open-tags` | Open the tags page in the browser |
| `/open-notifications` | Open your GitHub notifications in the browser |
| `/open-issue <n>` | Open one issue in the browser |
| `/open-gist <id>` | Open one gist in the browser |
| `/open-commit <hash>` | Open one commit's diff in the browser |
| `/open-file-history <path>` | Open a file's commit history in the browser |
| `/view-releases` | List releases here in chat — latest first, badges, total count |
| `/open-compare [a...b] [file]` | Compare two branches — optionally jumping straight to one file's diff |
| `/open-file <path>` | Open the current file, at the current line, on GitHub |
| `/view-issues` | List open issues (companion to `/pr-status`) |
| `/view-issue <number\|text>` | View one issue's full details — by number or title search |
| `/view-pr <number\|text>` | View one PR's full details — by number or title search |
| `/blame <file>` | Who last touched each line of a file, quickly |
| `/clone <repo>` | Clone a repo by `owner/repo` or URL — asks where first (parent folder recommended, never inside the current project) |
| `/fetch` | Fetch the latest from remote — no merge, just shows what's new |
| `/review-pr <number>` | Check out a PR locally and show its diff, before deciding anything |
| `/view-gists` | List your gists |
| `/view-gist <id>` | View one gist's full content, by ID |

## Does having 80 commands cost tokens?

No. Every command sets `disable-model-invocation: true`, so none of them are loaded into Claude's context until the moment you type one — then only that command's own instructions are added, for that turn. Idle cost: ~zero. Use the handful you reach for daily, ignore the rest.

## Fast and cheap by design

Since 1.5.0, the mechanical half of every major flow runs as a bundled shell script instead of model-improvised commands — the model keeps only the judgment work (messages, review sections, pickers), then hands the approved text to one deterministic script call. Measured on real runs (haiku, fresh sessions):

| Flow | Before | After |
|---|---|---|
| `/open-*` commands | 405–906 output tokens, 3–6 turns, 3 of 6 failing permission checks | ~95–170 tokens, always 1 turn, 0 failures |
| `/unstage` | 622 tokens, 5 turns | 125 tokens, 1 turn |
| commit → push execution | 4 turns of separate git calls | 2 turns, one script call |

Determinism is the bigger win: `--force` and `--no-verify` don't exist in the scripts, failures print exactly what happened and stop, and every commit receipt lists the files that actually went in. Model pins (`haiku`/`sonnet`) and `effort: low` on all mechanical commands keep the judgment half cheap and predictable too.

Scripts are plain `bash` + `git` + `gh`. **Tested on macOS; designed for Linux and Windows (git-bash)** — `bash tests.sh` runs the offline test suite (21 checks, no network needed), and CI runs it on all three platforms.

## Design principles

- **Show, then ask.** Every command that changes something shows you the real diff/message/plan first, using a genuine option-picker — not a plain-text "yes?" you can skim past.
- **Typed corrections count as answers.** On any picker, typing a correction instead of picking an option is treated as the fix itself — applied immediately, then the corrected plan and picker are shown again. No re-explaining from scratch.
- **Never guess on ambiguity.** Fuzzy-matched names, issue-vs-PR detection, and default branches are resolved from real data (`gh`/`git` output), not assumed — and where two things could mean different actions (issue vs PR), they're separate commands instead of one guessing which you meant.
- **History-safety by default.** Anything that rewrites already-pushed history warns you explicitly, first — no silent force-pushes, ever.
- **Judgment by model, mechanics by script.** The model writes messages and shows you what will happen; a deterministic script does the staging/committing/pushing. Same steps every run, dangerous flags physically absent, failures reported verbatim.

## Rules vs commands — where should your habit go?

- Want it **always**? → one line in `CLAUDE.md` (e.g. *"never force-push without asking"*). Note: `CLAUDE.md` is paid every turn — keep it short.
- Want it **sometimes**, on a specific action? → a command like these. Copy any file in `commands/`, edit, done.
- Never want AI sign-offs anywhere? → these commands already strip them, and `"includeCoAuthoredBy": false` (or the `attribution` field) in `~/.claude/settings.json` covers everything else Claude Code writes.

## License

MIT
