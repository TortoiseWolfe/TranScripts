# Review Resume

Analyze a resume against the career coaching frameworks to identify improvements.

## Input

Find the most recent resume file in `Career/Resume_Edited/private/`:
- Supported formats: `.html`, `.pdf`, `.docx`
- If multiple files exist, use the most recently modified

## Framework Reference

Apply the frameworks from `Career/Resume_Edited/RESUME_SYSTEM_PROMPT.md`:

### 1. 6-Second Scan Check
- [ ] Header: Name, headline, contact info, links (hyperlinked)
- [ ] Headline clarity: Role + key skills
- [ ] Summary: 4-line formula compliance
- [ ] Visual hierarchy: Top third impact

### 2. Bullet Analysis (Action + Task + Result)
For each position, evaluate every bullet:
- Strong verb? (not "worked", "helped", "responsible")
- Shows outcome/impact? (not just task description)
- Under 2 lines?

### 3. Summary 4-Line Formula
| Line | Content |
|------|---------|
| Line 1 | Who you are and your main focus |
| Line 2 | What you do well, including tools/skills |
| Line 3 | Proof of impact or contribution |
| Line 4-5 | What you want next and how you want to add value |

### 4. ATS/Keyword Optimization
- Technical skills prominent?
- Keywords match target roles?
- No keyword dumping?

### 5. Format Check
- One page for early career?
- PDF-ready?
- No photos, graduation years, complex graphics?
- Links hyperlinked (not spelled out)?

## Output Format

```markdown
## Resume Review: [Name]

### Overall Assessment
- **Score:** X/10
- **ATS Readiness:** X/10
- **Strengths:** [what's working]
- **Priority Fixes:** [top 3 changes needed]

---

### Section-by-Section Analysis

#### Header
**Current:** [their header]
**Issues:** [problems identified]
**Suggested:** [improved version]

#### Summary
**Current:** [their summary]
**Issues:** [problems - check 4-line formula]
**Rewrite:** [improved summary]

#### Experience Bullets
**Position: [Job Title] at [Company]**

| # | Original | Issues | Rewrite |
|---|----------|--------|---------|
| 1 | "..." | [issue] | "..." |

[Repeat for each position]

#### Skills Section
**Current:** [their skills]
**Missing Keywords:** [based on target role]
**Suggested Order:** [prioritized list]

#### Projects
[Evaluate each project bullet]

---

### Quick Wins (5-Minute Fixes)
- [Simple fix 1]
- [Simple fix 2]

### Keywords to Add
- [ ] [keyword 1] - add to: [section]
- [ ] [keyword 2] - add to: [section]
```

## After Review

Offer to:
1. Generate ready-to-paste rewrites with copy blocks
2. Run `/check-alignment` to compare with LinkedIn
3. Run full `/job-search-prep` workflow
