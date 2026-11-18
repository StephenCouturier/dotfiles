---
description: Parallel multi-agent code review, synthesized by review-lead into one prioritized list
argument-hint: "[scope]"
---
Run a multi-agent code review. Do not review the code yourself and do not make any edits.

1. Establish the review target from the scope below. For branch reviews, find the base with `git merge-base HEAD origin/main` (fall back to `main`, then `master`) and check `git status` for uncommitted work. If there are no changes, stop and tell me.
2. Make exactly one call:

```
subagent({
  workflow: "/Users/stephencouturier/.pi/agent/workflows/review.js",
  cwd: "<repo path>",
  args: {
    cwd: "<repo path>",
    target: "<base ref, head ref, changed files, and the exact diff commands, e.g. git diff <base>...HEAD and git diff>",
    focus: "<any extra focus from the scope, or omit>"
  }
})
```

3. When it finishes, present the synthesized report as-is.

## Scope for this run

${@:-The current branch's changes against its merge base, plus uncommitted work.}
