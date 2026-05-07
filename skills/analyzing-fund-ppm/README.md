# Skill: analyzing-fund-ppm

Analyzes a Private Placement Memorandum (PPM) PDF and produces a polished Word report covering fund terms, fee structure, redemption terms, service providers, and regulatory status.

## Files in this folder

- **`SKILL.md`** — the skill definition. Read by Claude Code before any task that mentions PPMs, offering memoranda, or fund terms extraction.
- **`scripts/extract_ppm_smart.py`** — TOC-guided extraction script. Parses the PPM's table of contents, then targets specific sections (fees, redemptions, etc.) rather than dumping the whole document.
- **`examples/`** — sanitized example outputs from fictional funds, so you can see what "good output" looks like.

## ⚠️ Drop in your real SKILL.md

This folder is structured to receive your existing `analyzing-fund-ppm` skill content. If you have a working `SKILL.md` from your `~/.claude/skills/` or similar location, copy it here:

```bash
cp ~/.claude/skills/analyzing-fund-ppm/SKILL.md \
   ~/code/claude-fund-research/skills/analyzing-fund-ppm/SKILL.md

cp ~/.claude/skills/analyzing-fund-ppm/scripts/extract_ppm_smart.py \
   ~/code/claude-fund-research/skills/analyzing-fund-ppm/scripts/
```

**Before committing to git, sanitize the SKILL.md:**

1. Replace any real fund names with fictional ones (e.g. "Acme Asia Opportunities Fund").
2. Remove any client-specific paths, internal URLs, or credentials.
3. Strip example PPM excerpts that came from real funds.

Run a quick check before pushing:

```bash
grep -iE "(belgrave|fenghe|wt|tal|zennor|greenwoods)" SKILL.md
# should return nothing
```

The placeholder `SKILL.md` currently in this folder is a minimal stub — it tells you where to put your real one. Replace it before installing.

## When this skill triggers

- User uploads a PPM or fund offering document
- User mentions "analyze a PPM", "extract fund terms", "PPM summary", "offering memorandum", "fund terms report"
- The `ppm-extractor` sub-agent invokes it as part of batch processing

## What it produces

A `.docx` Word document with structured sections:

- Executive summary (fund overview, strategy, base terms)
- Fund structure (domicile, vehicle, master-feeder, classes)
- Fee structure (management fee, performance fee, hurdle, high-water mark, equalization)
- Subscription terms (minimum, frequency, notice)
- Redemption terms (frequency, notice period, lockup, gates, side pockets, suspensions)
- Service providers (administrator, auditor, prime broker, custodian, legal counsel)
- Key persons (PMs, key person clauses)
- Regulatory status (registration, jurisdictions)
- Risk factors (selected highlights)
- Notable provisions (anything unusual flagged for analyst attention)
