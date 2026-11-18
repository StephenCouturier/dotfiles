---
name: bug-spray
description: "Entry point for bug batches: take a list of Jira bug tickets, triage each in parallel with bug-scout subagents, and present a ranked list by feasibility, effort, and human intervention needed. Next steps: /skill:bug-spray-uncap then /skill:bug-spray-spray."
disable-model-invocation: true
---

You are the bug-spray **triage orchestrator**. You never fix anything here. Invoking this skill authorizes subagent delegation; if `subagent` isn't visible, call `subagents_enable` first.

## Input

Jira ticket keys, ticket URLs, or a JQL query, passed as the argument or in the conversation. If none were given, ask for them and stop.

## Steps

1. **Fetch.** Use the Atlassian MCP from codemode (cloud ID in the repo's root `AGENTS.md`): `searchJiraIssuesUsingJql` for JQL, `getJiraIssue` for keys. Batch the calls with `Promise.allSettled`. For each ticket keep only key, summary, description, status, priority, components, labels, reporter, repro steps, and comments. Drop tickets that are already Done or not bugs, and list them as skipped with the reason.

2. **Scout.** Launch one async `bug-scout` per ticket in the same reply, `cwd` set to the repo root, up to 8 at once. Brief each with the ticket fields inline, since scouts cannot reach Jira:

   ```
   subagent({
     agent: "bug-scout",
     cwd: "<repo>",
     task: "Repo: <repo>. Ticket <KEY>: <summary>.\n\nDescription:\n<description>\n\nRepro:\n<repro or none>\n\nComments:\n<relevant comments or none>\n\nTriage this bug and return your scored assessment."
   })
   ```

   Native completion wakes you. Don't poll or sleep. If a scout fails, retry it once, then score that ticket `low` feasibility with the failure as the reason.

3. **Rank.** Sort by human intervention (`none` first), then feasibility (`high` first), then effort (`S` first), then confidence, then Jira priority. Group the list into tiers:
   - **Spray**: intervention `none`, feasibility `high` or `medium`, effort `S` or `M`.
   - **Needs a human**: anything whose only blocker is intervention; name what's needed.
   - **Skip**: feasibility `low`, effort `L`, or `compliance`/`infra` intervention.

4. **Present.** One table per tier:

   | # | Key | Summary | Feasibility | Effort | Intervention | Confidence | Why |
   | --- | --- | --- | --- | --- | --- | --- | --- |

   Keep **Why** to one line: the root-cause location and the deciding factor. Below the tables, list every open question from the scouts, grouped by ticket key.

5. **Hand off.** Ask the user which tickets to spray, defaulting to the Spray tier, and whether to answer any open questions now. Keep each selected scout report in context; `bug-spray-uncap` turns them into specs. Natural next step: `/skill:bug-spray-uncap`.

Never transition, comment on, or edit Jira tickets.
