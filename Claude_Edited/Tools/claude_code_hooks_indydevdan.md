# I'm HOOKED on Claude Code Hooks: Advanced Agentic Coding

**Source:** IndyDevDan — [YouTube](https://youtube.com/watch?v=J5B9UGTuNoM)
**Date:** 2025-07-07 | **Duration:** 30 minutes

---

## Overview

IndyDevDan builds a full observability and control stack for Claude Code using hooks. Demos blocking dangerous commands, text-to-speech notifications, chat log capture, and sub-agent completion alerts — all powered by UV single-file Python scripts.

---

## The 5 Claude Code Hooks

| Hook | When It Fires | Primary Use |
|------|--------------|-------------|
| **Pre-tool use** | Before any tool runs | **Control** — block dangerous commands |
| **Post-tool use** | After a tool runs | **Observability** — logging, recording |
| **Notification** | When Claude Code needs user input | **Alerts** — notify you to approve permissions |
| **Stop** | When Claude Code finishes responding | **Observability** — dump full chat transcript |
| **Sub-agent stop** | When a sub-agent completes its task | **Alerts** — per-agent completion notifications |

---

## Two Killer Use Cases

### 1. Control (Pre-tool Use)

Block commands you never want an agent to run:

- **`rm -rf`** and all remove patterns → completely blocked
- **`.env` file access** → agent cannot read environment variables

The pre-tool use hook analyzes the incoming tool name and input, then blocks before execution happens.

### 2. Observability (Post-tool Use + Stop)

Generate structured log files from every Claude Code interaction:

- **Pre-tool use log** — every tool name + input parameters
- **Post-tool use log** — results after execution
- **Stop log** — includes full **transcript path** to dump the entire chat conversation
- **Sub-agent stop log** — individual sub-agent completion data

> "If you don't measure it, you can't improve it. We need to measure the output."

---

## Text-to-Speech Notifications

Claude Code gets a **voice** via hooks:

- **Stop hook** → announces "All set and ready for your next step"
- **Sub-agent stop** → announces each sub-agent completion individually
- **Notification hook** → announces "Your agent needs your input"

Powered by:
- **ElevenLabs** for voice synthesis
- **Anthropic/OpenAI** LLMs to generate natural language completion messages
- Each runs as an isolated UV single-file Python script

> Great for long-running async jobs — go AFK, agents work in background, you hear when they finish.

---

## Setup: settings.json

Hooks live in the `hooks` block of Claude Code's `settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [{ "matcher": {}, "command": "uv run hooks/pre_tool_use.py" }],
    "PostToolUse": [{ "matcher": {}, "command": "uv run hooks/post_tool_use.py" }],
    "Notification": [{ "matcher": {}, "command": "uv run hooks/notification.py --notify" }],
    "Stop": [{ "matcher": {}, "command": "uv run hooks/stop.py --chat" }],
    "SubAgentStop": [{ "matcher": {}, "command": "uv run hooks/sub_agent_stop.py" }]
  }
}
```

Key details:
- Each hook type is an **array** (can have multiple hooks)
- **Matchers** filter which tools trigger the hook (empty = match all)
- **Commands** can be any executable — Python, Bun/TS, shell scripts
- Hooks directory lives inside `.claude/hooks/`

---

## UV Single-File Python Scripts

**Astral's UV** is the key enabler:

- Each hook is a **standalone Python file** with dependencies declared inline
- `uv run script.py` auto-installs dependencies and executes
- **No external code needed** — completely isolated from your codebase
- Perfect for hooks because they're sandboxed and portable

### Pre-tool Use Script Pattern

```python
# Read input from stdin (JSON)
# Check tool_name against blocked patterns
# Check tool_input for .env access
# Write to log file
# Output block/allow decision
```

---

## Parallel Sub-Agents Demo

Dan runs a custom slash command that kicks off **4 parallel sub-agents**, each reading a different log file and generating TypeScript interface definitions.

Each sub-agent fires the **sub-agent stop hook** individually → text-to-speech announces completion one at a time → you hear progress without watching the terminal.

---

## The Big Three (Core Principle)

> "Context, model, prompt. This never goes away."

Hooks give you **observability into the Big Three**:

- See what **context** your agent has (via chat transcript dump)
- See what **tools** are being called (via pre/post-tool logs)
- See what **prompts** sub-agents receive (via task description in logs)

> "Agentic coding is just a superset of AI coding. We have one tool versus many. But the principle never goes away."

---

## Claude Code as Engineering Primitive

Why Dan calls Claude Code the most important tool of 2025:

- **Custom slash commands** — reusable prompts
- **Hooks** — deterministic behavior in the agent lifecycle
- **Programmable mode** (`claude -p "hello"`) — scriptable from other tools
- **Sub-agents** — agents prompting agents

> "Cloud Code is the first programmable agentic coding tool."

---

## Boris & Cat Leave Anthropic for Cursor

Dan's analysis of why the Claude Code creators joined Anysphere (Cursor):

| Probability | Reason |
|------------|--------|
| **75%** | Compensation — name your price when you've built the best agent tool |
| **10%** | Creative control — building advanced agent features at Cursor |
| **10%** | Time to move on |
| **5%** | Cloud Code may not be defensible — "the secret is out" on agent architecture |

> "Whenever someone copies your work, that means you're doing something right. The Gemini CLI and COC CLI are signs from Anthropic's competitors."

---

## Key Takeaways

- **Pre-tool use hooks** are your safety net — block `rm -rf`, `.env` reads, anything dangerous
- **Post-tool use + stop hooks** give you the observability agents desperately need
- **Text-to-speech** is the missing UX layer for unattended long-running jobs
- **UV single-file scripts** are the ideal hook implementation — isolated, portable, auto-install deps
- **Dump the full chat transcript** on stop for analysis and improvement
- **Observability is everything** — "how well you can observe, iterate, and improve your agentic system is a massive differentiating factor"
- **Engineering foundations matter more than ever** — isolated, reusable, testable code
