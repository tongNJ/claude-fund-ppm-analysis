# Concepts: Harness, Loop, Hooks, Skills, Sub-agents

A short explainer of the building blocks used in this repo. If you've used Claude Code casually but the terminology trips you up, start here.

## The harness

A **harness** is the program that wraps the language model and turns a one-shot text completion into a running agent. The model itself is stateless: you give it a context, it produces a response. Everything else — keeping a message history, parsing tool calls, executing them, feeding results back, deciding when to stop — lives in the harness.

Claude Code is a harness. Cursor is a harness. A Python script that calls the API in a `while` loop is a harness. They use similar models under the hood; what differs is the harness around them.

## The agent loop

The loop is the core of any harness:

1. Send the message history to the model.
2. The model returns text and/or tool calls.
3. If there are tool calls, execute them.
4. Append the results to the history.
5. Go back to step 1.
6. Stop when the model returns no more tool calls (or some other stop condition).

That's it. Every "agent framework" in existence is some elaboration of this loop. The interesting design decisions are:

- When to compact / summarize the message history (context windows are finite)
- How to handle tool errors (retry? surface to user? fall through?)
- Whether to allow parallel tool calls
- How to stop pathological runs

## Hooks

**Hooks** are user-defined callbacks that the harness fires at specific points in the loop — for example, "before any tool runs" or "after the model finishes a turn." They let you inject deterministic behavior into a non-deterministic loop.

Common uses:

- Auto-format code after every Edit
- Block writes to certain paths (a guardrail)
- Run tests when the agent claims it's done, and feed failures back
- Log everything to a file for audit

The key idea: instead of asking the model nicely to "always run tests when finished" (which it might forget), you wire it into the harness so it always happens.

This repo doesn't use hooks yet, but they're worth knowing about — they're how you add policy to an agent without having to trust the model to follow it.

## Skills

A **skill** is a folder containing a `SKILL.md` file plus any supporting scripts, templates, or reference material. The `SKILL.md` describes a procedure: when to use it, what inputs it expects, what steps to follow, what output to produce. Claude reads the relevant skill before starting a task that matches its description.

Skills are how you teach the model *domain-specific procedural knowledge* — the kind of thing that's not in its training data and that varies by user. The `analyzing-fund-ppm` skill in this repo, for instance, encodes:

- Which sections of a PPM matter for an investment analyst
- How to extract them reliably from messy PDFs
- What format the final report should take (fonts, headings, tables)

Skills are version-controllable plain-text files. You can review them, diff them, share them — they're a clean abstraction.

## Sub-agents

A **sub-agent** is a separate Claude instance that the main agent can spawn to handle a delegated task. The parent calls a `Task` tool; the harness spins up a fresh Claude with its own context window, lets it run its own loop with its own tools, and returns only the final result back to the parent.

Why this matters for analyst workflows:

**Context isolation.** Running 100 PPMs through the main agent would fill the context window after about 5. Each PPM is ~50 pages of extraction text, validation chatter, and docx generation code. Delegating to a sub-agent means the parent only sees `OK | FundName | /path/to/file.docx | summary` — about 30 tokens per PPM. 100 PPMs = ~3,000 tokens.

**Parallelism.** The parent can dispatch multiple sub-agents in one turn. The harness runs them concurrently. 5-way parallelism gives you a 5× speedup for embarrassingly parallel work like "process every file in this folder."

**Specialization.** Each sub-agent has its own system prompt, its own tool allowlist, its own model choice. A "ppm-extractor" sub-agent runs Sonnet (cheaper, fast enough); a future "investment-thesis-builder" might run Opus.

**Trust boundaries.** A sub-agent processing untrusted input (e.g., a PDF from an unknown sender) can be sandboxed so prompt injections in that content can't reach the main agent's tools.

## How they compose

In this repo:

```
You (in Claude Code, the harness)
    │
    │ runs the agent loop
    ▼
Parent agent
    │
    │ /process-ppms ~/ppms ~/reports
    │
    │ (slash command tells the parent:
    │  "dispatch ppm-extractor sub-agents in parallel")
    │
    ▼
Sub-agent: ppm-extractor (one per PDF, 5 in parallel)
    │
    │ reads SKILL.md → runs extraction →
    │ generates .docx → returns OK line
    │
    ▼
Skill: analyzing-fund-ppm (the procedural recipe)
```

Each layer has a single responsibility:

- **Harness**: runs the loop, manages tools, enforces permissions.
- **Slash command**: the entry point — takes user input, plans the work.
- **Sub-agent**: an isolated worker — one PPM in, one report out.
- **Skill**: the domain knowledge — what a "good PPM analysis" looks like.

This separation is what makes it easy to extend. Adding a new workflow (e.g., processing a folder of fund DDQs) is a matter of:

1. Write a skill for "good DDQ analysis"
2. Write a sub-agent that runs that skill on one DDQ
3. Write a slash command that dispatches a batch

No changes to existing code. Each piece composes with the others.

## Further reading

- [Claude Code documentation](https://docs.claude.com/en/docs/claude-code/overview)
- [Skills overview](https://docs.claude.com/en/docs/claude-code/skills)
- [Sub-agents](https://docs.claude.com/en/docs/claude-code/sub-agents)
- [Hooks](https://docs.claude.com/en/docs/claude-code/hooks)
