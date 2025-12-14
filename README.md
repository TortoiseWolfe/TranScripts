# TranScripts

Educational transcripts from YouTube playlists, cleaned and organized for use with Claude Projects.

## Source Playlists

- [TechJoy](https://youtube.com/playlist?list=PLuePfAWKCLvVZkhipXPPy3ds1LYHmiHHx)
- [Career](https://youtube.com/playlist?list=PLETG2T1KvnirgjpSq5Q-SvaNyZGsvfMMg)

---

## MCP Server Setup

This repo uses two MCP servers, both available in Docker Desktop's MCP Catalog.

### YouTube Transcript Server

[jkawamoto/mcp-youtube-transcript](https://github.com/jkawamoto/mcp-youtube-transcript) extracts transcripts from videos.

**Docker Desktop:** MCP Toolkit → Search "youtube-transcript" → Add server.

### LinkedIn Server

[stickerdaniel/linkedin-mcp-server](https://github.com/stickerdaniel/linkedin-mcp-server) accesses LinkedIn profile data directly.

**Docker Desktop:** MCP Toolkit → Search "LinkedIn" → Add server → Configuration tab.

**Two fields to configure:**

| Field | Section | Required | Purpose |
|-------|---------|----------|---------|
| `linkedin-mcp-server.cookie` | Secrets | Yes | Your `li_at` session cookie |
| `linkedin-mcp-server.user_agent` | Configuration | No (recommended) | Helps avoid detection/blocks |

**Step 1: Get the `li_at` cookie**
1. Log into LinkedIn in your browser
2. Open DevTools (F12) → Application → Cookies → linkedin.com
3. Find the `li_at` cookie (long string starting with `AQ...`)
4. Copy the entire value
5. Paste into `linkedin-mcp-server.cookie` field

**Step 2: Set user agent (recommended)**
1. Copy your browser's user agent (search "my user agent" in Google)
2. Paste into `linkedin-mcp-server.user_agent` field
3. This helps prevent LinkedIn from blocking automated access

**Troubleshooting:**
- **"login_timeout" / "Cookie authentication failed":** Cookie expired or LinkedIn blocked access—get fresh cookie, add user agent
- **Cookie expires:** Every ~30 days—reconfigure when it stops working
- **Rate limiting:** Don't make too many requests in quick succession

**Fallback:** If MCP fails, download your LinkedIn data export (Settings → Data Privacy → Get a copy of your data) and use `/extract-linkedin` to process the CSV files instead.

---

## Documentation

- [Career Setup Instructions](Career/README.md) - Claude Project setup
- [LinkedIn Data Export Guide](Career/LinkedIn_Edited/README.md) - How to export your LinkedIn profile

---

## Slash Commands

Custom commands for Claude Code in this repo:

| Command | Description |
|---------|-------------|
| `/clean-transcript` | Clean a raw transcript file—removes filler, keeps frameworks and actionable advice, outputs markdown |
| `/extract-linkedin` | Unzip LinkedIn data export in `Career/LinkedIn_Edited/private/`, delete irrelevant files, keep profile data for analysis |
| `/extract-facebook` | Unzip Facebook data export in `Career/Facebook_Edited/private/`, keep career-relevant files only |
| `/job-search-prep` | **Full workflow:** Review resume + LinkedIn + alignment check, generate fixes file with copy blocks |
| `/review-resume` | Standalone resume analysis against coaching frameworks |
| `/review-linkedin` | Standalone LinkedIn profile analysis (via MCP or CSV export) |
| `/check-alignment` | Compare resume ↔ LinkedIn for consistency issues |

---

## Quickstart

1. Go to [claude.ai](https://claude.ai) → Create new Project
2. Copy system prompt from `Career/LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md` or `Career/Resume_Edited/RESUME_SYSTEM_PROMPT.md`
3. Upload the corresponding `*_Edited/` folder as knowledge base
4. Use the example prompts below

---

## Example Prompts

### LinkedIn Profile

After uploading your LinkedIn CSV files to a Claude Project with the `LinkedIn_Edited/` knowledge base:

**Full profile review:**
```
Review my LinkedIn CSV files against the frameworks in LinkedIn_Edited/. Give me a score and prioritized list of what to fix.
```

**Quick wins:**
```
Based on my Profile.csv and Skills.csv, what are 5 changes I can make in the next 10 minutes to improve recruiter visibility?
```

**Headline rewrite:**
```
Rewrite my headline from Profile.csv using the formula in linkedin_headline_workshop_evening.txt. Give me 3 options.
```

**About section rewrite:**
```
Rewrite my Summary from Profile.csv using the 5-part structure in linkedin_summary_about_section.txt.
```

**Experience bullets:**
```
Rewrite my Positions.csv descriptions using the skills-focused format in linkedin_skills_projects_education.txt. Replace duties with searchable skills.
```

**Skills audit:**
```
Audit my Skills.csv against the SEO strategy in linkedin_seo_recruiter_optimization_week12.txt. What's missing? What should I reorder?
```

**Job description match:**
```
Compare my profile against this job posting and tell me which keywords I'm missing: [paste job description]
```

**Recommendations review:**
```
Evaluate Recommendations_Received.csv using the 4-part framework in linkedin_recommendations_week9.txt. Which ones help and which don't?
```

**All-Star checklist:**
```
Run the All-Star Profile Completeness Checklist from the frameworks against my CSV files. What's missing?
```

---

### Resume

After uploading your resume to a Claude Project with the `Resume_Edited/` knowledge base:

**Full resume review:**
```
Review my resume against the frameworks in Resume_Edited/. Score my bullets and tell me what to fix first.
```

**Bullet rewrites:**
```
Rewrite my experience bullets using the Action + Task + Result formula from resume_experience_bullets_week5.txt.
```

**Summary rewrite:**
```
Rewrite my professional summary using the 4-line formula in resume_professional_summary_week3.txt.
```

**ATS keyword check:**
```
Check my resume against this job posting for missing keywords using the anchor strategy in resume_keywords_week4.txt: [paste job description]
```

**6-second scan test:**
```
Evaluate my resume using the 6-second scan criteria from resume_recruiter_perspective_week1.txt. What do recruiters see first?
```

---

### Cover Letter

**Cover letter from job posting:**
```
Using my resume and this job posting, write a cover letter that connects my experience to their requirements. Focus on 2-3 specific achievements that match what they're looking for: [paste job posting or link]
```

---

### Cross-Project

**LinkedIn/Resume consistency check:**
```
Compare my LinkedIn (Profile.csv, Positions.csv) and resume to ensure my messaging is consistent. Flag any contradictions.
```
