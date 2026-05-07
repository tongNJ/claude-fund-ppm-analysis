# Example outputs

This folder will hold sanitized example outputs from the `analyzing-fund-ppm` skill, so users can see what "good output" looks like before running their own.

## How to add examples

1. Run the skill on a real PPM
2. Open the resulting `.docx`
3. Replace all real fund-identifying details with fictional ones:
   - Fund name → e.g. "Acme Asia Opportunities Fund Ltd."
   - Manager name → e.g. "Acme Capital Management Ltd."
   - Director names → fictional
   - Service provider names → keep generic categories ("the Administrator") or use well-known industry names that are not tied to a specific fund (Citco, MUFG, etc.)
   - Office addresses → fictional Cayman/BVI/Delaware addresses
   - Specific AUM figures, fee rates that are unique to a real fund → adjust
4. Save the sanitized version here as `example-fund-report.docx`
5. Verify by reading the doc once more before committing

## Why bother?

Examples massively improve the experience for new users — they can see the output style before running anything. They also help future contributors understand the target format when extending the skill.
