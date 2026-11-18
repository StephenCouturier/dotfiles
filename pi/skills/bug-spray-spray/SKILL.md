---
name: bug-spray-spray
description: "Implement a bug-spray batch from ~/specs/bug-spray-<timestamp>/ in parallel: one implementer per bug, each in its own worktree on its own branch named after the Jira key, then run the review suite on each and report when all are done. Nothing is committed."
disable-model-invocation: true
---

This is `implement-spec` with **one branch per bug instead of one integration checkout**. Read `../implement-spec/SKILL.md` and `../to-tickets/TRACKER.md` and follow them, with the overrides below. You are the **orchestrator**: you never implement or review yourself. Invoking this skill authorizes subagent delegation; if `subagent` isn't visible, call `subagents_enable` first.

## Overrides

- **Batch**: the argument is a batch folder under `~/specs/`. If none was given, use the newest `~/specs/bug-spray-*` and confirm it with the user. The repo is the spec's `**Repo:**` line.
- **Worktrees**: use `scripts/bug-wt.sh` (resolve against this skill's directory, absolute path, run from the repo root) instead of `wt.sh`:
  - `bug-wt.sh create <JIRA-KEY> <branch slug>` fetches the base and creates a worktree on a new branch `<author>/<JIRA-KEY>/<slug>` off `origin/main`, printing its path. Worktrees live under `~/.pi/agent/worktrees/<repo>-bug-spray/<JIRA-KEY>`.
  - `bug-wt.sh remove <KEY>` and `bug-wt.sh clean` delete worktrees but always keep the branches.
- **No merge step.** The steps below replace `implement-spec`'s steps 1–8. Every fix stays uncommitted in its own worktree. Never apply patches to the main checkout and never run mergers.
- **Never** commit, push, stage, stash, reset, or switch branches in any worktree, and never let a subagent do so. Never touch Jira.
- **Pre-existing changes** in the main checkout don't matter, since worktrees branch off `origin/main`.

## Steps

1. **Load.** Read `spec.md` and every ticket in `issues/`. The frontier is every ticket with `**Status:** ready-for-agent`. Present the tickets, branch names, and the concurrency (default up to 4 implementers at once), and ask the user to confirm before launching anything.

2. **Launch implementers.** For each frontier ticket, up to the concurrency limit: run `bug-wt.sh create`, set the ticket's status to `in-progress`, then launch one async implementer:

   ```
   subagent({
     agent: "implementer",
     cwd: "<worktree path>",
     task: "Ticket: <abs ticket path>. Spec: <abs spec path>. Your cwd is an isolated worktree on branch <branch>; work only there and never commit. Install dependencies with `nvm use && yarn install --immutable` if node_modules is missing. Fix this bug test-first per the tdd skill: write one failing regression test at the ticket's Test Seam, then make it pass. Before finishing, run from the worktree root `yarn oxfmt <changed files>` then `yarn oxlint --type-aware --fix <changed files>`, typecheck, and run the specs covering the changed files."
   })
   ```

   Native completion wakes you. Don't poll or sleep.

3. **Review each as it completes.** When an implementer finishes:
   - If it reports `blocked` or `needs-decision`, append its report under the ticket's `## Comments`, leave the status `in-progress`, ask the user, and `resume` it with the answer. Don't let one blocked bug stall the others.
   - If it finished, launch both reviews in the same reply, `cwd` set to that worktree. Diff commands: `git -C <worktree> diff HEAD` plus untracked files from `git -C <worktree> status --porcelain`.

   ```
   subagent({
     workflow: "/Users/stephencouturier/.pi/agent/workflows/review.js",
     cwd: "<worktree>",
     args: { cwd: "<worktree>", target: "<diff commands and changed files>", focus: "Bug fix for <JIRA-KEY>, per <abs ticket path>" }
   })

   subagent({
     agent: "grill-reviewer",
     cwd: "<worktree>",
     task: "Repo: <worktree>. Diff commands: <commands>. Spec: <abs spec path>. Ticket: <abs ticket path>. Review the change against the ticket."
   })
   ```

   - Then launch the next frontier ticket, keeping at most the concurrency limit of implementers running. Reviews don't count toward the limit.

4. **Record.** When both reviews for a ticket return, append under its `## Comments` the implementer's Verification section and both review reports, each under its own heading. Close the ticket per `TRACKER.md` only if the implementer reported `done`; never auto-fix findings.

5. **Report when all are done.** Once every ticket is closed or waiting on the user, write `~/specs/<batch>/report.md` and present it:

   | Key | Branch | Worktree | Status | Tests | Lint | Standards | Spec | Worst issue |
   | --- | --- | --- | --- | --- | --- | --- | --- | --- |

   **Standards** and **Spec** are finding counts from the review workflow and `grill-reviewer`, kept separate and never reranked across each other. Below the table, list every blocked or needs-decision ticket with its question. Ask which findings to fix; send accepted findings for a ticket to a fresh implementer with `cwd` set to that ticket's worktree, then rerun its specs.

6. **Leave worktrees in place.** They hold the uncommitted fixes, so never run `bug-wt.sh clean` unless the user asks. Remind the user that nothing was committed or pushed, and that each branch is ready for them to review, commit, and open a PR with the `pr` skill.

## Failures

If a subagent launch or run fails, report the exact failure and which worktrees and tickets are in flight, and retry the same way once. If `bug-wt.sh create` fails because a branch or worktree already exists, skip that ticket and ask the user rather than reusing it.
