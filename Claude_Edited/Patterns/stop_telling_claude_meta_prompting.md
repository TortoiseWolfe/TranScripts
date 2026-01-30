# Stop Telling Claude Code What To Do — Meta-Prompting

**Source:** TÂCHES TEACHES (Tash) — [YouTube](https://youtu.be/8_7Sq6Vu0S4)
**Date:** 2025-11-13 | **Duration:** 30 minutes
**Prompts:** [GitHub](https://github.com/glittercowboy/taches-cc-prompts)

---

## The Core Idea: Meta-Prompting

Instead of telling Claude what to do directly, first ask Claude to **create an optimal prompt** for the task. Then run that prompt in a **fresh sub-agent** with a clean context window.

**Why:** Direct prompting leads to assumptions, misalignments, and incomplete implementations. Meta-prompting forces Claude to think about what it needs to know before executing, producing more structured and thorough results.

**When to use:** Complex multi-file changes, refactoring, database migrations, multi-step features. **Not needed** for simple changes (swap a color, change a font).

---

## Two Custom Commands

### `/create-prompt` — The Prompt Engineer

A custom slash command that acts as an expert prompt engineer. It takes your rough description and produces a structured, XML-tagged prompt file.

**Core Process:**

1. **Clarity Check** — Analyzes whether your request is clear enough
2. **Complexity Assessment** — Single file or multi-file? One prompt or multiple? Sequential or parallelizable?
3. **Reasoning Depth** — Does it need to examine codebase structure, dependencies, or patterns?
4. **Verification Needs** — Does this task warrant built-in error checking?
5. **Clarification (if needed)** — Asks specific questions about ambiguous aspects
6. **Confirmation** — Presents its analysis and asks to proceed
7. **Prompt Generation** — Creates structured prompt(s) saved to a `/prompts` folder

**Prompt Construction (XML Tags):**

Every generated prompt includes:
- **Objective** — what needs to be done
- **Context** — why it matters, who it's for, what it's used for
- **Requirements** — specific needs and constraints
- **Implementation** — technical approach, what to avoid
- **Output** — expected deliverables
- **Success Criteria** — how to define completion
- **Verification** — how to prove it worked

**Conditional Inclusions:**
- "Thoroughly analyze" / "deeply consider" — triggers extended thinking
- "Go beyond basics" / "impress" — pushes Claude past bare minimum (especially useful for UI)
- Parallel tool calls if tasks are independent
- Explicit file references, bash commands, MCP servers needed

**Multiple Prompts:** If the task is complex, it creates numbered files (`001-setup.md`, `002-feature.md`, etc.) and determines whether they should run sequentially or in parallel.

### `/run-prompt` — The Executor

Executes saved prompts as **delegated sub-agent tasks** with fresh context windows.

- **Single prompt** — launches one sub-agent
- **Sequential prompts** — runs them one after another
- **Parallel prompts** — launches multiple sub-agents simultaneously
- Completed prompts are moved to a `completed/` subfolder

**Why sub-agents matter:** The prompt creation process pollutes the current context with reasoning about *how* to structure the prompt. The actual prompt is self-contained — running it in a fresh sub-agent gives it maximum context window for execution.

---

## Side-by-Side Demo: Generative Music CLI

### Without Meta-Prompting (One-Shot)
- Claude immediately starts building
- No clarifying questions asked
- Result: 286-line monolithic `index.js`
- Buggy, clicking audio artifacts, minimal visual polish
- Functional but "a bit crappy"

### With Meta-Prompting
- Claude asks 5 clarifying questions (audio library, visual rendering, note sequencing, runtime, dependencies)
- Produces structured prompt with objectives, context, requirements, what to avoid, success criteria, verification steps
- Result: modular project — 63-line `index.js` entry point + separate `src/audio.js` and `src/visuals.js`
- Includes a README
- Structured randomness, pleasing audio, proper visual rendering

### Enhancement Round (Adding Fractals + FM Synthesis + Scale Selection)
- One-shot: more bugs, visual glitches, partially working
- Meta-prompted: asks about fractal style (Mandelbrot vs spirals), FM synthesis approach, visual indicator placement, scale options — then produces a clean prompt with all decisions baked in

---

## Intelligence Rules (Built Into the Command)

- **Clarity first** — always ask before proceeding if unclear
- **Context is critical** — include why, who, and what in every prompt
- **Be explicit** — specify exact formats, files, and expected outputs
- **Precision over brevity** — long and clear beats short and ambiguous
- **Scope assessment** — simple tasks get simple prompts; complex tasks get comprehensive ones
- **Tool awareness** — reference available MCP servers, bash commands, file paths
- **Success criteria** — every prompt must define how to verify completion

## Key Takeaway

Meta-prompting is overkill for trivial changes, but essential for substantial work. The technique forces Claude to think about what information it needs, produces modular rather than monolithic code, and includes built-in verification. The clarifying questions also help *you* refine what you actually want.
