# Skills.sh — Level Up Your Claude Code Agents

**Source:** All About AI — [YouTube](https://youtu.be/vDBUf533e_M)
**Date:** 2026-01-21 | **Duration:** 14 minutes
**Site:** [skills.sh](https://skills.sh)

---

## What Is Skills.sh?

An **open AI agent ecosystem/marketplace** from Vercel. It lets you install, create, manage, and share skills that extend Claude Code's capabilities — including custom slash commands and domain expertise.

- Think of it as **between an MCP server and a plugin** — domain-specific knowledge packages
- Install with one command: `npx skills add <repo>`
- Skills are **project-scoped** (not global) by default
- After installing, restart Claude Code, then verify with `/skills`

## Skills Structure

After installing, skills appear in your project under `.claude/skills/`:
- Each skill has a `SKILL.md` file with the full knowledge base
- Claude automatically loads relevant skills during tasks
- Skills can reference external documentation that Claude fetches on demand

---

## Demo 1: Web Development Skills

### Skills Installed
1. **Vercel React Best Practices** — most installed skill on the marketplace; covers rendering performance, JavaScript performance
2. **Web Design Guidelines** — fetches fresh guidelines before each review

### Workflow
1. Install both skills via `npx skills add`
2. Restart Claude Code
3. Prompt: "I already have a working Vercel stack page. Explore the codebase. Please use best practices to update this page. Also, I want the page to have a dark mode option and some smooth animations."
4. Claude loads both skills, reviews the codebase against the guidelines, identifies issues (accessibility, interaction patterns), and implements fixes

### Results
- Dark mode added across all pages (pricing, blog, sign-in) with persistence
- Smooth animations maintained
- Code reviewed against Vercel best practices automatically
- Issues flagged with specific line numbers before fixing

---

## Demo 2: Remotion Video Editing

### Skill Installed
- **Remotion Best Practices** — rules for 3D assets, fonts, animations, audio, video composition

### Workflow
1. Install Remotion skill via `npx skills add`
2. Provide two video clips (12-second intro + B-roll)
3. Plan: Use **FFmpeg** to extract audio → **Whisper** (local) for SRT transcription with timestamps → **Remotion** to composite with captions, B-roll insertion, and animations
4. Enter Claude Code plan mode, let it reference Remotion skills for correct patterns
5. Execute the plan hands-off

### Results (First Pass)
- Captions added and working
- B-roll inserted at ~8 seconds (could be earlier)
- Basic but functional video edit

### Results (Refined Pass)
- Asked for "more engaging editing"
- Claude suggested sound effects — user created 6 audio files
- Final render included sound effects layered in
- Not perfect, but promising for code-based video editing

---

## Key Takeaways

- **Installation is trivial:** `npx skills add <repo>` — one command per skill
- **Project-scoped:** Skills apply only to the project where they're installed
- **Auto-invoked:** Claude automatically uses relevant skills when it detects they apply to the current task
- **Marketplace growing:** Expect more agent skill marketplaces in 2026
- **Non-code use cases:** Skills aren't just for coding — Remotion demo shows video editing, and the pattern extends to any domain where expertise can be codified into markdown
