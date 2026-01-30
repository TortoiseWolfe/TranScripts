# His Claude Code Workflow Is Insane

**Source:** josh :) — [YouTube](https://youtube.com/watch?v=JUTx6MxOjhE)
**Date:** 2026-01-10 | **Duration:** 18 minutes

---

## Overview

Breakdown of **Boris Cherny's** (Claude Code creator) workflow — 9 steps from foundational to advanced. Josh demos each step on his own portfolio site, building features live.

---

## Boris Cherny's 9-Step Workflow

### 1. Start Every Session in Plan Mode

- **Shift+Tab twice** or type `/plan`
- Claude can only **read** your codebase — no writes allowed
- Have a back-and-forth until both you and Claude agree nothing is left to clarify
- Then switch to auto-accept mode — **Claude can usually one-shot the entire implementation**

> "A good plan is really important. Once you like the plan, only then do you switch to auto accept mode." — Boris Cherny

**Josh's experience:** Even for a simple copy-code button, plan mode found an existing implementation he'd forgotten about — prevented code duplication across a decade-old blog.

### 2. Build Your CLAUDE.md Over Time

- Lives in your repo root — acts as **Claude's memory**
- Documents architecture, key files, dev commands, design system, conventions
- Generate with `/init` — Claude combs your codebase and creates the file
- **Boris's team trick:** Tag Claude (`@.claude`) in teammates' PRs to add learnings to CLAUDE.md — every merged PR makes the repo memory smarter

### 3. Custom Slash Commands for Repeated Workflows

Boris's most-used command: **`/commit-push-pr`** — invoked dozens of times daily.

**How to create:**
1. Make `.claude/commands/` directory
2. Create a markdown file (e.g., `commit.md`)
3. **Embed shell commands** with backticks — pre-fills git status, recent commits
4. Type `/commit` and Claude knows exactly what to do

**Key trick:** Embedded commands run before the prompt reaches Claude, so it already has context without wasting tokens.

### 4. Pre-Allow Safe Permissions

- Run `/permissions` to add rules
- Example: Allow `web_fetch` without asking every time
- Choose **local** (project) or **user** (global) scope
- Keeps you in flow state — no interruptions for known-safe operations

> **Never use `--dangerously-skip-permissions`** — "I don't even want to teach you this command. Just don't do it."

### 5. Deploy Sub-Agents for Review and Testing

Boris uses specialized AI assistants that run after Claude finishes:
- **Code Simplifier** — cleans up code after it's written
- **Verify App** — detailed instructions for testing the entire application

**How to create:**
1. Make `.claude/agents/` directory
2. Create markdown file with frontmatter (name, tools access)
3. Write the system prompt description
4. Invoke: `use code-simplifier to clean up load-templates.js`

### 6. Auto-Format with Post-Tool-Use Hooks

Boris runs a hook that **automatically formats code** after Claude edits it — handles the last 10% that prevents CI failures.

**Setup:**
1. Run `/hooks`
2. Select **post tool use**
3. Trigger: after write/edit
4. Command: `npm run lint`
5. Save locally

### 7. Connect External Tools with MCP

MCP turns Claude Code from a coding assistant into an **interface for your entire dev ecosystem**:
- Post to **Slack**
- Run **BigQuery** analytics
- Grab error logs from **Sentry/Rollbar**
- Write **Jira** tickets
- Open **PRs**

Josh demos connecting a flight search API — silly example but shows the pattern.

### 8. Use Stop Hooks for Verification

**Boris's most important tip:** Give Claude a way to verify its work.

> "If Claude has that feedback loop, it will 2-3x the quality of the final result."

- When Claude says it's done, a **verification agent** checks the work
- Says "not done, keep working" or confirms completion
- Creates a feedback loop **without babysitting**
- Boris uses the **Claude Chrome extension** — opens browser, tests UI, iterates until code works and UX feels good

### 9. Ralph Wiggum Plugin (Use With Caution)

Named after the Simpsons character. Invented by **Jeffrey Huntley**. Keeps Claude working in **autonomous loops** until it genuinely succeeds.

**Claimed results (from Twitter):**
- 3-month autonomous loop built an entire programming language
- $50,000 contract completed for $297 in API costs

**Best for:** Large refactors, batch operations, grinding through hundreds of tickets. **Not for simple tasks.**

**Josh's live test:** Migrated old blog posts to new styling with 50 max iterations. Result:
- Better than before, but **not perfect**
- Lost the copy-code feature
- Diagrams broke centering
- Cost ~$10
- "I don't think I'm going to keep it... really just a money sync"
- "I think it will get there... that day is probably sooner than I think"

---

## Key Takeaways

- **Plan more, debug less** — "that is the entire job of software engineering"
- **CLAUDE.md as living documentation** — gets smarter with every PR
- **Embedded commands in slash commands** = no wasted tokens on context gathering
- **Verification is the #1 factor** for quality — 2-3x improvement
- **Ralph Wiggum is not ready** for complex visual tasks — best for code-heavy batch work
- Claude Code is evolving from coding assistant to **full development ecosystem interface**
