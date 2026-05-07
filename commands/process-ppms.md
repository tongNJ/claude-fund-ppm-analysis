---
description: Batch-process a folder or list of PPM PDFs into Word reports using the ppm-extractor sub-agent.
argument-hint: <input_folder_or_file_list> <output_folder>
---

You are coordinating a batch of PPM analyses. Follow this workflow strictly.

## Step 1 — Resolve inputs

The user has provided: $ARGUMENTS

Determine:
- **PDF list**: If the first argument is a directory, glob it for `*.pdf` (non-recursive unless the user says otherwise). If it's a list of file paths (space- or comma-separated), use that list directly.
- **Output folder**: The second argument. Create it with `mkdir -p` if it doesn't exist. Use absolute paths throughout.

If you can't unambiguously identify either, ask the user once — do NOT guess.

Print a one-line plan: `Found N PPMs. Output → /abs/path. Dispatching in batches of K.` Use K=5 by default.

## Step 2 — Dispatch in parallel batches

For each batch of up to 5 PDFs, dispatch the `ppm-extractor` sub-agent **in parallel** (emit all Task calls in a single assistant turn). Each invocation's prompt should be:

```
pdf_path: <absolute path to PDF>
output_dir: <absolute output folder path>

Run the analyzing-fund-ppm skill on this single PPM and return the standard OK/ERROR line.
```

Do NOT include any other instructions — the sub-agent's system prompt already tells it what to do. Extra instructions just bloat the parent context.

## Step 3 — Collect results

Each sub-agent returns either:
- `OK | <fund_name> | <filepath> | <summary>`
- `ERROR | <pdf_path> | <reason>`

After each batch completes, append parsed rows to an in-memory list. Do NOT re-summarize the sub-agent outputs — they are already summaries.

## Step 4 — Continue until done

Dispatch the next batch of 5. Repeat until all PDFs are processed. If a batch has any ERROR results, continue with remaining PDFs — do not abort the whole run for one bad file.

## Step 5 — Final report

When all batches finish, present to the user:

1. A concise table with columns: Fund Name | Summary | Report (filepath as a clickable link if the terminal supports it)
2. A separate short list of any ERRORs with reasons
3. The output folder path so they can browse the .docx files
4. Total counts: `X succeeded, Y failed, Z total`

Do NOT re-read any of the generated .docx files. Do NOT re-summarize their contents. The sub-agents already produced everything; your job is just to present the index.

## Failure modes to avoid

- **Sequential dispatch** — emitting one Task call, waiting, emitting the next. This defeats the whole point. Always parallel within a batch.
- **Re-instructing the sub-agent** — pasting skill content or extraction tips into the Task prompt. The sub-agent already knows; it has its own system prompt.
- **Reading sub-agent intermediate output** — you only see their final OK/ERROR line. There is no intermediate output to read.
- **Filling your context with extraction text** — if you find yourself running `pdftotext` or reading PPM PDFs in the main loop, stop. That's the sub-agent's job, not yours.
