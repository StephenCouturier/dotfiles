---
name: merge-conflicts
description: Resolves git merge/rebase/cherry-pick conflicts and reports every resolution decision with code snippets and reasoning. Use when the user asks to fix, resolve, or explain merge conflicts.
---

# Merge Conflict Resolution

Resolve all conflicts in the working tree, then produce a report listing every change made and why.

## 1. Gather context

```bash
git status
git diff --name-only --diff-filter=U
```

Identify the operation in progress and what each side represents:

- Merge: `ours` = current branch (`git branch --show-current`), `theirs` = `MERGE_HEAD` (`git log -1 --oneline MERGE_HEAD`)
- Rebase: `ours` = the branch being rebased onto (upstream), `theirs` = the commit being replayed (`cat .git/rebase-merge/stopped-sha` or `git log -1 REBASE_HEAD`). Note this inversion in the report.
- Cherry-pick: `theirs` = `CHERRY_PICK_HEAD`

Understand intent before editing. For each conflicted file:

```bash
git log --oneline -5 HEAD -- <file>
git log --oneline -5 MERGE_HEAD -- <file>
git diff <merge-base>...HEAD -- <file>
git diff <merge-base>...MERGE_HEAD -- <file>
```

Use `git merge-base HEAD MERGE_HEAD` (or the rebase equivalent) for the base. Use `git show :1:<file>` (base), `:2:` (ours), `:3:` (theirs) when the marker view is confusing.

## 2. Resolve

For each conflict hunk:

- Read the full surrounding code, not just the markers.
- Determine what each side was trying to do. Preserve both intents whenever possible.
- Prefer combining changes over picking a side. Pick one side only when the changes are truly incompatible or one side supersedes the other (e.g. code was deleted/moved upstream).
- If code moved or was renamed on one side, apply the other side's change at the new location.
- Check for non-marker semantic conflicts: renamed imports/functions used by the other side, changed signatures, duplicated imports, removed exports.
- Lockfiles and generated files: do not hand-merge. Take one side and regenerate (e.g. `yarn install`, codegen), and say so in the report.
- Migrations: never merge two migration files into one; check ordering/timestamps.
- Do not add code comments.

If a resolution is genuinely ambiguous (business logic conflict, intents contradict), stop and ask the user, showing both sides, instead of guessing.

After editing, confirm no markers remain:

```bash
rg -n '^(<<<<<<<|=======|>>>>>>>)' <files>
```

Stage resolved files with `git add <file>` only. Never run `git commit`, `git merge --continue`, `git rebase --continue`, or push unless the user asks.

## 3. Verify

Run what applies to the changed files: formatter, linter, typecheck, and related tests. Report results.

## 4. Report

Output the report in this exact format. One entry per conflict hunk (group trivially identical hunks in the same file into one entry).

```markdown
## Merge Conflict Resolution

**Operation:** merge | rebase | cherry-pick
**Ours:** `<branch/sha>` – <one-line summary>
**Theirs:** `<branch/sha>` – <one-line summary>
**Files resolved:** N

### 1. `path/to/file.ts:LINE`

**Strategy:** combined | kept ours | kept theirs | rewritten

**Ours:**
```ts
<our side of the hunk>
```

**Theirs:**
```ts
<their side of the hunk>
```

**Resolution:**
```ts
<final code>
```

**Why:** <1–3 sentences: what each side intended and why this resolution preserves the right behavior>

### 2. ...

---

### Additional changes outside conflict markers
- `path:LINE` – <what changed and why, e.g. updated call site for renamed function> (include a snippet)

### Regenerated files
- `yarn.lock` – took theirs, ran `yarn install`

### Verification
- Lint: pass/fail
- Typecheck: pass/fail
- Tests: `<command>` – pass/fail

### Needs review
- <anything uncertain or worth a human double-check, or "None">
```

Keep snippets trimmed to the relevant lines; use `...` for elided unchanged code.
