# Stop Using Claude Code Like This (Use Sub-Agents Instead)

**Source:** Leon van Zyl — [YouTube](https://youtu.be/P60LqQg1RH8)
**Date:** 2026-01-14 | **Duration:** 31 minutes

---

## Core Problem

Doing everything in the main Claude Code thread fills up the 200K token context window fast. Once it compacts, you lose critical context and quality degrades. This is why people complain "agent coding doesn't work" — they're cramming everything into one thread.

**Solution:** Offload work to sub-agents. Each sub-agent gets its own context window. Only a summary returns to the main thread.

---

## Built-In Sub-Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| **Bash** | — | Git operations, command execution, terminal tasks |
| **General Purpose** | — | Research, code search, multi-step tasks |
| **Explore** | Haiku | Fast codebase scanning for patterns and files |
| **Plan** | Inherits main (Opus) | Investigation, requirements analysis, solution planning |
| **Claude Code Guide** | — | Answers questions about Claude Code features |
| **Status Line Setup** | — | Configures the terminal dashboard |

---

## How to Invoke Sub-Agents

- **Direct:** Type `@` then select the agent — ask it a question directly
- **Background:** Press `Ctrl+B` to run any agent in the background, freeing the main thread
- **Via main agent:** Ask the main agent to "use an explore agent to..." or "kick off the coder agent to..."
- **View background tasks:** Press `Down arrow` → `Enter` to see running agents and their output

---

## Context Window Mechanics

- Claude Code has a **200,000 token** context window
- Check usage: run `/context`
- Sub-agent token usage **does not affect** the main thread's tokens
- Sub-agents return only a **summary** to the main thread
- Without sub-agents: a complex plan uses ~60% of context. With sub-agents: ~26%

**Key insight:** Sub-agents don't reduce overall token usage — they **protect the main conversation** from filling up.

---

## Creating Custom Agents

Run `/agents` → Create new agent → Choose project or personal level.

### Three Custom Agents Created

**1. UI Expert** (Opus, project-level)
- Experienced UI/UX expert
- Enforces neo-brutalism design system (bright colors, hard shadows, minimalist, responsive)
- Specific design rules baked into system prompt

**2. Coder** (Sonnet or Opus, project-level)
- Experienced developer, 20+ years
- Writes performant, secure, well-commented code following best practices
- Opus recommended if budget allows; Sonnet still good with review workflow

**3. Code Reviewer** (Haiku, personal-level)
- Checks completeness against requirements
- Ensures security, performance, best practices
- Enforces modular code, appropriate file length, detailed comments
- Haiku works well for identifying glaring issues

**Tip:** Add company-specific coding standards and naming conventions to both coder and reviewer agent prompts.

---

## Wave-Based Implementation Workflow

### Phase 1: Planning

1. Enter planning mode
2. Ask main agent to launch **3 planning agents in parallel** with your feature requirements
3. Each planning agent investigates different aspects (auth, database, UI)
4. Combined: ~80K tokens consumed by sub-agents, main thread stays at ~26%

### Phase 2: Document the Plan

1. Create a `spec/` folder in the project root
2. Switch to change mode
3. Ask main agent to write a detailed implementation plan split into phases
4. Speed up: tell it to "kick off multiple general purpose agents in parallel" to write remaining files (7 agents writing simultaneously)

### Phase 3: Wave-Based Implementation

**The orchestration prompt:**

> "I need you to implement this feature. Don't write any code yourself. Your role is to coordinate between coding agents and code review agents. Find phases that can run in parallel, create tracks. For each track, kick off a coder agent. Once done, hand off to a code review agent. This cycle continues until fully implemented. At the very end, kick off three code review agents to review the final state from different perspectives."

**How it plays out:**
- Main agent identifies **waves** of parallel work
- Wave 1: Project setup (sequential — everything depends on it)
- Wave 2+: Parallel tracks (e.g., Kanban board + Calendar + Filtering — 3 coder agents simultaneously)
- Each track: Coder implements → Code reviewer reviews → Coder fixes → Done
- Final pass: 3 code review agents audit from different perspectives

### Phase 4: Fix Issues

- Code review identifies security and accessibility issues
- Ask main agent to "kick off coder sub agents to fix these issues in parallel"
- Still only at ~58–68% context with a fully functional app

---

## Demo Results

Built a full Kanban to-do app with:
- User authentication (Better Auth)
- Postgres database (Drizzle ORM, Docker)
- Drag-and-drop Kanban board
- Calendar view (day/week/month)
- Local storage fallback for unauthenticated users
- Password strength indicator

**Final context usage: 68%** — impossible to achieve in a single thread for a project this size.

---

## Practical Tips

- **Run Claude Code in a separate terminal** (not the IDE terminal) — more reliable, less crashing. `Ctrl+Shift+C` in VS Code opens a terminal at current directory.
- **Always use planning mode first** — don't jump straight to coding
- **Parallelize documentation writing** — no dependencies between spec files
- **Add a testing sub-agent** if needed — could use Playwright MCP server for UI testing
- **Clear conversation between major phases** — start fresh with your spec folder as context
