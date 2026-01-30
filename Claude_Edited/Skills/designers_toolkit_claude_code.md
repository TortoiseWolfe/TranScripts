# Designer's Toolkit for Claude Code

**Source:** Dive Club (Vid hosting, Kyle Zantos guest) — [YouTube](https://youtu.be/HcLz3ikw-n0)
**Date:** 2026-01-07 | **Duration:** 48 minutes
**Links:** [Kyle's portfolio](https://zantos.co) | [Leva control panel](https://threejsresources.com/tool/leva) | [Compound Engineering plugin](https://github.com/EveryInc/compound-engineering-plugin)

---

## Who Is Kyle Zantos?

Leads UX Tools Labs — responsible for evaluating new design tools and workflows. Describes himself as a designer transitioning into design engineering, using Claude Code as his primary building tool.

---

## Cursor's Visual Editor for Designers

Cursor added a visual editor and in-app browser. Not "Figma is dead" — but useful for **tweaking spacing, padding, and arrangements** in real time without entering the prompt loop.

**Kyle's setup:** Runs Claude Code in the terminal inside Cursor. Uses the in-app browser and visual editor for visual tweaking, then hits "apply" to commit changes via the Cursor agent. Does not pay for Cursor's AI — uses it purely as a UI shell for Claude Code.

**For designers starting out:** The VS Code extensions (Claude Code, Factory, Codex) provide a friendlier interface than the raw terminal. Mouse navigation, scrollable output — small things that reduce intimidation.

---

## Build a Personal Playground

**Core tactic:** When you need a UI component and can't find the right existing version, build a standalone studio to experiment with options.

**Example — Waveform component:** Kyle couldn't find an animated sound-on/sound-off waveform he liked. Built a playground with multiple effect options, tweakable parameters. Once he found the right active/muted states, he grabbed the code and told Claude Code: "This is the functionality and design I want tied to my waveform component."

**Why this works:**
- You prototype in isolation, outside your main codebase
- Once dialed in, you hand Claude Code concrete reference code
- The playground can be expanded (add new icons, accept images, reuse effects elsewhere)

---

## Feed External Inspiration Directly to Claude Code

**Two strategies for describing visual effects you can't articulate:**

1. **Learn developer nomenclature** — terms like "glitchy CRT scan lines" translate directly because LLMs were trained on that language
2. **Point Claude Code at the source** — drop a URL, tweet thread, or CodePen and tell it to figure out the technique

### Multi-Layered Shadow Technique

Kyle saw James McDonald's tweet about replacing literal borders with **3+ layered shadows** at different opacities and spreads. Instead of recreating it manually:

- Dropped the URL into Claude Code: *"This technique is awesome. I want it applied to our components. Go do that."*
- Claude Code visited the URL, extracted the technique, and applied it
- Iterated: 3 layers for card borders, 5 layers for stronger phone-container borders, 4 layers for buttons — each with differentiated feels

**Same approach with tweet threads:** Fed Derek Briggs's full Campsite design thread to Claude Code while working on the Inflight UI kit. Prompt: *"Don't copy this exactly — scan through it and figure out the easy wins. I want to steal the best parts of this style."*

Result: Buttons look better in code than in Figma.

---

## Creating a Design Engineering Skill with Claude Code

**The big idea:** Build a Claude Code skill + sub-agent that embodies the philosophies and techniques of designers you admire.

### Kyle's Process

1. **Chose reference designers:** Jakub Krehel (articles, site) and Jhey Tompkins (CodePens, tweets)
2. **Used the Compound Engineering plugin** (by Kieran Clawson, free in the Every marketplace) — specifically its "create a new skill" skill
3. **Fed it 15–20 CodePens + tweets from Jhey, plus Jakub's full site** with the prompt: *"Scan through these. Gather what's useful literally and process this philosophically. I want a skill that can do that well."*
4. **Result:** A visual/interaction design **auditor** — a skill.md + knowledge base docs + custom sub-agent that launches on command and audits any app against the collected design philosophy

### How the Auditor Works

- Invoke the skill → it launches the sub-agent
- Agent audits all visual and interaction design in the current app
- Returns recommendations based on the **amalgamated philosophy** of the reference designers

### Iterating the Skill

- **Add new perspectives:** Feed in Emil Kowalski's work (20+ links) and tell Claude Code to reassess the entire philosophy with three perspectives instead of two
- **Refine taste feedback:** The initial skill was overly conservative (subtle effects only). Kyle plans to update it: *"Not everything should be subtle. Differentiate between animations users should notice vs. background polish."*

**Key warning:** Don't create one mega-skill of every designer you've ever liked — that's useless. Be surgical and intentional.

---

## Leva Control Panels

**Leva** (L-E-V-A) — a React control panel library. Alternative: Tweakpane. Works well with Next.js and React.

**Setup:** Tell Claude Code: *"I want to use Leva. This is the stuff I want to be able to control. Make a plan."* — it installs, assigns variables, and creates the panel.

**Why designers need this:** Nailing interaction design details (animation timing, easing curves, spring values) requires real-time parameter tweaking. Leva gives you sliders and knobs for every relevant value.

**Example — Corner hover animations:** Cards with corner lines that animate to meet in the middle on hover. Leva controls let Kyle tweak: transition duration, secondary tracer delay, overall snappiness vs. luxuriousness.

**Pro tip for global claude.md:** Add a standing instruction: *"Whenever I say 'give me controls to tweak something about UI,' grab the Leva component, bring it into our app, and ask me what I want to control."*

---

## CLAUDE.md Strategy

### Global Level (applies to all projects)

- **Be slim.** Only truly universal preferences (like the Leva instruction above)
- Don't treat it as a journal or tome

### Project Level

- **Resist bloat.** If you're working on frontend UI, Claude Code doesn't need to know your entire API architecture — that context bloats memory and degrades performance
- **Use subdirectory claude.md files** — put component-specific instructions in `components/claude.md`, backend docs in `api/claude.md`, etc.

### Philosophy Over Tactics

- Recommendations from 4 months ago are likely outdated
- **Learn the philosophy and ethos, not the literal setup** — tools level up themselves constantly
- Kyle has sunk 20+ hours building custom tools that Claude Code later shipped as native features
- Content creators optimize for views, not authority — take specific "10x your productivity" advice with skepticism
- Core tenets that endure: **plan before you execute with agents**
- Everything else: experiment, evolve, find what works for you

---

## Tool Stack Strategy

### Budget Approach ($40/month)

Combine **Claude Code $20** + **Factory/Cursor $20**. Bounce between them when you hit rate limits on one. Factory gives access to multiple LLMs (Gemini 3 Pro is strong for UI generation).

### Recommended Approach ($100/month)

Claude Code $100 tier — rarely hits limits even with heavy use. Worth it because Claude Code isn't just for coding: Obsidian vault management, Linear issue cleanup, content structuring.

**Key insight:** *"Claude Code can be so many things that aren't coding. Claude Code is just Claude's computer."*

---

## Tuneup Days

Kyle schedules dedicated half-days where he's **not allowed to be productive on projects** — only allowed to:

- Install that plugin he's been hearing about
- Try the Compound Engineering workflow
- Clean up folder structures
- Consume educational content thoughtfully
- Build playground/experimental projects (games for his toddler, personal site experiments)

Keeps a running list of tuneup tasks. Picks 3–4 per session.

---

## Key People Referenced

| Person | Known For |
|--------|-----------|
| **Jhey Tompkins** | Minimalistic, surgical CSS/animation code |
| **Derek Briggs** | Campsite design, shadow/border techniques |
| **Will King** | Recommended Leva control panels |
| **Emil Kowalski** | Animation/interaction design course |
| **Jakub Krehel** | Design engineering articles |
| **James McDonald** | Multi-layered shadow technique |
| **Kieran Clawson** | Compound Engineering plugin (Every marketplace) |
