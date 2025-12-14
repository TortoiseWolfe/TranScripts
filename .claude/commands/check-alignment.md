# Check Resume/LinkedIn Alignment

Compare resume and LinkedIn profile for consistency. Recruiters check both - discrepancies raise red flags.

## Input

Requires both:
1. **Resume:** Find in `Career/Resume_Edited/private/` (.html, .pdf, or .docx)
2. **LinkedIn:** Via MCP or CSV export in `Career/LinkedIn_Edited/private/`

If either is missing, prompt user to add the file or run the appropriate review command first.

## Alignment Checks

### 1. Position Titles
| Check | Issue Type |
|-------|------------|
| Exact title match | Should be identical |
| Company name spelling | Must match exactly |
| Missing positions | Flag if on one but not other |

### 2. Date Ranges
| Check | Issue Type |
|-------|------------|
| Start dates | Must match (month/year) |
| End dates | Must match or both say "Present" |
| Gaps | Flag unexplained gaps |

### 3. Metrics and Claims
| Check | Issue Type |
|-------|------------|
| Numbers | Same metrics on both (e.g., "12+ drafters") |
| Percentages | Consistent improvements claimed |
| Quantities | Same counts (components, tests, repos) |

### 4. Technical Skills
| Check | Issue Type |
|-------|------------|
| Core skills | Should appear on both |
| Skill order | Priority skills first on both |
| Missing skills | Flag if on resume but not LinkedIn (or vice versa) |

### 5. Projects
| Check | Issue Type |
|-------|------------|
| Project names | Should match |
| Tech stacks | Same technologies listed |
| Descriptions | Consistent framing |

### 6. Headlines
| Check | Issue Type |
|-------|------------|
| Role identity | Should align |
| Key skills mentioned | Should overlap |

## Output Format

```markdown
## Alignment Check: [Name]

### Summary
- **Alignment Score:** X/10
- **Critical Issues:** X
- **Minor Issues:** X

---

### Critical Issues (Fix Immediately)

#### Missing Positions
| Position | On Resume | On LinkedIn |
|----------|-----------|-------------|
| [Title @ Company] | Yes | **NO** |

#### Date Discrepancies
| Position | Resume Dates | LinkedIn Dates | Issue |
|----------|--------------|----------------|-------|
| [Title] | [dates] | [dates] | [mismatch] |

---

### Minor Issues

#### Title/Company Name Variations
| Resume | LinkedIn | Recommendation |
|--------|----------|----------------|
| [version] | [version] | Use: [recommended] |

#### Inconsistent Metrics
| Claim | Resume | LinkedIn |
|-------|--------|----------|
| [metric] | [value] | [value or missing] |

#### Skills Gaps
**On Resume but not LinkedIn:**
- [skill 1]
- [skill 2]

**On LinkedIn but not Resume:**
- [skill 1]

---

### Action Items

#### Do Today
1. [ ] [Critical fix 1]
2. [ ] [Critical fix 2]

#### Do This Week
3. [ ] [Minor fix 1]
4. [ ] [Minor fix 2]
```

## After Check

Offer to:
1. Generate ready-to-paste fixes with copy blocks
2. Save alignment report to `*_Edited/` directory
