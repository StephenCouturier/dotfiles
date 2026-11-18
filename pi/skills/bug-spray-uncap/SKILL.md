---
name: bug-spray-uncap
description: "Turn the bugs selected in /skill:bug-spray into a spec batch at ~/specs/bug-spray-<timestamp>/, one ticket file per bug in the to-tickets format. No interview, just synthesis of the triage."
disable-model-invocation: true
---

This is `to-spec` and `to-tickets` specialised for a bug batch. Read `../to-spec/SKILL.md`, `../to-tickets/SKILL.md`, and `../to-tickets/TRACKER.md`, and follow them, with the overrides below. Do NOT interview the user; synthesize the `bug-spray` triage already in the conversation. If there is no triage in the conversation, tell the user to run `/skill:bug-spray` first and stop.

## Overrides

- **Location**: publish to `~/specs/bug-spray-<YYYYMMDD-HHMM>/` (local time) instead of `.scratch/<feature>/`. That folder name is the **batch key**. Never write into the repo.
- **One ticket per bug**: `issues/<NN>-<JIRA-KEY>.md`, numbered in triage rank order. Bugs are independent, so every ticket is `**Blocked by:** None (can start immediately)`. If two bugs share a root cause, merge them into one ticket named after the lower key and note both keys, rather than adding a blocking edge.
- **Seams**: use each scout's Test Seam. Present the seams per bug in one list and confirm them with the user before publishing, as `to-spec` requires.
- **Paths**: unlike the base templates, a bug ticket may name the files and line ranges from the scout's Root Cause, since the bug pins them down. Still no code snippets.

## spec.md

```
# Bug spray <batch key>

**Status:** ready-for-agent
**Repo:** <absolute repo root>
**Base:** origin/main

## Triage

<the ranked Spray table from bug-spray, limited to the selected tickets>

## Shared Conventions

Pointers to the repo's root AGENTS.md, the AGENTS.md files along the touched paths, and .claude/rules/ files the implementers must follow.

## Testing Decisions

What makes a good regression test here: one failing test at the ticket's seam that reproduces the bug, then passes. Only test external behaviour.

## Out of Scope

Tickets triaged but not selected, with their tier and reason.
```

## issues/<NN>-<JIRA-KEY>.md

```
# <NN>: <JIRA-KEY> <summary>

**Jira:** <KEY> (<url>)
**Branch slug:** <kebab-case summary, at most 6 words>
**Blocked by:** None (can start immediately)
**Status:** ready-for-agent

## Bug

Observed vs expected behaviour, from the user's perspective, with repro steps.

## Root Cause

From the scout, with path:line references.

## Fix

The intended change in prose.

## Test Seam

The seam and prior-art spec files.

## Risks

Blast radius and adjacent behaviour to keep intact.

- [ ] A regression test at the seam fails before the fix and passes after
- [ ] <bug-specific acceptance criterion>
- [ ] Typecheck, oxfmt, and type-aware oxlint pass on changed files
```

Report the batch path and ticket list. Natural next step: `/skill:bug-spray-spray ~/specs/<batch key>`.
