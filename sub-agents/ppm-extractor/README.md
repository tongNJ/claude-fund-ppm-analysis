# Sub-agent: ppm-extractor

A worker sub-agent that processes one PPM PDF end-to-end and produces one Word report.

## Files in this folder

- **`ppm-extractor.md`** — the sub-agent definition (system prompt + YAML frontmatter). This is what gets symlinked into `~/.claude/agents/`.
- **`USAGE.md`** — full usage reference: when to use it, prompt templates, troubleshooting.

## Pairs with

- **Skill**: [`skills/analyzing-fund-ppm`](../../skills/analyzing-fund-ppm) — the procedural recipe for "how to analyze a PPM."
- **Slash command**: [`commands/process-ppms.md`](../../commands/process-ppms.md) — the batch coordinator that dispatches this sub-agent in parallel.

## Quick reference

| Question | Answer |
|---|---|
| What does it return to the parent? | One line: `OK \| FundName \| /path/to/report.docx \| summary` |
| How many PPMs per invocation? | Exactly one. The slash command handles batching. |
| Tools it can use | `Read, Bash, Write, Glob` (no network, no Edit) |
| Model | Sonnet (cheaper, fast enough; configurable in YAML) |
| Context cost to parent | ~30 tokens per PPM |

For everything else, see [`USAGE.md`](USAGE.md).
