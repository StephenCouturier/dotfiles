# Issue tracker

Specs and tickets live as local markdown under `.scratch/` in the repo root by default. If the user passes a GitHub issue number or URL, use GitHub via `gh` for that work instead.

## Local markdown (default)

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Tickets are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order, never a single combined file
- Each ticket has `**Blocked by:**` and `**Status:**` lines near the top
- Status values: `ready-for-agent`, `in-progress`, `done`
- Comments and history append to the bottom under a `## Comments` heading
- Exploration notes for a feature go in `.scratch/<feature-slug>/notes/`

**Publish**: create the file, creating directories as needed.
**Fetch**: read the file at the referenced path, or resolve a bare ticket number against the feature's `issues/` directory.
**Frontier**: every ticket whose status is `ready-for-agent` and whose blockers are all `done`.
**Close**: set `**Status:** done` and tick the acceptance criteria that are met.

Never `git add` or commit anything under `.scratch/`.

## GitHub (only when the user references an issue)

- **Fetch**: `gh issue view <n> --comments`
- **Publish**: `gh issue create --title ... --body-file ... --label ready-for-agent` (create the label if missing). Ask before creating issues.
- **Blocking**: list blockers in a `## Blocked by` section with `#<n>` references.
- **Close**: comment with a summary and ask the user before running `gh issue close`.
