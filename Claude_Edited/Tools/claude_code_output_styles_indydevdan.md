# Claude Code Output Styles Are Here — Don't Miss This Trend

**Source:** IndyDevDan — [YouTube](https://youtu.be/mJhsWrEv-Go)
**Date:** 2025-08-18 | **Duration:** 31 minutes
**Companion repo:** [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery)

---

## Core Thesis

Output styles and status lines **increase the information rate** between you and your agent. Output styles make agents *better*. Status lines help you manage *more* agents.

**The Big Three** (every agentic system): **Context, Model, Prompt.** Master these and you can move between tools at light speed. Output styles update the **system prompt** — that's all they do under the hood.

---

## Six Output Styles

| Style | Format | Best For |
|-------|--------|----------|
| **Default** | Standard Claude Code markdown | General use |
| **Table** | Clean formatted tables | Organizing structured information |
| **YAML** | Highly structured key-value | Best agent performance — outperforms other formats |
| **Ultra Concise** | Minimal text, just enough info | Reducing token consumption |
| **Text-to-Speech** | Audio summary via 11 Labs | Parallel multi-agent workflows — hear when agents finish |
| **HTML (GenUI)** | Full rendered HTML page | Generative UI — the most important format |

### YAML Performance Note

Dan found the YAML output format **typically outperforms the rest** in agent task completion quality. The highly structured format appears to improve the agent's reasoning.

### Ultra Concise Token Savings

The ultra concise format **reduces input and output tokens** Claude Code consumes — useful for cost management on long sessions.

---

## Generative UI (HTML Output Style)

The HTML output style is **"the one format to rule them all."** What it does:

1. Agent generates dynamic, accurate HTML on the fly
2. Writes to a temporary file
3. Opens it in browser at end of response
4. You get a **rich visual interface** instead of terminal text

**This is the first useful application of generative UI** — agents responding in actual user interface, not just text.

### GenUI Demos

- **Hook documentation** — full styled HTML guide with project structure, code samples, next steps
- **Hacker News sentiment analysis** — top 5 posts with points, validated against live data
- **TypeScript interface generation** — typed interfaces from JSON structure with hierarchy breakdown
- **Hook model visualization** — complete breakdown of all 8 hook event types with UI

### Extending GenUI

You can add **conditional branches** directly in your output style system prompt to direct which output type the agent uses based on the prompt. For example: questions get HTML guides, code requests get YAML, status checks get tables.

---

## Status Lines — Managing Multiple Agents

When running 3, 5, or 10 Claude Code instances in parallel, status lines tell you **what each instance is doing** at a glance.

### Version Progression

| Version | Shows | Use Case |
|---------|-------|----------|
| **V1** | Model, CWD, git branch, uncommitted changes, CC version | Minimal static info |
| **V2** | Model + **last executed prompt** | Know what each instance is working on |
| **V3** | Model + **trailing prompt history** (3 most recent) + **agent name** | Full multi-agent orchestration |
| **V4** | Left as exercise | Further customization |

### How Status Lines Work

1. A Python script reads session data from a JSON file
2. It generates a formatted string
3. It **prints** the string — that's it
4. Claude Code reads the printed output and displays it

**Configuration:** Add the status line script path to your `.claude/settings.json` file.

### Hook-Powered State Management

The status line data comes from a **UserPromptSubmit hook** that:

1. Records every prompt to a session-specific JSON file
2. Generates a unique agent name via a **local Ollama model** (5-second timeout with fallback)
3. Stores session ID, agent name, and prompt history
4. Status line script reads this JSON to display current state

**Key insight:** Hooks + simple JSON state management + status lines = powerful multi-agent orchestration. Each prompt contributes to agent-specific data that persists across the session.

---

## Controversial Features Critique

Dan critiques two Claude Code features as potential **directional missteps**:

### 1. Opus Plan Mode (`/model opus plan`)

- Plans with Opus, builds with Sonnet
- Similar to Aider's "architect mode" from 2024 (prompt chain with two models)
- **Dan's concern:** Claude Code should let the engineer decide which models to use and how. This inserts an opinion about model management.

### 2. Background Bash Commands

- **Dan's concern:** Don't tell engineers how to manage their bash processes. Let them control it.

### The Guiding Question

> "Do I know exactly what the context, model, and prompt are at every step of the process?"

Any feature that **obscures** the Big Three or **inserts an opinion** about how to manage them is a red flag. A feature can be individually useful but **directionally incorrect** for the product's philosophy of being an unopinionated engineering primitive.

**Nuance:** Dan acknowledges both features are useful. His concern is about product direction, not individual feature value.

---

## Key Principles

- **"Better agents or more agents"** — the only two directions to go with agent coding tools
- **Output styles = better agents** (higher quality responses, richer information)
- **Status lines = more agents** (track what each instance is doing)
- **Never bet on your first reaction** without doing the work to understand a feature
- **Cloud Code is a primitive** — an unopinionated engineering building block, not a dedicated solution
- The `/quest` question prompt pattern is valuable for **priming agents** while getting information you need for engineering decisions

---

## Implementation Details

### Output Style Setup

Output styles are stored in `.claude/output-styles/` directory. Each style is a system prompt fragment. Switch styles with `/output-style <name>`.

### Status Line Setup

```
.claude/
├── status-lines/
│   ├── v1/main.py    # Minimal: model, CWD, branch
│   ├── v2/main.py    # + last prompt
│   ├── v3/main.py    # + trailing prompts + agent name
│   └── v4/main.py    # Custom
├── data/
│   └── sessions/     # JSON session state per instance
└── settings.json     # Points to active status line script
```

### Hook Integration

The `UserPromptSubmit` hook fires on every prompt and:
- Appends the prompt text to the session's JSON data
- If no agent name exists, calls a local Ollama model to generate one
- Session data is read by the status line script on each render
