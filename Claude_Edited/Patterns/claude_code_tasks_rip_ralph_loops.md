# Claude Code Tasks: The Official Evolution of Ralph Wiggum Loops

**Source:** AICodeKing — [YouTube](https://youtu.be/Qh6jg3FymXY)
**Date:** 2026-01-23 | **Duration:** 8 minutes

---

## What Changed?

Anthropic replaced **Todos** (the old TodoWrite tool) with a new system called **Tasks**. As Opus 4.5 got better at running autonomously, Anthropic found TodoWrite was unnecessary for small work — Claude already knew what to do. But for larger projects spanning multiple sessions or sub-agents, Todos were useless.

---

## Why Todos Failed

- **Memory-only** — close your session, todo list is gone
- **Flat structure** — no dependencies, just a linear checklist
- **Single-session** — sub-agents had no idea what the main agent was working on
- **No coordination** — multiple Claude Code sessions couldn't share state

---

## What Makes Tasks Different

### 1. File System Persistence

Tasks live in `~/.claude/tasks/`. Close Claude Code, come back later — tasks are still there. They're just files, so you can build your own utilities on top of them.

### 2. Dependency Support

Real projects aren't flat lists. Tasks let you define relationships:
- Task C can't start until Task A and Task B are done
- Task D depends on Task C, but Task E doesn't
- Dependencies are stored in task metadata

### 3. Cross-Session Collaboration

**The big one.** Multiple sub-agents and Claude Code sessions can work on the same task list. When one session updates a task, the change broadcasts to all others.

**Parallelization example:**
- Sub-agent 1 → auth system
- Sub-agent 2 → database schema
- Sub-agent 3 → tests
- All see the same task list, no duplicate work, no stepping on toes

---

## Tasks vs. Ralph Wiggum Loop

| | Ralph Wiggum Loop | Tasks |
|---|---|---|
| **Mechanism** | Stop hook intercepts exit, reinjects prompt | Native task management system |
| **Scope** | Single task in a loop | Multiple tasks with dependencies |
| **Sessions** | Single session | Multi-session coordination |
| **Status** | Community hack (clever but fragile) | Official Claude Code feature |
| **Philosophy** | "Keep going until done" | Same philosophy, proper architecture |

Tasks are the **official, architectural evolution** of what Ralph was trying to do.

---

## Sharing Tasks Across Sessions

Set the environment variable:

```
CLAUDE_CODE_TASK_LIST_ID=my-project-name
```

All Claude Code sessions started with the same ID will see and update the same tasks. Works with:
- Regular Claude Code sessions
- `claude -p` (CLI mode)
- Agent SDK

---

## Recommended Workflow

1. Define project requirements
2. Ask Claude to break it down into tasks with proper dependencies
3. Spin up multiple sub-agents on independent branches of the task tree
4. Each sub-agent works in its own context window but sees the shared task list
5. When one finishes, others see the update and can start previously-blocked tasks

---

## When to Use Tasks

- **Skip for small work** — refactoring a function, fixing a bug. Just ask Claude directly.
- **Use for large projects** — full features across multiple files, large refactors, test suite creation, anything needing coordination.

---

## What Ralph/Ralphie Still Offer

- **Ralph Wiggum loop** — still useful for single-minded "don't stop until done" behavior
- **Ralphie** — still useful for git work tree isolation and automatic PR creation
- **Core task coordination** — now handled natively by Tasks

---

## Current Limitations

1. **Sparse documentation** — announced on X, minimal official docs
2. **No visual dashboard** — tasks visible in terminal (Ctrl+T to toggle), but no dependency graph or progress view
3. **Environment variable sharing is clunky** — would be better as a slash command (e.g., `/tasks share project-name`)
