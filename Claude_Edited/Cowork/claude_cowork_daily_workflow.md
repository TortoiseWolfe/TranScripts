# Claude Cowork: Daily Operating System Workflow

**Source:** Alex Finn — [YouTube](https://youtu.be/rdURhrS4xHI)
**Date:** 2026-01-20 | **Duration:** 13 minutes
**Resources:** [claude.md file](https://docs.google.com/document/d/1AcplzIFpht45oPxJgJLKQFF9aoeavjPMF1GzZDjU3g4/) | [Starter prompt](https://docs.google.com/document/d/1RPnX-5g-v-95TYNRRG8c-sFtkk6WmzUnbaK3_L-NFWw/)

---

## What Is Claude Cowork?

Claude Code for your entire life — the Anthropic AI agent running as a Mac desktop app that can manipulate files, do research, and execute tasks autonomously. Not just for coding.

## The Core Problem It Solves

Most people don't use Claude Cowork because they don't know **what tasks to give it**. This workflow flips the relationship: instead of you telling the AI what to do, **the AI interviews you** and figures out what it can do from your to-do list.

---

## The Daily Workflow

### Morning Trigger

Type: **"Let's start our day"** (or "morning", "daily brief", etc.)

Claude Cowork reads the `claude.md` rules file and asks three questions:

1. **What's the #1 thing that would make today a win?**
2. **What's on your to-do list for today?**
3. **Any urgent items I should know about?**

### What Happens Next

1. Claude reviews your entire to-do list
2. Identifies which tasks it can help with
3. Proposes specific deliverables for each (research, drafts, scripts, strategies)
4. You say **"Okay, go ahead"**
5. Claude spins up **parallel sub-agents** to work on multiple tasks simultaneously
6. All output is saved to the **outbox folder** as organized markdown files

### End of Day Trigger

Type: **"End of day"**

Claude will:
- Summarize what was accomplished
- List everything it completed
- Suggest priorities for tomorrow

---

## Demo Output (Single Morning Session)

From one "Let's start our day" prompt, Claude Cowork produced:
- Full YouTube video script
- 10-tweet X thread on the X algorithm (researched ~100 websites)
- AI energy stock research report with catalyst/growth profiles
- YouTube growth strategy to 100K subscribers
- Newsletter draft

All completed within ~3 minutes using parallel sub-agents.

---

## Folder System

```
Claude/
├── claude.md          # Rules file — the "brain" of the system
├── context/           # Persistent context about you
│   ├── profile.md     # Who you are, goals, preferences
│   ├── portfolio.md   # Stocks, investments, assets
│   ├── schedule.md    # Your schedule
│   └── projects.md    # Current projects
├── inbox/             # Files you want Claude to see before tasks
├── outbox/            # All Claude output (organized by date/task)
└── skills/            # Custom skill markdown files
```

### Setup

1. Create a `Claude/` folder (e.g., in Documents)
2. Open Claude Cowork desktop app → New Task → select the Claude folder
3. Paste the **starter prompt** (linked in video description) — it creates the entire folder structure
4. Copy the **claude.md** rules file into the folder
5. Fill in your `context/` files (profile, portfolio, schedule, projects)

### Key Design Decisions

- **`claude.md`** = the rules engine; defines the morning workflow, end-of-day routine, and how Claude handles files
- **`inbox/`** = drop files here for Claude to process (scripts to review, docs to analyze)
- **`outbox/`** = all Claude output lands here, organized and structured
- **`context/`** = persistent knowledge about you so Claude can be proactively helpful
- **`skills/`** = custom skill definitions (markdown files describing how to do specific tasks) — anticipates future native skills support

---

## Why This Works

- **Reverses the AI relationship** — AI asks you what you're doing, then figures out how to help (vs. you figuring out what to ask)
- **Eliminates creative friction** — no need to brainstorm tasks for the AI; just share your to-do list
- **Parallel execution** — multiple sub-agents work simultaneously on different tasks
- **Organized output** — everything lands in a structured file system
- **Fully customizable** — edit `claude.md` to change any behavior

## Key Takeaway

The biggest barrier to using Claude Cowork is not knowing what to ask it. This system removes that barrier by having Claude interview you about your day and self-assign the tasks it can handle. The `claude.md` rules file is the entire brain of the operation.
