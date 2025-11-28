# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Educational transcripts from YouTube playlists (TechJoy, Career), cleaned and organized for use with Claude Projects. This is a content repository, not a software project—there are no build, lint, or test commands.

## Custom Commands

### `/clean-transcript`
Cleans transcript files by removing filler while preserving educational content.

**Remove:** Conversational filler, technical difficulties, verbal filler ("um", "uh", "like"), off-topic content

**Keep:** Frameworks, actionable advice, examples, templates, statistics, relevant Q&A

**Flag:** Ambiguous content with `[REVIEW: reason]` for human review

**Output:** Markdown with section headers, bullet points, bold emphasis, short paragraphs (2-3 sentences max)

## Architecture

```
Career/
├── LinkedIn/           # Raw transcripts (22 files)
├── LinkedIn_Edited/    # Cleaned transcripts + system prompt + user guide
│   └── private/        # Personal documents (gitignored)
├── Resume/             # Raw transcripts (8 files)
├── Resume_Edited/      # Cleaned transcripts + system prompt + user guide
│   └── private/        # Personal documents (gitignored)
└── TechInterview/      # Interview resources
Gaming_PC/              # PC build transcripts
RPGs/                   # RPG-related content
```

## Claude Projects

Two career coaching projects with system prompts and knowledge bases:

| Project | System Prompt | Knowledge Base |
|---------|---------------|----------------|
| LinkedIn Profile Review | `Career/LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md` | 22 transcripts in `LinkedIn_Edited/` |
| Resume Review | `Career/Resume_Edited/RESUME_SYSTEM_PROMPT.md` | 8 transcripts in `Resume_Edited/` |

Setup: Copy system prompt to Project Instructions at claude.ai, upload the corresponding `*_Edited/` folder as knowledge base.

## File Naming Conventions

- Transcripts: `[topic]_[keyword]_[week].txt`
- System prompts: `*_SYSTEM_PROMPT.md`
- User guides: `*_USER_GUIDE.md`
- Cleaned versions go in `*_Edited/` directories
