# Example Output

`example-fund-ppm-analysis.docx` is a sanitized illustrative example of what the `analyzing-fund-ppm` skill produces when run on a real PPM. Open it to see the structure, formatting, and level of detail you can expect from your own output.

## What's in the example

The example covers all 10 standard sections the skill produces:

1. Fund Overview — domicile, structure, currency, strategy, leverage
2. Share Classes — full multi-class fee/redemption matrix
3. Subscription Terms — dealing day, deadline, valuation
4. Redemption Terms — notice, lockup, gates, payment, suspension, side pockets
5. Key Person Event — trigger, notification
6. Fee Structure — management, performance, hurdle, equalisation, expenses
7. Service Providers — IM, administrator, PB, custodian, auditor, legal
8. Key Personnel — CIO, directors
9. Special Provisions — side letters, FINRA, dislocated assets, wind-down
10. Regulatory Status — fund registration, IM licence, US/FATCA/CRS status

## ⚠ Everything in the example is fictional

- **Fund**: "Acme Asia Opportunities (USTE) Fund Ltd." — does not exist
- **Manager**: "Acme Capital Management Pte. Ltd." — does not exist
- **Key person**: "Alex Chen" — fictional name
- **Directors**: "Jane Doe", "Dr. Robert Smith" — fictional names
- **Service providers**: shown as generic categories ("[Big-Four firm]", "[Magic Circle firm]") rather than naming any specific firm — this is an illustrative example, not an endorsement

When the skill runs on your real PPM, every name, date, fee, and term in the output reflects **that PPM's actual contents**. The example just shows you the shape and quality of the output.

## How the example was generated

The example was produced by feeding a real (sanitized) PPM through the `analyzing-fund-ppm` skill and then manually scrubbing all identifying details. You can regenerate it from the source script in this folder if you want to tweak the layout or content.

## Why we ship an example

Tooling demos that don't show output are hard to evaluate. By including a sample, anyone considering using this repo can:

- See the visual quality of the .docx without running anything
- Decide if the section coverage matches what they need
- Spot any structural changes they'd want to make before adopting it
