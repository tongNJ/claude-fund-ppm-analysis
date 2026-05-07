# Permissions

Claude Code asks for permission before running shell commands or writing files. For interactive use, that's fine — you confirm each one. For batch runs (e.g., processing 100 PPMs through the `ppm-extractor` sub-agent), the prompts pile up and break flow. This guide explains how to pre-approve the tools the workflow needs.

## The mental model

Claude Code has two layers of restriction:

1. **The sub-agent's tool allowlist** (in its YAML frontmatter, e.g. `tools: Read, Bash, Write, Glob`). This says what the sub-agent is *capable of* calling.
2. **Your permission rules** (in `~/.claude/settings.json` or project-local). This says what Claude Code is *allowed to execute* without asking you.

Both layers must say "yes" for a tool call to go through silently. The YAML restricts capability; the settings file grants consent.

## The recommended setup

Drop this in `~/.claude/settings.json` (create the file if it doesn't exist):

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Glob",
      "Bash(pdftotext:*)",
      "Bash(python3:*)",
      "Bash(node:*)",
      "Bash(npm:*)",
      "Bash(mkdir:*)",
      "Bash(rm:*)",
      "Bash(cat:*)",
      "Bash(ls:*)"
    ]
  }
}
```

This pre-approves exactly the tools the PPM workflow uses — nothing more. The `Bash(command:*)` syntax means "any invocation of this binary, with any arguments." Claude Code can run `pdftotext -layout file.pdf out.txt` without asking, but cannot run `curl https://...` because `curl` isn't on the list.

A copy of this file lives in [`settings/settings.example.json`](../settings/settings.example.json) at the repo root for reference.

## How to apply it

The first time you encounter a permission prompt, the easiest thing is to choose **"Always allow"** rather than just "Allow." Claude Code saves the rule to `.claude/settings.local.json` in the current project. After 5-6 of these, the entire workflow will run uninterrupted in that project.

For a setup that applies everywhere (so you don't repeat it for every new project folder), edit `~/.claude/settings.json` directly. The file is plain JSON. After saving, restart Claude Code for the changes to load.

You can also manage rules interactively from inside Claude Code with:

```
/permissions
```

That opens a UI where you can view current allow/deny rules and edit them.

## Project-scoped overrides

If a particular project needs different rules (e.g., one project handles untrusted documents and you want stricter rules there), create `.claude/settings.local.json` in the project root. It overrides the user-level settings for that project only.

```json
{
  "permissions": {
    "allow": ["Read", "Glob"],
    "deny": ["Bash(rm:*)", "Write"]
  }
}
```

`.gitignore` already excludes `settings.local.json` so personal overrides don't leak into the repo.

## The escape hatch (use carefully)

If you just want zero friction for a one-off batch run:

```bash
claude --dangerously-skip-permissions
```

This disables all permission prompts for the session. The flag's name is honest about what it does: Claude can run *any* command without asking. Don't use it in directories with sensitive files or while processing untrusted content.

For your PPM workflow it's actually low-risk because the sub-agent's YAML allowlist already restricts what it can call (`Read, Bash, Write, Glob` only — no networking, no Edit, no MCP tools). But it's still safer to use the explicit allowlist above.

## What to avoid

- **Adding broad rules like `Bash(*:*)`.** That defeats the point of permissions entirely. Stick to specific binaries.
- **Adding `Bash(curl:*)` or `Bash(wget:*)` to a sub-agent's allowed commands.** The sub-agent shouldn't need network access; if a malicious PPM somehow injected an instruction to exfiltrate data, broad networking permission is the gap that lets it succeed.
- **Committing `settings.local.json` to git.** It can contain machine-specific paths or rules you don't intend to share. The repo's `.gitignore` already excludes it.

## Verifying it worked

Run a 2-PPM batch:

```
/process-ppms ~/ppm-test/in ~/ppm-test/out
```

If you see permission prompts during the run, note which tool is being requested and add it to the allowlist. The most common ones the PPM workflow needs are listed at the top of this doc. After one round of pre-approval, subsequent batches should be silent.
