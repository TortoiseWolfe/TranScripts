# Job Search Prep

Complete job search preparation workflow: analyze resume, analyze LinkedIn, check alignment, and generate ready-to-use fixes.

## Prerequisites

Place files in the appropriate private directories:
- **Resume:** `Career/Resume_Edited/private/` (.html, .pdf, or .docx)
- **LinkedIn:** Either:
  - MCP server configured with valid `li_at` cookie, OR
  - CSV export in `Career/LinkedIn_Edited/private/`

## Workflow

### Phase 1: Gather Input

1. **Ask target role type:**
   - Full Stack Developer
   - Frontend Developer
   - Backend / C#/.NET
   - Keep it broad (optimize for multiple)

2. **Find resume** in `Career/Resume_Edited/private/`
3. **Get LinkedIn profile** via MCP or CSV export

### Phase 2: Resume Review

Apply frameworks from `Career/Resume_Edited/RESUME_SYSTEM_PROMPT.md`:
- 6-Second Scan Check
- Bullet Analysis (Action + Task + Result)
- Summary 4-Line Formula
- ATS/Keyword Optimization
- Format Check

### Phase 3: LinkedIn Review

Apply frameworks from `Career/LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md`:
- Headline Formula
- About Section 5-Part Structure
- Experience (Skills, not duties)
- Skills Section (30-50 target)
- All-Star Profile Checklist

### Phase 4: Alignment Check

Compare resume ↔ LinkedIn:
- Position titles match
- Date ranges match
- Metrics/claims consistent
- Technical skills aligned
- Projects described similarly

### Phase 5: Generate Fixes File

Create a dated fixes file with ready-to-paste copy blocks:

**Output location:** `Career/LinkedIn_Edited/[name]_fixes_[YYYY-MM-DD].md`

**Format:**
```markdown
# LinkedIn & Resume Fixes - Ready to Copy

Generated: [date]

---

## 1. [Fix Category]

### [Specific Fix]
**Location:** [where to apply]

\`\`\`
[Ready to paste content]
\`\`\`

---

[Repeat for each fix]

---

## Checklist

- [ ] [Action item 1]
- [ ] [Action item 2]
```

## Output Summary

After running, provide:

1. **Scores:**
   - Resume: X/10
   - LinkedIn: X/10
   - Alignment: X/10

2. **Critical Issues:** (fix today)
   - [List]

3. **Priority Improvements:** (fix this week)
   - [List]

4. **Fixes File Location:**
   - Path to generated file with copy blocks

## Example Output Reference

See `Career/LinkedIn_Edited/linkedin_resume_fixes_2024-12-14.md` for example output format.

## Individual Commands

This workflow combines:
- `/review-resume` - Resume analysis only
- `/review-linkedin` - LinkedIn analysis only
- `/check-alignment` - Alignment check only

Run individual commands for focused analysis.
