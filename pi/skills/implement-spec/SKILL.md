---
name: implement-spec
description: Implement a spec and its tickets (from /skill:to-spec and /skill:to-tickets) by orchestrating parallel implementer subagents in isolated worktrees, merging results into the current checkout without committing.
disable-model-invocation: true
---

You have been given a spec with tickets describing how to implement it. You are the **orchestrator**: you never implement tickets yourself. Invoking this skill authorizes subagent delegation; if `subagent` isn't visible, call `subagents_enable` first.

The goal is the entire spec implemented as **uncommitted changes in the current checkout** (the **integration checkout**), with every ticket closed per `../to-tickets/TRACKER.md`. Never commit, push, stage, stash, or switch branches, and never let a subagent do so. The user commits.

The tickets are not a list of steps. They are a **task graph** with blocking edges, so there is always a **frontier** of tickets ready to grab: every ticket whose blockers are all `done`.

## Isolation without commits

Each implementer works in its own detached git worktree created by `scripts/wt.sh`, run from the integration checkout root:

- `scripts/wt.sh create <NN>` creates a worktree that snapshots the integration checkout's current state, including uncommitted and untracked files, and prints its path.
- `scripts/wt.sh apply <NN>` computes the implementer's changes relative to that snapshot and applies them to the integration checkout. It tries a plain apply, then a 3-way merge using a throwaway index. Exit `2` means conflict markers were left in the integration checkout and the patch path is printed.
- `scripts/wt.sh remove <NN>` deletes one worktree; `scripts/wt.sh clean` deletes them all.

Resolve `scripts/wt.sh` against this skill's directory and use the absolute path. Worktrees live under `~/.pi/agent/worktrees/<repo>/`. Ignored files like `node_modules` are not copied; implementers install dependencies themselves.

## Communication

Start every subagent with a fresh context. Keep briefs sparse and use **context pointers**: absolute paths to the spec, the ticket, exploration notes, and `GLOSSARY.md`/ADRs. Don't paste content that a pointer already covers. Point at spec and ticket files in the integration checkout by absolute path, since `.scratch/` may be gitignored and absent from worktrees.

## Steps

1. **Load the graph.** Read `../to-tickets/TRACKER.md`, the spec, and every ticket. Build the task graph and compute the initial frontier. Run `git status --short` and note any pre-existing changes, since they will be part of every snapshot. Present the graph, the first frontier, and the concurrency you plan to use (default up to 4 implementers at once), then ask the user to confirm before launching anything. Tell them not to edit the checkout while the run is in progress.

2. **(optional) Explore.** If the tickets need shared exploration of the codebase or external docs, run one `worker` subagent with this brief: read-only on code, write markdown notes only to `<repo>/.scratch/<feature>/notes/`, never git add. Notes let implementers focus on implementing.

3. **Launch implementers for the frontier.** For each frontier ticket, up to the concurrency limit:
   - run `scripts/wt.sh create <NN>`;
   - set the ticket's status to `in-progress`;
   - launch one async implementer:

   ```
   subagent({
     agent: "implementer",
     cwd: "<worktree path>",
     task: "Ticket: <abs ticket path>. Spec: <abs spec path>. Notes: <abs notes dir or none>. Glossary/ADRs: <abs paths or none>. Your cwd is an isolated worktree; work only there and never commit. Build this ticket test-first per the tdd skill at the seams in the spec's Testing Decisions. Run the full suite once at the end."
   })
   ```

   Launches are async; native completion wakes you. Don't poll or sleep.

4. **Merge as each implementer completes.** Only one writer touches the integration checkout at a time, so merge completions one at a time.
   - If the report says `blocked` or `needs-decision`, don't merge. Resolve it with the user, then `resume` that implementer with the answer.
   - Otherwise run `scripts/wt.sh apply <NN>`.
   - On exit `2`, launch one `worker` **merger subagent** with `cwd` set to the integration checkout. Its brief: the conflicted files from the apply output, the patch path, the ticket and spec paths, and the instructions to resolve every conflict marker preserving both tickets' intent, never touch git state beyond reading, and run the tests covering the conflicted files. Wait for it before applying anything else or creating new worktrees.
   - After a successful merge, run typechecking and the ticket's test files in the integration checkout. If they fail, send the failure to a fresh implementer with `cwd` set to the integration checkout, and hold other merges until it finishes.
   - Close the ticket per `TRACKER.md` and run `scripts/wt.sh remove <NN>`.

5. **Advance the frontier.** After each merge, recompute the frontier and launch implementers (step 3) for newly unblocked tickets, up to the concurrency limit. New worktrees snapshot the integration checkout, so they include every merged ticket. Never create a worktree while a merger or fixer is writing to the integration checkout.

6. **Review.** Once every ticket is `done`, run the full test suite in the integration checkout. Then launch both reviews in the same reply so they run in parallel. Diff commands: `git diff HEAD` plus untracked files from `git status --porcelain`; mention any pre-existing changes noted in step 1 so reviewers can tell them apart.

   ```
   subagent({
     workflow: "/Users/stephencouturier/.pi/agent/workflows/review.js",
     cwd: "<repo>",
     args: { cwd: "<repo>", target: "<diff commands, changed files, pre-existing changes>", focus: "Implementation of <spec path>" }
   })

   subagent({
     agent: "grill-reviewer",
     cwd: "<repo>",
     task: "Repo: <repo>. Diff commands: <commands>. Pre-existing changes to ignore: <list or none>. Spec: <abs path>. Tickets: <abs paths>. Review the change against the spec."
   })
   ```

   Present them under `## Standards` and `## Spec` without merging or reranking across the two, ending with one line of finding counts per axis and the worst issue within each.

7. **Fix.** Ask the user which findings to fix. Send the accepted findings to a single fresh implementer with `cwd` set to the integration checkout, then rerun the full suite.

8. **Report and clean up.** Run `scripts/wt.sh clean`. Report the tickets closed, files changed (`git status --short`), test results, and anything deferred. Remind the user that nothing was committed.

## Failures

If a subagent launch or run fails, stop launching new work, report the exact failure and which worktrees and tickets are in flight, and retry the same way once. If an apply leaves the integration checkout in a state you can't explain, stop and ask the user before doing anything else.
