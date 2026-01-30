# ClawdBot Is the Most Powerful AI Tool I've Ever Used

**Source:** Alex Finn — [YouTube](https://youtu.be/Qkqe-uRhQJE)
**Date:** 2026-01-24 | **Duration:** 27 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## What ClawdBot Is

An open-source 24/7 AI agent that runs on your own hardware (Mac Mini, VPS, old laptop). Created by Peter Steinberger. Connects through messaging apps (Telegram, WhatsApp, iMessage, Discord). Three defining features:

1. **Full computer control** — browsers, Google Docs, Apple Notes, email, Notion, anything on the machine
2. **Infinite memory** — saves important details from every conversation. Mentioned having a newsletter → 2 days later it proactively wrote drafts
3. **Messaging interface** — text commands from anywhere in the world via Telegram, WhatsApp, etc.

Alex named his ClawdBot "Henry" and gave it an owl logo.

---

## Hardware Options

| Option | Cost | Notes |
|--------|------|-------|
| **Mac Mini (base)** | $600 | Alex's choice. AirDrop integration, macOS ease of use. Fun to see agent working on desk. |
| **Mac Studio (512 GB)** | ~$10K | For running local models. Future-proofing against OOTH cutoffs. |
| **VPS (AWS, etc.)** | Low | Cheapest option but **not secure by default**. Requires manual security setup. |
| **Old laptop** | Free | Any spare computer works. |

**Key recommendation:** Don't run ClawdBot on your main computer. It has zero guardrails — could access personal email, iMessage, files. Give it its own isolated environment with dedicated accounts.

---

## Model Selection: Brain vs. Muscles

Alex frames it as two dimensions: **personality** and **intelligence**.

| Model | Intelligence | Personality | Cost |
|-------|-------------|-------------|------|
| **Claude Opus 4.5** | Highest | Highest — "truly feels human" | $200/mo (Max plan) |
| **ChatGPT 5.2** | Very high | Robotic | ~$100/mo |
| **MiniMax** | Good | Decent | ~$10/mo |

**Why personality matters:** When the bot responds like a robot, the illusion of having an employee breaks. Opus makes interactions fun and satisfying. MiniMax is the best budget option.

---

## 6 Setup Recommendations

### 1. Brain Dump About Yourself

Tell ClawdBot everything: interests, job, daily/weekly work, tools you use, favorite sports teams. This builds the memory pool for relevant proactive work.

**Prompt pattern:** "Hi, let's get to know each other. I'm going to tell you about myself. Then please ask me any questions you want." Then dump everything.

### 2. Set Up a Daily Morning Brief

Ask it to send a daily brief including:
- Weather
- Competitive research (other channels/creators in your space)
- Overnight work completed
- Tasks for today
- Ideas based on your interests

**Key concept — "Reverse Prompting":** Instead of telling the AI what to do, ask it what it can do for you. "Based on what you know about me, what tasks can you do? What would be helpful?" This surfaces unknown unknowns.

### 3. Vibe Code Through ClawdBot

Connect it to Claude Code or Codex CLI. Give it repository access on GitHub.

**Workflows:**
- "Build a Kanban board to track our tasks" → it built a Linear-like project management tool
- "Build an article writing feature in Creator Buddy" → built while Alex was driving
- "Go on Twitter, find challenges people have, then vibe code apps for them"

### 4. Build a Kanban Board / Mission Control

Have it build a project management interface. Add tasks to a backlog, assign them to the bot, track progress. Eliminates needing to text tasks one at a time.

### 5. Create a Dedicated Gmail Account

Set up a separate email for the bot. Forward emails to it with instructions: "Respond to this. Schedule an event. Remind me later. Do the tasks in this email."

### 6. Build a Second Brain

Ask: "Let's set up a second brain based on what you know about me."

Alex's system auto-organizes into folders:
- **Ideas** — tweet ideas, content ideas
- **Inbox** — app ideas, general thoughts
- **Research** — topics to investigate

The bot is building a UI to browse all collected ideas. Goal: replace Notion entirely.

---

## Nightly Workflow

Every night before bed: "Hey, build something cool for me tonight." Wake up to a new app or feature every morning.

---

## Societal Impact Warning

Alex believes this will eliminate a significant portion of the global workforce. Roles at risk: paralegals, executive assistants, secretaries, junior roles.

**His framing:** "You cannot stop innovation. When the industrial revolution happened, people charged machines with hammers. It didn't matter." The only option is to embrace it and stay on the cutting edge.

Claims to see "the path to a one-person billion-dollar business" for the first time.
