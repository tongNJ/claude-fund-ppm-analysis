# claude-fund-research

### See an example before installing

Curious what the output looks like? Open [`skills/analyzing-fund-ppm/examples/example-fund-ppm-analysis.docx`](skills/analyzing-fund-ppm/examples/example-fund-ppm-analysis.docx) for a sanitized 5-page sample showing all 10 sections of a typical PPM analysis. Everything in it (fund name, manager, key persons) is fictional — the example is purely illustrative.

A growing collection of [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) skills, sub-agents, and slash commands for hedge fund research workflows — built by an investment analyst, for analysts.

The goal is to take repetitive analyst tasks (reading PPMs, polishing meeting notes, writing DD memos, running batch analyses) and turn them into reliable, reusable Claude Code workflows that produce institutional-quality output.

## What's inside

| Component | What it does |
|---|---|
| **Skill: `analyzing-fund-ppm`** | Reads a Private Placement Memorandum PDF, extracts key terms (fees, lockups, redemptions, service providers, key persons), and produces a polished Word report. |
| **Sub-agent: `ppm-extractor`** | A worker that runs the PPM skill on a single PDF in isolation. Designed to be dispatched in parallel batches by a parent agent so you can process hundreds of PPMs without bloating your main context. |
| **Command: `/process-ppms`** | A slash command that coordinates batch PPM processing — point it at a folder, walk away, come back to a folder of reports. |

More skills will be added over time (polish-meeting-notes, fund-investment-dd, fund-ar-analysis, meeting-pack-summary, ...). The repo is structured so each new skill is an additive folder, not a rewrite.

## Why this exists

Fund research has a lot of "read a long PDF, extract structured information, write a polished document" cycles. LLMs are great at this, but doing it ad hoc in chat is messy: context windows fill up, formatting drifts, and there's no audit trail. Wrapping the work in skills + sub-agents gives you:

- **Reproducibility** — same input, same structure of output, every time.
- **Scale** — sub-agents process 100 PPMs in the time chat handles 5.
- **Versionable artifacts** — skills are markdown files. Diff them. Review them. Roll back.

If you're new to the underlying concepts (skills, harness, hooks, sub-agents), start at [`docs/concepts.md`](docs/concepts.md).

## Quick start

**Prerequisites**

- [Claude Code](https://docs.claude.com/en/docs/claude-code/setup) installed and authenticated
- Node.js 18+ (for the docx generator)
- Python 3.9+ with `pdfplumber` (`pip install pdfplumber`)
- `pdftotext` available on PATH (part of `poppler-utils` on most systems)

**Install**

```bash
git clone https://github.com/tongNJ/claude-fund-ppm-analysis.git
cd claude-fund-research
./install.sh
```

The installer symlinks the skills, sub-agents, and commands into your `~/.claude/` directory, so updates from `git pull` flow through automatically.

**First run**

```bash
mkdir -p ~/ppm-test/in ~/ppm-test/out
# drop 2–3 PPM PDFs into ~/ppm-test/in
claude
```

Then in the Claude Code session:

```
/process-ppms ~/ppm-test/in ~/ppm-test/out
```

Reports will appear in `~/ppm-test/out` as `.docx` files.

For full installation details, see [`docs/installation.md`](docs/installation.md). For permissions setup (so the batch runs without permission prompts every minute), see [`docs/permissions.md`](docs/permissions.md).

## Project structure

```
claude-fund-research/
├── docs/                 # Concept explainers, install, permissions
├── skills/               # Domain-specific procedural knowledge
│   └── analyzing-fund-ppm/
├── sub-agents/           # Workers that run skills in isolated context
│   └── ppm-extractor/
├── commands/             # Slash commands for the parent agent
├── settings/             # Example Claude Code settings
└── install.sh            # Symlinks everything into ~/.claude/
```

## Roadmap

Planned additions (in rough priority order):

- [ ] `polish-meeting-notes` skill — clean up raw manager-meeting notes into professional summaries
- [ ] `fund-investment-dd` skill + sub-agent — full DD memo from a folder of fund documents
- [ ] `meeting-pack-summary` skill — pre-trip meeting pack from a folder of newsletters
- [ ] `fund-ar-analysis` skill — AR-driven fund flow / fee economics deck
- [ ] JSON output mode for `ppm-extractor` (enables cross-fund comparison tables)
- [ ] Aggregator sub-agent that builds a master spreadsheet from a batch of PPM analyses

Suggestions and PRs welcome — see [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Contributing

This started as personal tooling but is shared in the hope it's useful to other analysts. If you build a related skill or sub-agent and want to contribute it, open a PR following the patterns in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

MIT. See [`LICENSE`](LICENSE).

## Disclaimer

This software is provided as-is for research and productivity purposes. The skills and sub-agents in this repo do not provide investment advice. Outputs should always be reviewed by a qualified analyst before being used in any investment decision. Fund names appearing in any examples are fictional.
