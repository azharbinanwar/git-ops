# Changelog

## 1.3.0 — 2026-07-30

- `/create-repo`'s **Create** step no longer pushes or commits anything — it now only runs `gh repo create <name> --public/--private`, nothing else. Previously `--source=. --remote=origin --push` was used when the folder was already a git repo, which required an existing commit to push and led to an unrequested `git commit` being run just to make that work.
- New **Step 3**: after the repo is created, a separate Yes/No picker asks whether to wire up the local `origin` remote (`git init` if needed, then `git remote add`/`set-url`). Even choosing Yes only connects the remote — it never pushes. Pushing is always left to `/commit-and-push` or similar, run separately whenever the user is ready.
- Renamed `/ignore-fix` → `/add-to-ignore`, and it now presents a real picker (**Add to .gitignore** / **Add to .git/info/exclude** / Fix something first) instead of silently guessing which one the repo already relies on — `.git/info/exclude` is the right call for personal/tool-specific noise (e.g. AI-assistant working files) that shouldn't show up in the shared, committed `.gitignore`.
- New: `/refresh-ignore` — no argument, re-checks whatever's already in `.gitignore`/`.git/info/exclude` against currently tracked files and untracks anything that now matches, in one step. For when patterns were added earlier but tracking was never refreshed against them.

## 1.2.0 — 2026-07-29

- New: `/init-gitignore` — for a new project before the first commit: detects the stack (Node/Rust/Kotlin/Python/etc.), shows what will be ignored vs what's currently tracked that matches, one Apply writes `.gitignore` and untracks all matches together in a single step — never a separate follow-up call for the same setup

## 1.1.0 — 2026-07-29

- Renamed `/new-repo` → `/create-repo`, `/new-gist` → `/create-gist` — matches the `/create-*` naming used by everything else that actually creates something real (`/create-pr`, `/create-release`, `/create-issue`)
- `/create-repo` now bails out immediately if the current folder already has a git remote, instead of risking a conflicting `gh repo create --source=.`
- New: `/add-remote` — connects a local folder to an *existing* GitHub repo (adds or updates the `origin` remote), for when you already have a repo on GitHub and just need the local side wired up
- New: `/view-gists` (list), `/view-gist` (one, by ID) — this plugin is GitHub-only throughout (anything using `gh` won't work against Bitbucket/GitLab/etc.), worth noting explicitly in the README
- `/create-gist` no longer infers or asks public/secret as a separate plain-text question — visibility is now an explicit picker choice (**Create secret / Create public / Fix something first**)
- `/create-repo` redesigned as a two-step flow: Step 1 locks in the (never-blank) name and visibility via a picker; Step 2 shows those exact details back before a final Create/Fix-first picker — so you always see precisely what's about to be created before it happens

## 1.0.0 — 2026-07-29

First full release — 58 commands, organized into three tiers:

**Basics** (moved from claude-ops, unchanged): `/commit-msg`, `/commit-only`, `/commit-and-push`, `/create-release`, `/create-pr`, `/pr-desc`

**Risky — real Create/Fix (or 3-way) picker before anything happens**: `/create-issue`, `/ignore-fix`, `/undo-commit`, `/merge-pr`, `/new-repo`, `/amend-msg`, `/new-gist`, `/discard`, `/squash`, `/clean-branches`, `/close-pr`, `/close-issue`, `/rename-branch`, `/fork`, `/cherry-pick`, `/pull`, `/pull-rebase`, `/reset-hard`, `/merge-branch`, `/approve-pr`

**Everyday — quick, low-cost, no confirmation needed**: `/help`, `/stash`, `/new-branch`, `/unstage`, `/pr-status`, `/add-label-issue`, `/add-label-pr`, `/assign-issue`, `/assign-pr`, `/request-review`, `/workflow-status`, `/repo-info`, `/mark-draft`, `/tags`, `/remote-url`, `/notifications`, `/open-repo`, `/open-pr`, `/open-pull-requests`, `/open-issues`, `/open-actions`, `/open-releases`, `/open-compare`, `/open-file`, `/view-issues`, `/view-issue`, `/view-pr`, `/blame`, `/clone`, `/fetch`, `/review-pr`

Design decisions baked in from the start:
- No AI attribution anywhere — commits, releases, PRs, issues, gists, comments
- Risky/history-rewriting actions (`reset-hard`, `squash`, `amend-msg`, force-adjacent ones) always warn if already pushed, and always offer Stash-first where relevant
- Commands that could apply to either an issue or a PR are kept as separate commands (`/close-issue` vs `/close-pr`, `/assign-issue` vs `/assign-pr`, `/add-label-issue` vs `/add-label-pr`) rather than one auto-detecting command — no guessing, one direct `gh` call each
- Requires `gh` (GitHub CLI) installed and logged in for anything GitHub-facing
