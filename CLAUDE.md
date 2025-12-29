# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Educational transcripts from YouTube playlists (TechJoy, Career, Docker/DevOps), cleaned and organized for use with Claude Projects. This is a content repository, not a software project—there are no build, lint, or test commands.

## CRITICAL: No Fabrication Policy

**NEVER fabricate, invent, or assume details about the user's work history, skills, or experience.**

When writing or editing career documents (resumes, LinkedIn content, cover letters):

1. **Use ONLY information from:**
   - User's existing resume (`Career/Resume_Edited/private/`)
   - User's LinkedIn export (`Career/LinkedIn_Edited/private/`)
   - Direct statements from the user in conversation
   - MCP-fetched profile data

2. **If information is missing:**
   - ASK the user directly
   - Use placeholder text like `[DESCRIBE YOUR ROLE HERE]`
   - Leave the field blank with a note

3. **NEVER invent:**
   - Company descriptions or industries
   - Job responsibilities not stated by user
   - Metrics, numbers, or achievements
   - Project details or technologies used

4. **When reformatting existing content:**
   - Restructure for clarity, but preserve meaning
   - Do not add claims the user didn't make
   - Flag any additions with `[VERIFY: assumed detail]`

Violating this policy damages trust and could put false information on the user's professional documents.

## Cover Letter & Document Formatting

**Always create RTF format.** Job applications typically accept: `.doc`, `.docx`, `.rtf`, `.odt`, `.pdf`, `.txt`

**Use RTF (Rich Text Format)** - it's text-based so Claude can write it directly with formatting (bold, fonts, margins).

**File naming:** `CoverLetter_[Company]_[JobID].rtf` (e.g., `CoverLetter_TDOC_73325.rtf`)

**Save location:** `Career/CoverLetter_Edited/private/` (gitignored)

**System prompt:** `Career/CoverLetter_Edited/COVERLETTER_SYSTEM_PROMPT.md`

## Custom Commands

### `/clean-transcript`
Cleans raw transcript files for use as Claude Project knowledge bases.

**Remove:** Conversational filler, technical difficulties, verbal filler ("um", "uh", "like"), off-topic content

**Keep:** Frameworks, actionable advice, examples, templates, statistics, relevant Q&A

**Flag:** Ambiguous content with `[REVIEW: reason]` for human review

**Output:** Markdown with section headers, bullet points, bold emphasis, short paragraphs (2-3 sentences max)

### `/extract-linkedin`
Processes LinkedIn data export archives in `Career/LinkedIn_Edited/private/`.

**Keep:** Profile.csv, Positions.csv, Skills.csv, Education.csv, Projects.csv, Certifications.csv, Recommendations_Received.csv, Connections.csv, Company Follows.csv

**Delete:** Ad targeting, messages, invitations, rich media, learning data, and other non-profile files

**Note:** The `private/` directory is gitignored—never commit personal data

### `/extract-facebook`
Processes Facebook data export archives in `Career/Facebook_Edited/private/`.

**Keep:** Profile information, friends, followers, groups, pages, events, profile photo

**Delete:** Ads/tracking, messages, posts, comments, reactions, stories, reels, marketplace, payments, media files

**Note:** Facebook exports are HTML-based (not CSV like LinkedIn) and much larger due to media

### `/job-search-prep`
Complete job search preparation workflow combining resume review, LinkedIn review, and alignment check.

**Input:** Resume in `Career/Resume_Edited/private/` + LinkedIn (MCP or CSV export)

**Output:** Comprehensive analysis + dated fixes file with ready-to-paste copy blocks

**Workflow:**
1. Review resume against coaching frameworks
2. Review LinkedIn against coaching frameworks
3. Check alignment between both
4. Generate fixes file in `Career/LinkedIn_Edited/`

### `/review-resume`
Standalone resume analysis against `RESUME_SYSTEM_PROMPT.md` frameworks.

**Checks:** 6-second scan, bullet formula (Action+Task+Result), summary 4-line formula, ATS keywords, formatting

### `/review-linkedin`
Standalone LinkedIn profile analysis against `LINKEDIN_SYSTEM_PROMPT.md` frameworks.

**Checks:** Headline formula, about section 5-part structure, skills vs duties, All-Star checklist

**Input:** MCP server (preferred) or CSV export in `private/`

### `/check-alignment`
Compare resume and LinkedIn for consistency.

**Checks:** Title matches, date ranges, metrics/claims, technical skills, projects

## Architecture

```
Career/
├── LinkedIn/           # Raw transcripts (22 files)
├── LinkedIn_Edited/    # Cleaned transcripts + system prompt + user guide
│   └── private/        # Personal documents (gitignored)
├── Resume/             # Raw transcripts (11 files)
├── Resume_Edited/      # Cleaned transcripts + system prompt + user guide
│   └── private/        # Personal documents (gitignored)
├── CoverLetter_Edited/ # Cover letter system prompt + drafts
│   └── private/        # Cover letter drafts (gitignored)
├── Facebook_Edited/    # Facebook data exports for career analysis
│   └── private/        # Extracted Facebook data (gitignored)
└── TechInterview/      # Interview resources
Docker/                 # Raw transcripts (Bret Fisher DockerCon talks)
└── Docker_Edited/      # Cleaned transcripts + system prompt
Gaming_PC/              # PC build transcripts
RPGs/                   # RPG-related content
```

## Claude Projects

Four projects with system prompts and knowledge bases:

| Project | System Prompt | Knowledge Base |
|---------|---------------|----------------|
| LinkedIn Profile Review | `Career/LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md` | 22 transcripts in `LinkedIn_Edited/` |
| Resume Review | `Career/Resume_Edited/RESUME_SYSTEM_PROMPT.md` | 11 transcripts in `Resume_Edited/` |
| Cover Letter Review | `Career/CoverLetter_Edited/COVERLETTER_SYSTEM_PROMPT.md` | (uses Resume + LinkedIn as reference) |
| Docker Best Practices | `Docker/Docker_Edited/DOCKER_SYSTEM_PROMPT.md` | 2 transcripts in `Docker_Edited/` |

Setup: Copy system prompt to Project Instructions at claude.ai, upload the corresponding `*_Edited/` folder as knowledge base.

## File Naming Conventions

- Transcripts: `[topic]_[keyword]_[week].txt`
- System prompts: `*_SYSTEM_PROMPT.md`
- User guides: `*_USER_GUIDE.md`
- Cleaned versions go in `*_Edited/` directories

## MCP Server Quick Reference

**YouTube Transcript:** Extract transcripts directly—no config needed.

**LinkedIn MCP:** Requires `li_at=` cookie in Docker Desktop secrets. If auth fails, fallback to CSV export with `/extract-linkedin`.

---

## Common Prompt Patterns

### Career Coaching
- **Full review:** "Review my [resume/LinkedIn] against the frameworks in [folder]. Score and prioritize fixes."
- **Bullet rewrites:** "Rewrite bullets using Action + Task + Result formula"
- **Keyword match:** "Compare against this job posting for missing keywords: [paste]"
- **Consistency check:** "Compare LinkedIn and resume for contradictions"

### Docker/DevOps
- **Dockerfile review:** "Review my Dockerfile for security and efficiency. Score and prioritize fixes."
- **Multi-stage help:** "Help me convert this Dockerfile to multi-stage for dev/test/prod"
- **Base image selection:** "What base image should I use for Node.js in production?"
- **Compose setup:** "Set up Docker Compose for local Node.js development with hot reload"

---

## Workflow

**Adding new transcripts:**
1. Extract transcript from YouTube using the [YouTube Transcript MCP server](https://github.com/jkawamoto/mcp-youtube-transcript) (see README for setup)
2. Save raw transcript to appropriate folder (`Career/LinkedIn/`, `Career/Resume/`, `Docker/`, etc.)
3. Run `/clean-transcript <filename>` to create cleaned version
4. Move cleaned version to corresponding `*_Edited/` directory
5. Update Claude Project knowledge base at claude.ai if needed

**Adding Docker content:**
1. Find Bret Fisher or other Docker best practices videos on YouTube
2. Extract transcript and save to `Docker/`
3. Run `/clean-transcript` to create cleaned version
4. Move to `Docker/Docker_Edited/`
5. Update Claude Project if using Docker knowledge base

**LinkedIn profile analysis (CSV export):**
1. User downloads LinkedIn data export from LinkedIn settings
2. Place `.zip` in `Career/LinkedIn_Edited/private/`
3. Run `/extract-linkedin` to unzip and clean
4. Analyze CSVs against frameworks in `LinkedIn_Edited/` transcripts

**LinkedIn profile analysis (live via MCP):**
1. Ensure LinkedIn MCP server is configured (see README for setup)
2. Use the MCP server to fetch profile data directly
3. Analyze against frameworks in `LinkedIn_Edited/` transcripts
