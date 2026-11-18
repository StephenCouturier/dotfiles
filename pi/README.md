# pi config

Symlinked into `~/.pi/agent/`:

| dotfiles | target |
| --- | --- |
| `pi/AGENTS.md` | `~/.pi/agent/AGENTS.md` |
| `pi/settings.json` | `~/.pi/agent/settings.json` |
| `pi/prompts/` | `~/.pi/agent/prompts/` |
| `pi/skills/` | `~/.pi/agent/skills/` |
| `pi/agents/` | `~/.pi/agent/agents/` |
| `pi/workflows/` | `~/.pi/agent/workflows/` |

Setup:

```sh
cd ~/.pi/agent
ln -sfn ~/dotfiles/pi/AGENTS.md AGENTS.md
ln -sfn ~/dotfiles/pi/settings.json settings.json
ln -sfn ~/dotfiles/pi/prompts prompts
ln -sfn ~/dotfiles/pi/skills skills
ln -sfn ~/dotfiles/pi/agents agents
ln -sfn ~/dotfiles/pi/workflows workflows
```

Prompt templates (`/name`) were ported from the opencode primary agents; skills
(model-invoked) from the opencode subagents.

Subagents (`pi-subagents`) in `agents/`. `/review [scope]` runs
`workflows/review.js`, which fans out `review-architecture` (claude-fable-5-1),
`review-integration` (claude-opus-5-5), `review` (claude-opus-5-5) and
`review-alternate` (gpt-6.1-sol) in parallel, then hands their reports to
`review-lead` (claude-sonnet-5-5) to synthesize one report. No nested
subagents. Each reviewer loads its matching skill rather than duplicating it.

Spec workflow skills, ported from [mattpocock/skills](https://github.com/mattpocock/skills):
`/skill:grill-me` (or `grill-with-docs`) → `/skill:to-spec` → `/skill:to-tickets` →
`/skill:implement-spec` (or `/skill:implement` for single-agent work). Specs and
tickets live in `.scratch/<feature>/` (see `skills/to-tickets/TRACKER.md`).
`implement-spec` runs `implementer` agents in parallel detached worktrees via
`skills/implement-spec/scripts/wt.sh` and merges their patches into the checkout
uncommitted. Reviews run `workflows/review.js` alongside `grill-reviewer`
(spec compliance). Nothing is ever committed.

Bug batches: `/skill:bug-spray <Jira keys or JQL>` triages each bug with a
parallel `bug-scout` and ranks them by feasibility, effort and human
intervention. `/skill:bug-spray-uncap` publishes the selected bugs as a
`to-spec`/`to-tickets` batch at `~/specs/bug-spray-<YYYYMMDD-HHMM>/`.
`/skill:bug-spray-spray` runs one `implementer` per bug in its own worktree on
branch `<author>/<KEY>/<slug>` off `origin/main` (via
`skills/bug-spray-spray/scripts/bug-wt.sh`), reviews each with
`workflows/review.js` and `grill-reviewer`, and writes `report.md` to the batch.
Nothing is merged or committed.
