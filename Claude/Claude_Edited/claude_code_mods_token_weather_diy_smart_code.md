# Claude Code Just Got a Massive Update — Mods (token weather, blast radius, replay theater) — DIY Smart Code
Source: https://youtu.be/tTe7GOJuc0E
Speaker: DIY Smart Code · YouTube Short, published Oct 2, 2026 · ~2.6 min

> A 2.5-minute briefing on **Claude Code mods**: small TypeScript functions, shipped inside plugins, that hook into the events Claude Code emits and can run **before, after, or instead of** them. Unlike hooks, they can rewrite events, draw new UI, and replace built-in features. Covers three of Anthropic's example mods, the plan to turn built-in features into mods, and the security catch: **mods are not sandboxed**.

> **Related:** Mods extend the same surface as [[claude_code_hooks_indydevdan]] (event hooks that can only observe or block) and can replace the shell-script approach to [[claude_code_terminal_status_line]]. Mods ship inside plugins, so the install pattern in [[cracked_claude_agent_skills_indydevdan]] applies.

> ⚠️ **Sourcing note:** captions are YouTube auto-generated (ASR) and the whole transcript is the creator's summary of Anthropic's guide, not the guide itself. The percentages, file counts and sizes are Anthropic's demo figures as relayed in the video, not benchmarks. [REVIEW: the "Related" cross-links are editorial, not stated in the video.]

---

## [0:00](https://youtu.be/tTe7GOJuc0E?t=0) What Mods Are

- Anthropic shipped **mods** for Claude Code. **A few lines of TypeScript** change how Claude Code behaves.
- Three demos: a readout of **how full your context is**, a guard that **stops the delete command before it runs**, and a replay of **every edit** Claude just made.
- **Hooks could not** rewrite events, draw new UI, or replace built-in features. **Mods can.**

## [0:19](https://youtu.be/tTe7GOJuc0E?t=19) How a Mod Works — Events and a Middleware Chain

- Every time Claude Code does something it **emits an event**: calling a tool, asking for permission, drawing part of the screen.
- A mod is **one function hooked into that event**. It can run **before** it, **after** it, or **instead of** it.
- Mods form a **chain, like middleware**: yours runs, **hands the event on**, and at the bottom Claude Code does what it would have done anyway.

## [0:40](https://youtu.be/tTe7GOJuc0E?t=40) Example 1 — Token Weather (~80 lines)

- Anthropic's first example. A **band above the prompt** turns the context window into a **forecast**.
- One small file: **clear at 18%**. Four big files: **showers at 67%**. One more: **storm at 81%** — the signal to **wrap up the session**.

## [1:02](https://youtu.be/tTe7GOJuc0E?t=62) Example 2 — Blast Radius

- Ask Claude to delete the build folder and the mod **holds the command**.
- It **lists what it would remove** (the nine files, 1.1 MB in the demo) and **waits**.
- **Press 2:** Claude receives a **refusal with the reason**. **Press 1:** the command runs.

## [1:18](https://youtu.be/tTe7GOJuc0E?t=78) Example 3 — Replay Theater

- **Captures every edit in a turn.** Demo: Claude renamed a function across **three files in five edits**.
- **Press R** and a pane **steps through each diff, one at a time**.

## [1:30](https://youtu.be/tTe7GOJuc0E?t=90) Built-ins Are Becoming Mods

- Claude Code's own **`/diff` pane is now a mod**, and so is its **`AGENTS.md` support**. [REVIEW: captions read "{slash} diff" and "agents.md"; normalized to the command and file names.]
- The **source is in the public Claude Code repo**.
- Anthropic **plans to move more built-in features to mods**, so you can **strip Claude Code down to a small core** and add back only what you want.

## [1:48](https://youtu.be/tTe7GOJuc0E?t=108) Authoring — Describe the Mod You Want

- **Describe the mod** and Claude **writes it, installs it, and hot-reloads it** into the running session.

## [1:53](https://youtu.be/tTe7GOJuc0E?t=113) The Security Catch

- **Mods are not sandboxed** from your machine. They run with the **same access as Claude Code itself**, and **their publisher is not Anthropic**.
- On **team and enterprise plans and managed machines**, a built-in mod called **"sec default"** loads first and **stops installed mods from overriding your permission deny rules**. [REVIEW: "sec default" is the ASR spelling; confirm the exact name against Anthropic's guide.] Personal machines do not get this layer.
- Anthropic itself calls blast radius **"a safety net, not a permission system"**: a **script that calls the delete command gets past it.**

## [2:18](https://youtu.be/tTe7GOJuc0E?t=138) The Advice

- **Use mods for your own readouts and guards first** — those are worth it today.
- **Skip mods from strangers** until you have checked their repo.
- **Keep hard blocks in permission rules**, not in mods.

## [2:31](https://youtu.be/tTe7GOJuc0E?t=151) Closing Question

- *Would you install a stranger's mod with full access to your machine? Yes or no?*
