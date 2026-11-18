const cwd = args.cwd;
const target = args.target;
const focus = args.focus || "None";

const brief = [
  "Repository cwd: " + cwd,
  "",
  "Review target:",
  target,
  "",
  "Additional focus: " + focus,
  "",
  "Inspect the diff yourself with the commands listed in the target. Review only, never edit files.",
  "Return findings in your skill's output format with file:line references and [NEW]/[EXISTING] tags.",
  "If nothing qualifies, say exactly: No issues found.",
].join("\n");

const reviewers = [
  { key: "architecture", agent: "review-architecture", label: "Review architecture and performance" },
  { key: "integration", agent: "review-integration", label: "Review integration and duplication" },
  { key: "quality", agent: "review", label: "Review quality and correctness" },
  { key: "alternate", agent: "review-alternate", label: "Review edge cases and failure modes" },
];

const settled = await Promise.allSettled(
  reviewers.map(function (r) {
    return runs.run(r.key, { label: r.label, agent: r.agent, cwd: cwd, task: brief });
  })
);

const sections = settled.map(function (s, i) {
  const r = reviewers[i];
  if (s.status === "fulfilled" && s.value.ok) {
    return "### " + r.key + " (" + r.agent + ")\n\n" + s.value.output;
  }
  const reason = s.status === "rejected" ? String(s.reason) : (s.value.error || "did not complete");
  return "### " + r.key + " (" + r.agent + ")\n\nFAILED: " + reason;
});

const synthesis = await runs.run("synthesis", {
  label: "Synthesize review findings",
  agent: "review-lead",
  cwd: cwd,
  task: [
    brief,
    "",
    "## Reviewer reports",
    "",
    sections.join("\n\n---\n\n"),
  ].join("\n"),
});

return synthesis.output;
