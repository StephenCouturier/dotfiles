---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Word each question so "yes" accepts your recommended answer.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

## Facts are yours, decisions are the user's

Finding _facts_ is your job, never the user's. Don't ask the user for anything you could look up yourself.

When a frontier question needs a fact from the environment (codebase, filesystem, tools, docs), dispatch a `scout` subagent with a fresh context to find it. Invoking this skill authorizes that delegation. If `subagent` isn't visible, call `subagents_enable` first.

```
subagent({ agent: "scout", cwd: "<repo>", task: "<goal, where to look, the exact fact needed, and the answer format>" })
```

Launches are async. Don't block on them: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the scout to report. Ask the rest of the frontier now. For a trivial lookup (one `rg` or one file read), do it yourself instead.

The _decisions_ are the user's: put each to them and wait.

## Done

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding. Natural next steps to offer: `/skill:to-spec`, then `/skill:to-tickets`.
