---
name: implement
description: Implement a piece of work based on a spec or set of tickets, test-first, then run a two-axis review.
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets. You implement it yourself in the current checkout. Never commit, push, or stage changes.

## 1. Load the work

Read `../to-tickets/TRACKER.md`. If the user passes a ticket or spec reference, fetch it and state its title before starting. If the reference is ambiguous, ask. Read `GLOSSARY.md` and relevant `docs/adr/` if present.

If the work spans several tickets with a non-trivial blocking graph, suggest `/skill:implement-spec` instead and ask which to use.

## 2. Build

Read the `tdd` skill at `../tdd/SKILL.md` and follow it, testing only at the seams the spec or user pre-agreed. If no seams were agreed, propose them and confirm with the user before writing tests.

If exploration is broad, dispatch a `scout` subagent (call `subagents_enable` first if `subagent` isn't visible) rather than reading everything yourself.

Run typechecking regularly, single test files regularly, and the full test suite once at the end. When a ticket's acceptance criteria are met, update its status per `TRACKER.md`.

## 3. Review

Once done, determine the review target: the base ref (`git merge-base HEAD origin/main`, falling back to `main`, then `master`), plus uncommitted work (`git diff HEAD` and untracked files from `git status --porcelain`). Launch both reviews in the same reply so they run in parallel:

```
subagent({
  workflow: "/Users/stephencouturier/.pi/agent/workflows/review.js",
  cwd: "<repo>",
  args: { cwd: "<repo>", target: "<base, changed files, exact diff commands>", focus: "<anything notable, or omit>" }
})

subagent({
  agent: "grill-reviewer",
  cwd: "<repo>",
  task: "Repo: <repo>. Diff commands: <exact commands>. Spec: <absolute path>. Tickets: <absolute paths>. Review the change against the spec."
})
```

Skip the `grill-reviewer` if there is no spec or ticket. When both return, present them under `## Standards` (the synthesized review) and `## Spec` (the grill-reviewer report), without merging or reranking across the two. End with one line: finding counts per axis and the worst issue within each.

## 4. Fix

Ask the user which findings to fix. Fix the accepted ones yourself, rerun the affected tests and the full suite, then summarize the changed files. Do not commit; leave that to the user.
