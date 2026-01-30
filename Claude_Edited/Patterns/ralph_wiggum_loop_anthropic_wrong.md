# I Can't Believe Anthropic Messed Up The Ralph Wiggum

**Source:** Better Stack — [YouTube](https://youtu.be/XVAhQ-EcrWA)
**Date:** 2026-01-21 | **Duration:** 8 minutes
**Creator:** Geoff Huntley (original Ralph Wiggum Loop)
**References:** [Ralphy script](https://github.com/michaelshimeles/ralphy) | [Loom project](https://github.com/ghuntley/loom) | [Model degradation paper](https://arxiv.org/html/2502.05167v3)

---

## What Is the Ralph Wiggum Loop?

A **bash while loop** that gives an AI agent the exact same prompt over and over again. Created by Geoff Huntley (June 2025). The genius: it forces the agent to work in its **smartest mode** — with as little context as possible.

## Why It Works: Context Window Degradation

The context window has performance zones:

| Zone | Context Used | Performance |
|------|-------------|-------------|
| **Smart zone** | 0–30% | Best performance |
| **Good zone** | 30–60% | Still performs well |
| **Dumb zone** | 60%+ | Starts to degrade |

For Claude Sonnet/Opus (200k tokens):
- **First 60k tokens** — smart zone
- **Next 60k tokens** — still OK
- **Last 80k tokens** — degraded performance

**Why:** Models are autoregressive — they must scan all previous tokens to predict the next one. More tokens = harder to find the relevant bits.

### What Eats Your Context Before You Even Prompt

- **System prompt:** ~8.3% of context
- **System tools:** ~1.4% of context
- **Skills, MCP tools, CLAUDE.md** — all added automatically

**Takeaway:** Keep your CLAUDE.md lean, minimize tools and skills to preserve the smart zone.

## The Canonical Ralph Loop

```bash
while true; do
  cat prompt.md | claude --dangerously-skip-permissions
done
```

### How It Works

1. Write a `prompt.md` that instructs the agent to:
   - Inspect the `plan.md` file for tasks
   - Pick the most important undone task
   - Make changes, run tests, commit
   - Mark the task as done in `plan.md`
2. The bash loop **restarts Claude with a fresh context** for each iteration
3. Each new task gets the **full smart zone** — no accumulated context bloat

### Key Properties

- **One goal per context window** — the entire 200k is dedicated to a single task
- **Outside the model's control** — the model can't stop the loop; only you can
- **Fresh context every iteration** — no compaction, no accumulated cruft
- **Can run indefinitely** — even after all tasks are done, it may find things to fix or improve
- **Human on the loop** — you can stop anytime, adjust `prompt.md`, and restart

## Why Compaction Is Not the Answer

Compaction = the agent picks what it thinks is important from the context and discards the rest. The problem: **it doesn't know what's actually important**. Critical information can be lost, causing unexpected project failures.

## Flawed Implementations

### Anthropic's Plugin (Incorrect)

- Runs Ralph as a **slash command inside Claude Code**
- **Compacts context** between tasks instead of resetting it — loses vital information
- Has **max iterations** and a **completion promise** — limits the loop's ability to find additional fixes

### Ryan Carson's Approach (Incorrect)

- On each loop iteration, **adds to the agents.md file**
- Since agents.md loads into context at the start of every prompt, this **grows the context window** with each iteration
- Models are wordy by default — the file balloons, pushing into the dumb zone

## Notable Variants (Good Adaptations)

- **Ras Mic's Ralphy:** Supports **parallel Ralphs** and browser testing via Vel's agent browser tool
- **Matt Pocock's version:** Uses **GitHub issues** as tasks — the loop picks the most important issue, works it, marks it done
- **Geoff Huntley's Loom/Weaver:** Aims for fully autonomous, correct software creation

## Key Takeaways

- The canonical Ralph loop is a **simple bash while loop** — its power comes from **fresh context per task**
- Don't compact between iterations — that defeats the entire purpose
- Don't grow the context file between iterations — same problem
- Keep your CLAUDE.md and tool surface minimal to maximize the smart zone
- Let the loop run indefinitely with a human watching — you'll discover patterns and improvements
