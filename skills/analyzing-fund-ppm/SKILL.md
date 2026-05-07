---
name: analyzing-fund-ppm
description: Analyzes Private Placement Memorandum (PPM) documents and generates professional Word reports extracting key fund terms, fee structures, redemption terms, service providers, and regulatory status. Use this skill when a user uploads a PPM or fund offering document and wants a structured analysis report.
---

# PPM Analysis Skill

## Overview

This skill analyzes Private Placement Memorandum (PPM) documents for hedge funds and investment vehicles, extracting key information and generating a **concise, professional Word document report (approximately 5 pages recommended)**. For funds with complex structures, multiple share classes, or unusual provisions, the report may be longer. The key principle is keeping content **short and precise**. It is designed to help investment professionals quickly assess fund terms from lengthy legal documents.

## When to Use This Skill

Trigger this skill when:
- User uploads a PPM, Private Offering Memorandum, or similar fund document
- User asks to "analyze a PPM" or "extract fund terms"
- User wants a summary of subscription/redemption terms, fees, or service providers from a fund document
- User requests a "fund terms report" or "PPM summary"

## Critical Output Requirements

**TARGET LENGTH: Approximately 5 pages recommended**

The report should be concise and scannable. For complex fund structures with multiple share classes, side pockets, or unusual provisions, the report may exceed 5 pages - this is acceptable. The key principle is to keep content **short and precise** while capturing all material terms. Follow these guidelines:

### Brevity Rules
- **Cell values must be SHORT** - use phrases, not sentences
- **No biographical details** for personnel - names and roles only
- **No explanatory text** between sections
- **Use abbreviations** where standard: p.a., HWM, NAV, FY, IM, IA
- **Omit obvious context** - readers are investment professionals
- **One line per cell** where possible

### What to EXCLUDE
- Detailed investment approach descriptions
- Personnel backgrounds or experience
- Full addresses (city/country sufficient for service providers)
- Tax analysis or PFIC details
- Extensive regulatory explanations
- Separate "Other Expenses" section

## Report Structure (9 Sections Only)

### 1. Fund Overview
Simple two-column table with exactly these fields:
| Field | Example Value Format |
|-------|---------------------|
| Fund Name | AppleBanana Asia Fund |
| Domicile | Cayman Islands (exempted company) |
| Incorporation Date | 16 July 2014 |
| Functional Currency | USD |
| Investment Objective | Long-term capital growth; absolute returns (not benchmark relative) |
| Geographic Focus | Asia, primarily Malaysia and ASEAN |

### 2. Share Classes
**Use horizontal comparison table format:**
| Class | Availability | Par Value | Mgmt Fee | Perf Fee | Lock-up |
|-------|-------------|-----------|----------|----------|---------|
| Class A | All investors | US$0.001 | 1.5% p.a. | 15% (HWM) | None |

- Keep availability descriptions to 2-3 words
- Use "None" not "Not applicable"
- Always include HWM notation with performance fee

### 3. Subscription Terms
Two-column table, 6 rows maximum:
| Term | Details |
|------|---------|
| Minimum Initial Investment | US$200,000 |
| Reduced Minimum | US$50,000 (for sub-accounts of existing money managers) |
| Minimum Subsequent Investment | US$5,000 |
| Subscription Charge | Up to 3% (may be waived) |
| Dealing Day | First Business Day of each calendar month |
| Subscription Deadline | 5:30 PM Singapore time on Valuation Day preceding Dealing Day |

### 4. Redemption Terms
**Use horizontal comparison table if terms differ by share class:**
| Term | Class A | Class B | Class C |
|------|---------|---------|---------|
| Redemption Day | 1st Business Day of Quarter | Same | Same (after lock-up) |
| Notice Period | 60 days | 60 days | 60 days |
| Redemption Charge | 2% if < 12 months | None | None |
| Minimum Redemption | US$50,000 | US$50,000 | US$50,000 |
| Lock-up Period | None | None | 3 years |
| Gate | 10% of NAV per Redemption Day | Same | Same |
| Payment Timeline | 15 Business Days | Same | Same |

- Use "Same" to avoid repetition
- Keep charge descriptions brief

### 5. Fee Structure
Horizontal table format:
| Fee Type | Rate | Applicable To | Payment |
|----------|------|---------------|---------|
| Management Fee | 1.5% p.a. of NAV | Class A & C | Monthly in arrears |
| Performance Fee | 15% above HWM | Class A & C | Annually (90% within 30 days of FY end; 10% after audit) |
| High Water Mark | Yes | Class A & C | Per-share basis |

### 6. Service Providers
Three-column table - **entity names and location only, no addresses:**
| Role | Entity | Location |
|------|--------|----------|
| Investment Manager | Pangolin Investment Management Pte. Ltd. | Singapore |
| Administrator | Acclime SG Fund Services Pte Ltd | Singapore |
| Custodian | Deutsche Bank AG, Singapore Branch | Singapore |
| Auditor | RSM Cayman Limited | Cayman Islands |
| Cayman Counsel | Walkers | Cayman Islands |
| US Counsel | Lowenstein Sandler LLC | New York |
| Singapore Counsel | Chris Chong & C T Ho LLP | Singapore |

### 7. Key Personnel
**Names and roles ONLY - no biographical information:**
| Name | Role |
|------|------|
| James Hay | Director of Fund, Director of IM & IA, Management Shareholder |
| Gerald Ambrose | Director |
| Fiona Somerville | Director |

### 8. Special Provisions
Brief bullet-point style for key triggers only. Example format:

**Key Person Event**
If ALL of the following Key Persons leave the Fund and/or Affiliated Entities, Class C Shares automatically convert to Class A Shares:
- Person 1
- Person 2
- Person 3

**Asset Threshold Trigger**
If total fund assets fall below US$[X] million, Class C Shares automatically convert to Class A Shares on the next Dealing Day.

### 9. Regulatory Status
Three-column table:
| Jurisdiction | Status |
|--------------|--------|
| Cayman Islands | Registered as regulated mutual fund with CIMA |
| Singapore | Entered as restricted foreign scheme with MAS |
| United States | Not registered under Investment Company Act (Section 3(c)(1) exemption - max 100 US beneficial owners) |

## Output Format Specifications

### Document Structure
1. **Header** (on each page): "PPM Analysis Report" - right aligned, gray text
2. **Footer** (on each page): "Page X of Y" - centered
3. **Title block** (page 1 only, no separate title page):
   - "PPM Analysis Report" (main title)
   - Fund name
   - "As Updated on [PPM Date]"
4. **9 numbered sections** with tables
5. **Disclaimer** at end

### Formatting Specifications
- **Page size**: US Letter (8.5" x 11")
- **Margins**: 1 inch all sides
- **Font**: Arial throughout
- **Body text**: 11pt
- **Section headings**: 12pt bold, numbered (1. Fund Overview, 2. Share Classes, etc.)
- **Table header row**: Dark blue background (#1F4E79), white text, bold
- **Table label cells**: Light gray background (#F2F2F2), bold text
- **Table borders**: Light gray (#CCCCCC), thin (1pt)
- **Cell padding**: Minimal (80 DXA top/bottom, 120 DXA left/right)

### Table Width Rules
- All tables: 100% page width
- Two-column tables: 35% / 65% split
- Comparison tables: Equal column widths
- Service providers: 25% / 50% / 25% split

## Disclaimer Text (Required)

Always include at end of report:

> **DISCLAIMER**
>
> This report is a summary extraction of key terms from the Private Placement Memorandum dated [DATE]. It is intended for informational purposes only and does not constitute investment advice. Investors should read the full PPM and consult with their own legal, tax, and financial advisors before making any investment decisions. This summary may not capture all material terms and conditions.
>
> Report generated: [CURRENT_DATE]

## Implementation Notes

Use the `docx` npm package to generate the Word document. Follow the docx skill guidelines for:
- Table formatting with dual widths (columnWidths + cell width)
- ShadingType.CLEAR for cell backgrounds
- Proper page margins and sizing
- Headers and footers with page numbers

## Quality Checklist

Before generating output, verify:
- [ ] Content is concise (approximately 5 pages for standard funds; more pages acceptable for complex structures)
- [ ] No biographical details for personnel
- [ ] No full addresses for service providers
- [ ] All tables use specified column formats
- [ ] Cell values are phrases, not sentences
- [ ] Standard abbreviations used throughout
- [ ] Exactly 9 sections (no additional sections)
- [ ] Disclaimer included with correct dates

## Notes

- If information is not found in the PPM, note "Not specified"
- Pay attention to different terms by share class - use comparison tables
- Look for supplements or amendments that may modify base terms
- Currency should be noted where amounts are specified
- Dates format: DD Month YYYY
