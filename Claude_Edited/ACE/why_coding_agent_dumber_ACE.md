# Why Your Coding Agent Keeps Getting Dumber

**Source:** Agentic Lab (Roman) — [YouTube](https://youtu.be/XQWOdQ8GM4w)
**Date:** 2026-01-10 | **Duration:** 11 minutes
**Reference Paper:** [Agentic Context Engineering (ACE) — Stanford](https://arxiv.org/pdf/2510.04618)

---

## The CLAUDE.md Trap

- Most developers treat CLAUDE.md as a **growing playbook** — every time something goes wrong, they add a new rule
- This loads into **every conversation**, causing **context rot** as the file grows past ~100 lines
- Model performance **quietly degrades** as irrelevant rules pollute the context window

## The Naive Fix: Periodic Compaction

- Having the LLM summarize or consolidate the CLAUDE.md seems logical but creates two problems:
  1. **Information loss** — patterns are gradually stripped as the model compresses into fewer tokens
  2. **Context collapse** — each rewrite carries a small chance (~3%, increasing ~0.25% per iteration) of catastrophic rewrite where the file gets reduced to ~100-200 tokens of garbled content

- After collapse, accuracy can drop **below baseline** — meaning the condensed file performs **worse than having no file at all** (called **context pollution**)

## The Better Approach: Keep CLAUDE.md Lean

- Roman's CLAUDE.md is **3-5 lines** — only permanent, globally useful truths
- Example: "Always launch Opus agents as sub-agents"
- Reserve CLAUDE.md for things that apply to **every single session**

## Agentic Context Engineering (ACE)

ACE is a **RAG-based playbook system** from a Stanford paper. Instead of stuffing everything into one file, it dynamically retrieves relevant context per task.

### Three-Model Flow

**1. Generator (Builder)**
- Receives the coding task
- Semantically searches a **vector database** for relevant "bullets" (if-then rules)
- Retrieves top-k most relevant bullets
- Executes the task with bullets injected into context (like RAG)
- Outputs: changed code, execution trace, bullet IDs used

**2. Reflector (Analyzer)**
- Analyzes execution traces from the generator
- Extracts new lessons as **bullet candidates** (if-then statements)
- Can self-refine through multiple passes for cleaner bullets
- Flags which existing bullets were helpful or harmful

**3. Curator (Database Manager)**
- Embeds new bullets and adds them to the vector database
- Deduplicates against existing bullets (similarity check)
- Updates **helpful/harmful vote counts** on existing bullets
- Bullets that accumulate enough negative votes (e.g., -3) get **dropped from the database**

### Bullet Structure

Each bullet contains:
- **ID** — unique identifier
- **Content** — the if-then rule
- **Embedding** — for semantic search
- **Helpful count** — positive votes from generator
- **Harmful count** — negative votes from generator

### Key Difference from CLAUDE.md

- Claude **cannot rewrite the whole playbook** — prevents catastrophic collapse
- Only individual bullets get added, voted on, or removed
- The system **self-improves** with each task cycle

## Where ACE Works Best

ACE requires **evaluable outcomes** — it needs clear signals about what worked:

- **Binary signals (strongest):** Test-driven development, API integrations — tests pass or fail, calls succeed or error
- **LLM-as-judge:** Model evaluates output quality
- **Human-as-judge:** Manual review (e.g., animation quality)

## The Poisoning Problem

ACE is vulnerable to **misdiagnosis**:

1. Generator runs a task at 60fps, crashes for an **unrelated reason**
2. Reflector misdiagnoses: "60fps caused the crash — use 30fps instead"
3. Curator adds bullet: "Use 30fps for complex scenes"
4. Future tasks retrieve this bullet, which now **contradicts** the CLAUDE.md rule requesting 60fps
5. **Context clash** degrades output below baseline
6. No-crash result reinforces the bad bullet as "helpful"

**Mitigation:** Requires human oversight to catch and clear conflicting bullets from the database.

## Key Takeaways

- **CLAUDE.md** = permanent truths, always present, keep it lean (under 5-10 lines)
- **ACE playbook** = dynamic, evolving, task-specific context retrieved via semantic search
- **Claude Skills** are useful but less deterministic — not always called even when requested
- ACE is generalizable beyond CLAUDE.md — works for teaching models animation, specific tech stacks, etc.
