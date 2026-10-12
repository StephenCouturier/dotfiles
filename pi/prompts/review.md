---
description: Multi-perspective code review, synthesized into one prioritized list
argument-hint: "[scope]"
---
Run a multi-perspective code review. Do three focused review passes yourself, then
synthesize them into a single prioritized list. Do not make any edits.

## Passes

Run each pass in order, keeping notes per pass. Use the matching skill for the
detailed criteria of each pass:

1. **integration** - `review-integration` skill: codebase integration, pattern
   consistency, duplication
2. **architecture** - `review-architecture` skill: performance, scalability,
   future risk
3. **quality** - `review` skill: general correctness, readability, security,
   tests

## Synthesis

1. Aggregate findings from all three passes
2. Merge similar issues pointing at the same code location
3. Resolve conflicts with a balanced assessment when passes disagree
4. Re-rank by overall impact
5. Condense - remove redundancy, keep every actionable insight

## Output Format

Structure your feedback as:

**CRITICAL** (must fix - security, correctness)
- `file.ts:42` [NEW] - Specific issue description and suggested fix [integration, architecture]

**WARNING** (should fix - bugs, performance, maintainability)
- `file.ts:89` [EXISTING] - Specific issue description and suggested fix [quality]

**SUGGESTION** (consider - style, best practices, optimization)
- `file.ts:156` [NEW] - Specific issue description and suggested fix [integration, quality]

**POSITIVE** (good patterns worth highlighting)
- `file.ts:203` [NEW] - What was done well [architecture]

Each item includes two tags:

**Relevance tag** (after file:line):
- `[NEW]` - Issue introduced by or directly related to the current change
- `[EXISTING]` - Pre-existing issue not caused by the current change

**Attribution tag** (at end):
- `[integration]` - integration pass
- `[architecture]` - architecture pass
- `[quality]` - quality pass
- `[integration, architecture]` - multiple passes agreed

## Guidelines

- Be constructive and specific
- Provide rationale for each recommendation
- Include code examples when helpful
- Reference line numbers: `file.ts:42`
- ALWAYS include [NEW] or [EXISTING] tag for every item
- ALWAYS include attribution tags showing which pass flagged it
- Prioritize [NEW] issues as they are most relevant to the change
- When multiple passes flag the same issue, list all of them
- Consider the broader codebase context
- Balance thoroughness with practicality
- Acknowledge good practices when present
- Prioritize clarity over completeness when condensing

## Scope for this run

${@:-The current working changes (`git diff` and `git status`). Ask me if that is not what I meant.}
