# Installation

This guide covers full installation of `claude-fund-research` on macOS or Linux. For Windows, use WSL2 — Claude Code's skill/sub-agent loading expects POSIX paths.

## 1. System prerequisites

You'll need:

| Tool | Why | Install |
|---|---|---|
| Claude Code | The harness | [docs.claude.com/claude-code/setup](https://docs.claude.com/en/docs/claude-code/setup) |
| Node.js 18+ | Generates .docx output | `brew install node` (macOS) or use [nvm](https://github.com/nvm-sh/nvm) |
| Python 3.9+ | Runs the PPM extraction script | Usually pre-installed; otherwise `brew install python` |
| `pdftotext` | Targeted PDF text extraction | `brew install poppler` (macOS) / `apt install poppler-utils` (Debian/Ubuntu) |
| `pdfplumber` (Python) | Table-aware PDF parsing | `pip install pdfplumber` |
| `docx` (Node.js) | Word document generation | Installed automatically when the skill first runs |

Verify everything's in place:

```bash
claude --version
node --version       # should be ≥ 18
python3 --version    # should be ≥ 3.9
pdftotext -v         # should print version info
python3 -c "import pdfplumber; print(pdfplumber.__version__)"
```

If any of those fail, fix them before continuing.

## 2. Clone the repo

Pick a permanent home for the repo. I recommend `~/code/` or `~/projects/`. The location doesn't matter — it just needs to be somewhere stable because the installer will create symlinks pointing here.

```bash
mkdir -p ~/code
cd ~/code
git clone https://github.com/<your-username>/claude-fund-research.git
cd claude-fund-research
```

## 3. Run the installer

```bash
./install.sh
```

This creates symlinks from `~/.claude/` into the repo:

```
~/.claude/skills/analyzing-fund-ppm   →  ~/code/claude-fund-research/skills/analyzing-fund-ppm
~/.claude/agents/ppm-extractor.md     →  ~/code/claude-fund-research/sub-agents/ppm-extractor/ppm-extractor.md
~/.claude/commands/process-ppms.md    →  ~/code/claude-fund-research/commands/process-ppms.md
```

Symlinks (not copies) mean: when you `git pull` to get updates, your installed version updates automatically. When you make local edits to test changes, they're reflected immediately. No re-running the installer.

The installer also prints next steps for permissions setup — see [`permissions.md`](permissions.md) for the full story.

## 4. Verify

Open a terminal in any directory and run:

```bash
claude
```

Inside Claude Code:

1. Type `/` and look for `process-ppms` in the autocomplete list. If it appears, the slash command is loaded.
2. Type `Use the ppm-extractor sub-agent on /tmp/nonexistent.pdf, output to /tmp` — Claude should recognize the sub-agent and either dispatch it (it'll return ERROR because the path doesn't exist, which is fine) or ask why the file doesn't exist. Either way, the sub-agent is loaded.

If neither happens, troubleshoot:

```bash
ls -la ~/.claude/agents/ppm-extractor.md
ls -la ~/.claude/commands/process-ppms.md
ls -la ~/.claude/skills/analyzing-fund-ppm/
```

All three should resolve to files in your cloned repo. If they don't, re-run `./install.sh`.

## 5. Configure permissions

On first run, Claude Code will prompt for permission every time the sub-agent calls `pdftotext`, `python3`, etc. To pre-approve the tools the workflow needs, see [`permissions.md`](permissions.md). This is a one-time setup that makes batch runs flow uninterrupted.

## 6. Test on a real PPM

Drop one or two PPM PDFs into a test folder and run:

```bash
mkdir -p ~/ppm-test/in ~/ppm-test/out
# put 2-3 PDFs into ~/ppm-test/in
claude
```

Inside Claude Code:

```
/process-ppms ~/ppm-test/in ~/ppm-test/out
```

You should see batches dispatch in parallel and `OK | FundName | /path/to/.docx | summary` lines come back. Final reports land in `~/ppm-test/out/`.

If something fails, check the error message in the OK/ERROR line. Common issues:

- **"PDF unreadable"** — PDF is encrypted or scanned without OCR. Run `ocrmypdf input.pdf output.pdf` first.
- **"Critical fields missing"** — the PPM is unusually formatted; the skill's TOC-guided extraction couldn't find the right sections. Process that one manually.
- **All ERRORs** — check that `/mnt/skills/user/analyzing-fund-ppm/SKILL.md` resolves correctly. The path in the sub-agent points to where Claude Code expects skills to live.

## Updating

```bash
cd ~/code/claude-fund-research
git pull
```

Because of the symlinks, that's it. No re-install needed.

## Uninstalling

```bash
cd ~/code/claude-fund-research
./install.sh --uninstall
```

This removes the symlinks. The repo itself is untouched — delete the cloned folder if you want it fully gone.
