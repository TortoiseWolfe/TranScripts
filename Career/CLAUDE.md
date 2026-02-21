# Career — CLAUDE.md

## Purpose

Career coaching transcripts and personal documents for resume, LinkedIn, cover letter, and job search preparation.

## No Fabrication Policy

**NEVER fabricate details about the user's work history, skills, or experience.** Use only information from existing documents in `private/` directories or direct user statements. Use `[VERIFY: assumed detail]` for any additions.

## Structure

```
Career/
├── LinkedIn/              # Raw LinkedIn coaching transcripts
├── LinkedIn_Edited/       # Cleaned transcripts + system prompt
│   └── private/           # Personal LinkedIn data exports (gitignored)
├── Resume/                # Raw resume coaching transcripts
├── Resume_Edited/         # Cleaned transcripts + system prompt
│   └── private/           # Personal resume files (gitignored)
├── CoverLetter_Edited/    # Cover letter system prompt + drafts
│   └── private/           # Cover letter drafts (gitignored)
├── JobSearch/             # Job search tracking
│   └── private/           # Job applications (gitignored)
├── LinkedIn_Posts/        # LinkedIn post drafts
└── TechInterview/         # Interview prep transcripts
```

## Key Files

- `LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md` — LinkedIn review frameworks
- `Resume_Edited/RESUME_SYSTEM_PROMPT.md` — Resume review frameworks
- `CoverLetter_Edited/COVERLETTER_SYSTEM_PROMPT.md` — Cover letter frameworks

## Resume Variants

Three tailored resumes in `Resume_Edited/private/`: AI, DotNet, WebReact.

## Commands

- `/review-resume` — Analyze resume against coaching frameworks
- `/review-linkedin` — Analyze LinkedIn against coaching frameworks
- `/check-alignment` — Compare resume and LinkedIn for consistency
- `/job-search-prep` — Full review workflow (resume + LinkedIn + alignment)
- `/extract-linkedin` — Process LinkedIn data export zip
- `/extract-facebook` — Process Facebook data export

## Cover Letters

- Format: RTF (`CoverLetter_[Company]_[JobID].rtf`)
- Save to: `CoverLetter_Edited/private/`
- Style guide: `good_prompt_bad_prompt/` symlink at repo root

## Privacy

All `private/` directories are gitignored. Never commit personal data, resume files, or cover letters.
