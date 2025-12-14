# Review LinkedIn Profile

Analyze a LinkedIn profile against the career coaching frameworks to identify improvements.

## Input (in order of preference)

1. **MCP Server:** Fetch live profile via `mcp__linkedin__get_person_profile`
   - Requires LinkedIn username (e.g., "pohlner")
   - If MCP fails (cookie expired), fall back to CSV export

2. **CSV Export:** Find in `Career/LinkedIn_Edited/private/`
   - Look for `*LinkedInDataExport*.zip` files
   - Extract and read key CSVs: Profile.csv, Positions.csv, Skills.csv, etc.

## Framework Reference

Apply the frameworks from `Career/LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md`:

### 1. Headline Formula (Highest SEO Weight)
```
Role/Identity + Skills & Tools + Value Proposition
```
- 50-100 characters optimal
- No "aspiring", "junior", "looking for"
- Include 2-3 technical skills

### 2. About Section 5-Part Structure
| Part | Content |
|------|---------|
| Line 1 | Who you are + What you do + Direction |
| Lines 2-4 | Technologies, problems you solve, recent projects, personality |
| Line 5 | Call to action (optional) |

**Words to Flag:** "Seasoned", "Junior", "Aspiring", "Results-driven", "Team-oriented"

### 3. Experience Section
- **Skills, not duties** (duties go on resume, skills are searchable on LinkedIn)
- Each entry should list relevant skills at the top
- Project descriptions: What + Tools + Impact

### 4. Skills Section
- Target: 30-50 skills
- Top 10 most important first
- Include both hard skills (get interviews) and soft skills (pass interviews)

### 5. All-Star Profile Checklist
- [ ] Photo: Professional headshot
- [ ] Banner: Custom (not default)
- [ ] Headline: Keyword-optimized
- [ ] About: 2-4 paragraphs
- [ ] Experience: At least 2 positions with skills
- [ ] Education: Listed
- [ ] Skills: 30-50, prioritized
- [ ] Recommendations: At least 1-2
- [ ] Custom URL
- [ ] Contact info: Email, portfolio/GitHub
- [ ] Activity: Recent posts/engagement

## Output Format

```markdown
## LinkedIn Profile Review: [Name]

### Overall Score: X/10

### Priority Improvements (Do First)
1. [Highest impact change]
2. [Second highest]
3. [Third]

---

### Section-by-Section Analysis

#### Headline
**Current:** [their headline]
**Issues:** [what's wrong]
**Suggested Rewrite:**
> [improved version following formula]

#### About Section
**Current:** [summary or "Missing"]
**Issues:** [what's wrong - check 5-part structure]
**Suggested Rewrite:**
> [improved version]

#### Experience
[For each position:]
**[Title] at [Company]**
- Skills listed? [Yes/No]
- Duties vs Skills? [Assessment]
- Suggested rewrite: [if needed]

#### Skills
**Current Count:** X
**Missing High-Value Skills:** [list]
**Suggested Additions:** [prioritized list]

#### Recommendations
**Current:** X recommendations
**Quality:** [Assessment of recency and relevance]
**Suggestion:** [who to ask, how to ask]

#### Completeness Checklist
[Run through All-Star checklist, note gaps]

---

### Quick Wins (5-Minute Fixes)
- [Simple changes they can make immediately]

### Keywords to Add
Based on target role, add these throughout profile:
- [keyword 1]
- [keyword 2]
```

## After Review

Offer to:
1. Generate ready-to-paste rewrites with copy blocks
2. Run `/check-alignment` to compare with resume
3. Run full `/job-search-prep` workflow
