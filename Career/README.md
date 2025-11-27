# Career Coaching Claude Projects

This folder contains custom Claude Project instructions for reviewing LinkedIn profiles and resumes, based on 30 cleaned transcripts from professional career coaching sessions.

---

## Available Projects

| Project | Purpose | Input |
|---------|---------|-------|
| **LinkedIn Profile Review** | Optimize your profile for recruiter searches | LinkedIn data export (Profile.csv) |
| **Resume Improvement** | Rewrite bullets and improve ATS optimization | Resume text or file upload |

---

## How to Use the LinkedIn Profile Review Project

### Step 1: Export Your LinkedIn Data

1. **Click the "Me" icon** (your profile photo) at the top of LinkedIn
2. Go to **Settings & Privacy**
3. Click **Data Privacy** in the left menu
4. Select **Get a copy of your data**
5. Choose **"Select the data files you're most interested in"**
6. Check the box for **Profile** (this is the fastest option)
7. Click **Request archive**
8. Check your email - you'll receive a download link within minutes

> **Note:** The download link expires after 72 hours.

### Step 2: Download and Extract

1. Click the link in LinkedIn's email
2. Download the ZIP file
3. Extract/unzip the contents

**You'll find these files:**
```
├── Articles/
├── Connections.csv
├── Contacts.csv
├── Invitations.csv
├── Messages.csv
├── Profile.csv        ← This is what you need
└── Registration.csv
```

### Step 3: Submit for Review

Open **Profile.csv** and either:
- **Copy/paste the contents** into the chat, OR
- **Upload the file** directly

Claude will provide a complete section-by-section review with:
- Specific rewrites for your headline and about section
- Keyword optimization for recruiter searches
- Skills recommendations
- All-Star profile completeness checklist

---

## How to Use the Resume Improvement Project

### Step 1: Prepare Your Resume

Have your resume ready in one of these formats:
- **Text** - Copy/paste directly into chat
- **PDF or Word file** - Upload to the chat

### Step 2: Choose Your Output Format

Claude will ask your preference:

| Option | What You Get |
|--------|--------------|
| **Full Rewrite** | Complete revised resume ready to use |
| **Tracked Changes** | Before/after for each section with explanations |

### Step 3: Review and Apply

Claude will analyze your resume against proven frameworks:
- **Action Verb + Task + Result** formula for every bullet
- **Impact Logic** for writing strong bullets without metrics
- **Keyword optimization** for ATS systems
- **6-Second Scan** priorities (what recruiters see first)

---

## What's Included

### Project Instructions (for Claude Project setup)
- `LINKEDIN_PROJECT_INSTRUCTIONS.md` - Complete instructions for LinkedIn review project
- `RESUME_PROJECT_INSTRUCTIONS.md` - Complete instructions for Resume improvement project

### Knowledge Base (cleaned transcripts)
- `LinkedIn_Edited/` - 22 transcripts covering profile optimization, SEO, networking, recommendations
- `Resume_Edited/` - 8 transcripts covering bullets, summaries, keywords, structure

### Original Transcripts
- `LinkedIn/` - Raw transcripts from LinkedIn coaching sessions
- `Resume/` - Raw transcripts from Resume coaching sessions

---

## Key Frameworks

### LinkedIn Headline Formula
```
Role/Identity + Skills & Tools + Value Proposition
```
Example: "Full Stack Developer | React, Node.js, TypeScript | Building user-centered scalable applications"

### Resume Bullet Formula
```
Action Verb + Task + Result
```
Example: "Improved site load time by 40% through optimized code deployment"

### Professional Summary Structure
1. Who you are and your main focus
2. What you do well (tools/skills)
3. Proof of impact or contribution
4. What you want next

---

## Tips for Best Results

**For LinkedIn:**
- Export fresh data right before your review
- Have 2-3 target job descriptions ready (Claude will extract keywords)
- Be ready to update your profile immediately after review

**For Resume:**
- Include your target role or job description for tailored feedback
- Have your LinkedIn profile handy for consistency checks
- Save as PDF when applying (never submit Word docs)
