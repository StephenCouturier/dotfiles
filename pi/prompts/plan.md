---
description: Investigate and produce an implementation plan without changing anything
argument-hint: "<task>"
---
Enter PLAN MODE for the following task:

${@:-(no task given — ask me what to plan before doing anything else)}

Rules for this turn — follow them strictly:

1. **Do not modify anything.** No `edit`, no `write`, no mutating shell commands
   (no `git commit/checkout/apply`, no `npm install`, no `mv/rm/mkdir`, no writing
   to files, no code formatters). Read-only exploration only: `read`, `ls`, `rg`,
   `find`, `git status`, `git diff`, `git log`, and similar.
2. **Investigate first.** Read the actual files involved before proposing anything.
   Do not guess at APIs, file paths, or existing conventions — verify them.
3. **Ask before assuming.** If requirements are ambiguous or there are multiple
   reasonable approaches, ask me rather than picking silently.

Then output a plan in exactly this shape:

## Goal
One or two sentences on what we're actually trying to achieve.

## Current state
What exists today, with concrete `path/to/file.ts:line` references for each claim.

## Approach
The proposed approach, and briefly why it beats the alternatives you considered.

## Steps
Numbered, ordered, each one concrete and independently reviewable:
1. `path/to/file` — what changes and why
2. ...

## Risks & open questions
Anything that could break, anything you had to assume, anything you need from me.

Stop after the plan. Wait for my approval before writing a single line of code.
If I approve, implement the plan step by step and tell me if reality diverges
from it.
