# Contributing

This repo started as personal tooling and is shared in the hope it's useful to other analysts. Contributions are welcome — especially new skills and sub-agents that follow the same patterns.

## Adding a new skill

A skill is a folder under `skills/` with a `SKILL.md` and any supporting files. Use `skills/analyzing-fund-ppm/` as the template.

```
skills/your-new-skill/
├── SKILL.md          # required: name, description, instructions
├── README.md         # short overview, what it does, who triggers it
├── scripts/          # optional: any helper scripts
└── examples/         # optional: sanitized example outputs
```

The `SKILL.md` frontmatter must include:

- `name` — must match the folder name
- `description` — when to trigger; this is what Claude Code uses for routing

Test locally before submitting:

1. Symlink it manually: `ln -s "$(pwd)/skills/your-new-skill" ~/.claude/skills/your-new-skill`
2. Open Claude Code, ask for something matching your skill's description, verify it triggers
3. Update `install.sh` to include the new skill in the `TARGETS` array
4. Update the top-level `README.md` "What's inside" table

## Adding a new sub-agent

Sub-agents live under `sub-agents/<name>/` and contain at minimum:

```
sub-agents/your-new-agent/
├── your-new-agent.md   # the YAML+system prompt definition
├── README.md           # quick reference
└── USAGE.md            # full prompt templates and troubleshooting
```

Conventions established in this repo:

- **Single responsibility.** One sub-agent = one task. Don't build "Swiss army knife" agents.
- **Restricted tools.** Only list the tools the agent actually needs in YAML `tools:`. Default is to think narrowly.
- **Sonnet by default.** `model: sonnet` is good enough for most workers and much cheaper than Opus. Reserve Opus for agents that need deep reasoning.
- **Minimal return contract.** The sub-agent should return a small, structured final message (e.g. a single OK/ERROR line). The parent's context cost should be measured in tens of tokens, not thousands.
- **Hard rules in the prompt.** Always include explicit "do not narrate progress," "do not ask clarifying questions," "do not modify files outside X" instructions. Without them, sub-agents tend to drift toward chatty behavior that defeats context isolation.

## Adding a new slash command

Slash commands live in `commands/`. They're entry points for the parent agent — typically they orchestrate sub-agents.

Conventions:

- Use `argument-hint:` in the frontmatter so users get a useful prompt
- Be explicit about parallelism — "dispatch in parallel batches of N" prevents sequential dispatch
- End with a "failure modes to avoid" section to keep the parent honest

## Style and substance

- **Plain text everywhere.** Skills, sub-agents, and commands are all markdown. Diff-friendly. Reviewable. Don't introduce binary tooling unless absolutely necessary.
- **No real client data.** Anything committed must be free of real fund names, real PPM excerpts, internal paths, or anything that could be tied to a specific client/manager. The repo's `.gitignore` excludes common patterns, but always do a manual check.
  ```bash
  # Quick sanity check before pushing
  git diff --cached | grep -iE "(belgrave|specific-fund-name)" && echo "SENSITIVE!" || echo "OK"
  ```
- **Small commits.** A new skill is one commit. A bugfix is one commit. Don't bundle.
- **Update docs alongside code.** New sub-agent? Update `README.md` and `docs/concepts.md` if a new concept appears.

## PR process

1. Fork the repo
2. Create a feature branch: `git checkout -b add-my-new-skill`
3. Make changes, test locally
4. Commit with a clear message: `Add fund-ddq-analyzer skill`
5. Push and open a PR
6. In the PR description, include:
   - What problem it solves
   - How you tested it
   - Sample output (sanitized)

## Questions

Open an issue on GitHub. For deeper questions about Claude Code itself (skills, sub-agents, hooks), the [official docs](https://docs.claude.com/en/docs/claude-code/overview) are the source of truth.
