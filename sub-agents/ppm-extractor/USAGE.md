# PPM-Extractor — Usage Reference

A practical cheat sheet for invoking the `ppm-extractor` sub-agent.

---

## What this sub-agent does

`ppm-extractor` is a single-purpose worker that processes **one** PPM PDF and produces **one** Word report (.docx). It runs the `analyzing-fund-ppm` skill end-to-end inside its own isolated context window, so the parent conversation never sees extraction text, validation chatter, or docx code — only a one-line result per PPM.

Companion: the `/process-ppms` slash command coordinates batches of these sub-agents in parallel.

## Where it runs

**Claude Code only.** Sub-agents are a Claude Code feature — they're loaded from `~/.claude/agents/` (user-scoped) or `.claude/agents/` (project-scoped) and are not available in claude.ai chat or Cowork.

## How batching works

You feed in **all** the PPMs at once. The parent agent loops through them and runs **5 sub-agents in parallel** at a time, automatically cycling through until every PDF is done.

```
100 PDFs in folder
       │
       ▼
   Parent agent (you talking to it)
       │
       ├── Batch 1: dispatches sub-agents 1-5 in parallel
       │   (waits for all 5 to finish)
       ├── Batch 2: dispatches sub-agents 6-10 in parallel
       │   ...
       └── Batch 20: dispatches sub-agents 96-100
           │
           ▼
       Final summary table: 100 rows
```

You don't feed PPMs in groups of 5. You feed them all in once. The "5" is just how many can run *simultaneously*, not how many you have to feed in per round.

To change parallelism, edit the `K=5 by default` line in `commands/process-ppms.md`. Lower K is gentler on rate limits; higher K is faster but riskier.

---

## Three ways to invoke

### Option A — Slash command (recommended for batches)

```
/process-ppms <input_folder_or_pdf_list> <output_folder>
```

Examples:

```
/process-ppms ~/funds/ppms-2026-q1 ~/funds/ppm-reports-2026-q1
```

```
/process-ppms ~/funds/zennor.pdf,~/funds/wt.pdf,~/funds/fenghe.pdf ~/funds/ppm-reports
```

Use this whenever you have ≥2 PPMs.

### Option B — Plain English (auto-routing)

```
Process every PPM in ~/funds/ppms-2026-q1 and save the reports to ~/funds/ppm-reports-2026-q1.
```

```
I have 47 fund offering memorandums in ~/asia-trip-prep. Generate analysis reports for all of them in ~/asia-trip-prep/reports.
```

The sub-agent's `description` field includes triggers like "process", "batch analyze", "extract terms from", "generate reports for" — Claude Code routes automatically.

### Option C — Single PPM (one-off)

```
Use the ppm-extractor sub-agent on ~/funds/zennor-asia.pdf, output to ~/funds/ppm-reports.
```

---

## What good prompts look like

A good prompt has three things: **verb + input + output**.

| Element | Examples |
|---|---|
| Verb | "Process", "Analyze", "Generate reports for", "Run ppm-extractor on", "Batch analyze" |
| Input | Absolute path, `~/...` path, folder, or comma/space-separated list of PDFs |
| Output | Absolute or `~/...` path to destination folder |

### Good (paste-ready)

```
Process all PPMs in ~/funds/incoming and save reports to ~/funds/reports.
```

```
Run the ppm-extractor on ~/asia-trip/ppms (all 12 of them) and put the .docx files in ~/asia-trip/ppm-reports.
```

```
Batch analyze these PPMs: ~/funds/zennor.pdf, ~/funds/wt.pdf, ~/funds/fenghe.pdf, ~/funds/seraya.pdf. Output → ~/funds/reports.
```

```
/process-ppms ~/Downloads/q1-ppms ~/research/ppm-reports/2026-Q1
```

### Bad

```
❌ "Analyze my PPMs."
   — No paths. The parent will have to ask you twice.

❌ "Run the ppm-extractor on ~/funds/ppms but skip the ones from 2024 and pay extra attention to fee rates."
   — Don't customize per-call. The skill already handles this. Custom instructions either get ignored or bloat sub-agent context.

❌ "Process the PPMs and tell me which one has the lowest management fee."
   — Mixing batch processing with cross-fund analysis. Run the batch first, then ask comparison questions in a separate turn.

❌ "Process ppms/ folder."
   — Relative path. Always use absolute or ~/... paths.
```

---

## Pre-flight checklist (before launching a big batch)

1. **PPMs are PDFs.** Scanned PDFs without OCR will fail — run `ocrmypdf input.pdf output.pdf` first.
2. **Filenames are sane.** Avoid quotes, backticks, non-printable characters in filenames.
3. **Output folder is writable.** Slash command runs `mkdir -p`, but pick somewhere with disk space. Reports are ~50-200 KB each.
4. **Test on 2-3 first.** Always do a small test run before launching a 100-PPM batch:
   ```
   /process-ppms ~/funds/test-3 ~/funds/test-3-reports
   ```
5. **Permissions are pre-approved.** See [`docs/permissions.md`](../../docs/permissions.md). Otherwise you'll get prompted every time the sub-agent calls `pdftotext` or `python3`.
6. **Don't close the terminal.** Once the batch starts, leave Claude Code running.

---

## What you'll see during a run

```
Found 47 PPMs. Output → /Users/ni/asia-trip/ppm-reports. Dispatching in batches of 5.

[batch 1: 5 sub-agents in parallel]
  OK | Acme Asia Opportunities Fund Ltd | /Users/ni/asia-trip/ppm-reports/Acme_Asia_Opportunities_Fund_PPM_Analysis.docx | Cayman-domiciled Asia long/short equity; 2%/20% with 1yr soft lockup; monthly redemptions with 30-day notice.
  OK | Beacon Greater China Fund | ...
  OK | Cobalt Pan-Asia Macro Fund | ...
  OK | Delta Japan Equity Fund | ...
  ERROR | /Users/ni/asia-trip/ppms/scanned-old-fund.pdf | PDF unreadable / encrypted

[batch 2: 5 sub-agents in parallel]
  ...

[final summary]
46 succeeded, 1 failed, 47 total.
```

Each `OK` line is ~30 tokens in the parent context. 100 PPMs ≈ 3,000 tokens.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Slash command not recognized | File not installed or wrong path | `ls ~/.claude/commands/process-ppms.md` |
| Sub-agent not auto-routing on plain English | Description not loaded | Restart Claude Code; `ls ~/.claude/agents/ppm-extractor.md` |
| Sub-agents dispatching sequentially | Parent forgot parallel Task calls | Add to prompt: "Dispatch the sub-agents in parallel batches of 5." |
| All ERRORs | Wrong skill path | Verify `~/.claude/skills/analyzing-fund-ppm/SKILL.md` exists |
| Permission prompts every PPM | Settings not configured | See [`docs/permissions.md`](../../docs/permissions.md) |
| Some "PDF unreadable" errors | Scanned/encrypted PDFs | OCR them separately, or skip and process manually |
| Reports show "Not specified" for fees | Extraction missed the right section | Re-run that PPM with Option C; if it still fails, the skill needs a tweak |
| Very slow (>5 min per PPM) | Huge document or rate-limited | Lower K to 3 in the slash command |

---

## When NOT to use this sub-agent

- **One-off analysis of a single PPM in claude.ai chat.** Use the skill directly there — sub-agents don't exist in chat.
- **Cross-fund comparison ("which fund has the lowest fee?").** Run the batch first, then ask comparison questions in a follow-up turn.
- **Non-PPM documents.** Fact sheets, monthly newsletters, DDQs have different structures — use the appropriate skill instead.
- **When you need structured JSON.** Current sub-agent emits .docx + summary only. JSON output is on the roadmap.
