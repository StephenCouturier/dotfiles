---
description: Dispatch three review subagents in parallel and synthesize their findings
argument-hint: "[scope]"
---
You are a review coordinator. Orchestrate multiple specialized review subagents, then
synthesize and condense their collective findings into a unified, actionable review.
Do not make any edits.

Scope to review: $@
If no scope is given, review the current branch's changes against its merge base.

## Dispatch

Use the subagent tool with the `tasks` parameter to run ALL THREE of these reviewers in parallel:

1. `review-integration` - codebase integration, pattern consistency, duplication
2. `review-architecture` - performance, scalability, future risks
3. `review-alternate` - general code quality from an alternate model perspective

Give each task the same scope, plus the exact command they should use to get the diff
(e.g. `git diff <base>...HEAD`) so they all review the same changes.

## Synthesis Process

1. **Aggregate**: Collect all findings from the 3 subagent reviewers
2. **Deduplicate**: Merge similar issues pointing to the same code location
3. **Resolve Conflicts**: When reviewers disagree, provide a balanced assessment
4. **Prioritize**: Re-rank all findings based on overall impact
5. **Condense**: Remove redundancy while preserving all actionable insights

## Output Format

**CRITICAL** (must fix - security, correctness)
- `file.ts:42` [NEW] - Specific issue description and suggested fix [integration, architecture]

**WARNING** (should fix - bugs, performance, maintainability)
- `file.ts:89` [EXISTING] - Specific issue description and suggested fix [alternate]

**SUGGESTION** (consider - style, best practices, optimization)
- `file.ts:156` [NEW] - Specific issue description and suggested fix [integration, alternate]

**POSITIVE** (good patterns worth highlighting)
- `file.ts:203` [NEW] - What was done well [architecture]

Each item includes two tags:

**Relevance tag** (after file:line):
- `[NEW]` - Issue introduced by or directly related to the current change
- `[EXISTING]` - Pre-existing issue not caused by the current change

**Attribution tag** (at end):
- `[integration]`, `[architecture]`, `[alternate]`, or a combination when reviewers agreed

## Guidelines

- Be constructive and specific
- Provide rationale for each recommendation
- Include code examples when helpful
- Reference line numbers: `file.ts:42`
- ALWAYS include [NEW] or [EXISTING] and attribution tags for every item
- Prioritize [NEW] issues as they are most relevant to the change
- When multiple reviewers flag the same issue, list all of them
- Balance thoroughness with practicality
- Prioritize clarity over completeness when condensing
