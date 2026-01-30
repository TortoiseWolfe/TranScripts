# I finally CRACKED Claude Agent Skills (Breakdown For Engineers)

**Source:** IndyDevDan — [YouTube](https://youtube.com/watch?v=kFpLzCVLA20)
**Date:** 2025-10-27 | **Duration:** 27 minutes

---

## Overview

After a week wrestling with agent skills, IndyDevDan breaks down **when to use skills vs MCP servers vs sub-agents vs custom slash commands**. Demos building a git worktree manager skill to show the right compositional approach.

---

## The Core 4 Features Compared

| Capability | Skills | MCP Servers | Sub-Agents | Slash Commands |
|-----------|--------|-------------|------------|----------------|
| **Triggering** | Agent-invoked (automatic) | Agent-invoked | Agent-invoked | Manual (you invoke) |
| **Context efficiency** | High (progressive disclosure) | Low (explodes context on bootup) | High (isolated) | Depends on prompt |
| **Context persistence** | Yes | Yes | **No** (lost after completion) | Yes |
| **Modularity** | High (dedicated directory structure) | High (dedicated solution) | Low (roll your own) | Low (roll your own) |
| **Composability** | Can use prompts, other skills, MCP, sub-agents | Lower-level unit | Cannot use other sub-agents | Can run skills, MCP, sub-agents |

---

## When to Use Each Feature

### Skills — Automatic Behavior
- **Automatically** extract text from PDFs
- Detect style guide violations
- Any **repeat behavior** you want the agent to trigger on its own

### MCP Servers — External Integrations
- Connect to **Jira**
- Query your **database**
- Fetch real-time **weather data** from APIs
- Bundle multiple external services together

### Sub-Agents — Isolated Parallel Workflows
- Run comprehensive **security audits**
- Fix and debug **failing tests at scale**
- Any task where you want **parallelization** and are okay **losing context** afterward

### Custom Slash Commands — Manual Triggers
- Generate **commit messages**
- Create a **UI component** (one-off task)
- Simple, one-step tasks you invoke explicitly

> **Key word: "parallel" → always think sub-agents.** Nothing else supports parallel calling.

---

## The Wrong Way to Use Skills

Dan demos three approaches to creating git worktrees — skill, sub-agent, and slash command — all accomplishing the same job.

**The mistake:** Converting all slash commands to skills. Many engineers are going all-in on skills and abandoning prompts.

> "If you can do the job with a sub-agent or custom slash command and it's a one-off job, **do not use a skill.** This is not what skills are for."

---

## The Right Way: Compositional Hierarchy

### The Prompt Is the Primitive

> "The prompt is the fundamental unit of knowledge work and of programming. If you don't know how to build and manage prompts, you will lose."

**Always start with a custom slash command.** Then compose upward:

1. **Slash command** (prompt) — the base unit
2. **Sub-agent** — when you need to parallelize, compose a prompt inside
3. **Skill** — when you need to **manage** a problem set (not just execute one task)

### When to Upgrade to a Skill

- **One prompt** → creating a git worktree (slash command is fine)
- **Managing worktrees** (create, remove, list, merge) → **skill**
- The trigger: when **one prompt is not enough** and you want a reusable solution for a problem set

### Skills Are Compositional Units

Skills should **contain** slash commands, sub-agents, and MCP servers — not replace them. Dan's worktree manager skill internally calls slash commands to do the actual work.

---

## The Core 4 of Agentic Coding

Every agent comes down to four pieces:

1. **Context** — what the agent knows
2. **Model** — which LLM
3. **Prompt** — the instructions
4. **Tools** — what the agent can do

> "If you master the fundamentals, you'll master the compositional units, you'll master the features, and then you'll master the tools."

---

## Skills: Progressive Disclosure (Context Efficiency)

Three levels of context loading:

1. **Metadata level** — skill name and description only
2. **Instructions** — the skill.md file content
3. **Resources** — additional files pulled in only when needed

Unlike MCP servers which load everything into context on bootup, skills load incrementally.

---

## All Claude Code Features Defined

| Feature | Purpose |
|---------|---------|
| **Agent Skills** | Package custom expertise for agent-invoked reoccurring workflows |
| **MCP Servers** | Connect agents to external tools and data sources |
| **Sub-Agents** | Delegate isolatable specialized tasks with separate contexts (parallelizable) |
| **Custom Slash Commands** | Reusable prompt shortcuts you invoke manually |
| **Hooks** | Deterministic automation at specific lifecycle events |
| **Plugins** | Package and distribute Claude Code extensions |
| **Output Styles** | Custom formatting for agent responses (text-to-speech, diff summaries, etc.) |

---

## Pros and Cons of Agent Skills

### Pros
- **Agent-invoked** — delegates more work autonomously
- **Context protection** — progressive disclosure prevents context window bloat
- **Dedicated file system pattern** — logically compose and group skills
- **Composable** — can use MCP, sub-agents, slash commands, other skills
- **Agentic approach** — agent just does the right thing

### Cons
- **Doesn't go all the way** — can't nest `/commands` or `/agents` directories inside skill bundles
- **Reliability unclear** — will agents correctly chain 5 skills back-to-back in production?
- **Not much actual innovation** — effectively "opinionated prompt engineering + modularity" that you could already build with slash commands + slash command tool

**Dan's rating:** 8 out of 10

---

## Composition Hierarchy

```
Skills (top level — compositional manager)
├── Custom Slash Commands (prompts — the primitive)
├── Sub-Agents (parallel/isolated work)
├── MCP Servers (external integrations)
└── Other Skills
```

> "Skills at the top of the composition hierarchy... but an MCP server is a lower-level unit — you wouldn't have an MCP server use a skill."

---

## Key Takeaways

- **Don't convert all slash commands to skills** — that's a huge mistake
- **Start with a prompt** (slash command), then compose upward as needed
- **Skills are for managing problem sets**, not one-off tasks
- **The prompt is still the most important primitive** — don't give it away to complex abstractions
- **Use all four features together** — if you're only using one, you're not using Claude Code properly
- **Meta-skill pattern:** Build the thing that builds the thing
