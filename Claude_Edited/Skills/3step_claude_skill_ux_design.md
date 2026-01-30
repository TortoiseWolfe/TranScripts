# My 3-Step Claude Skill for Perfect UX Design

**Source:** Sean Kochel — [YouTube](https://youtu.be/nDHXLnwlIaY)
**Date:** 2026-01-12 | **Duration:** 18 minutes

---

## The Problem: Vanilla AI UIs

- Most builders skip the UX planning step and jump straight into coding with AI
- The result is functional but generic, "vanilla" interfaces that feel unpolished
- Every minute saved by skipping planning costs ~10 minutes of rework later

## The 3-Step Skill Workflow

### Step 1: Create the PRD (Product Requirements Document)

**What most people do** — and it's a good starting point, but not enough on its own.

- Define **features**, **target users**, **general flow**, and **success criteria**
- Start with an MVP concept document (markdown file in the project)
- Run a custom slash command (e.g., `/demo-prd`) pointing at the MVP file
- Output: a structured PRD that defines *what* you're building

**The gap:** A PRD tells you what to build, but leaves massive ambiguity about *how users experience it*. Any problem has dozens to thousands of possible UX solutions.

### Step 2: Define the User Experience (The Step Most Builders Skip)

This is the critical missing piece. The approach mimics how world-class product organizations actually build software.

**The UX skill runs through progressive passes, each building on the last:**

1. **Mental Model Alignment** — What does the user *think* is happening as they approach this feature? Research your ideal user and put yourself in their shoes.

2. **Information Architecture** — What concepts, elements, and data exist in the app? How is it all organized and displayed cohesively?

3. **Affordance and Action** — How do you make available actions *clear* to users? What looks clickable, editable, or interactive? What visual signals indicate state?

4. **System Feedback** — How does the system respond across all states: empty, loading, populated, incomplete data, errors?

**Why this matters:** If you don't specify these decisions, the LLM makes them at build time — and it cuts corners. It will simply skip considerations you didn't explicitly request.

**Output:** A full UX specification document covering every major feature from the PRD.

### Step 3: Generate the Build Order

- Tools like Google Stitch, Replit Designer, or Polymet struggle with large context dumps
- This skill translates the PRD + UX spec into a **sequenced series of prompts**
- Each prompt handles one piece: design tokens, layout shell, then feature-by-feature details
- You paste prompts one-by-one into your prototyping tool

**Output:** A build order document specifying the entire build sequence from design tokens through layout to detailed features.

## Execution: Prompt-by-Prompt Building

1. Start with the **layout shell** prompt — base navigation and structure
2. Work through each subsequent prompt **one by one**
3. Each prompt adds a specific layer of functionality and UX detail
4. The progressive approach ensures each piece gets proper attention

## Tools Mentioned

- **Polymet** — Sean's preferred prototyping tool for functional prototypes
- **Google Stitch** — works but needs either very vague or very specific prompts
- **Replit Designer** — another option for mockups
- **Claude Code** — runs the slash command skills that generate the documents

## Results: Before vs After

**Without UX planning (PRD only):**
- Functional but generic
- Vanilla aesthetic, no personality
- Missing interaction details and progressive disclosure
- Built with Claude planning mode + Next.js + Tailwind + "clone Claude aesthetic"

**With the 3-step workflow:**
- Professional, cohesive feel
- Clear visual signals for user actions (drag-and-drop, clickable elements)
- Progressive disclosure (double-bracket dropdowns, expandable node configs)
- Polished state handling (loading animations, data flow visualization)
- Every element feels intentional and purposefully placed

## Key Takeaway

The difference between amateur and professional AI-built UIs isn't the coding tool — it's the **specificity of your UX planning**. Vagueness produces vanilla. Detailed UX specs produce polished, intentional interfaces. Codify the UX planning process into Claude Skills so you never skip it.
