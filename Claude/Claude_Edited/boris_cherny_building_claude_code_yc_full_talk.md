# Boris Cherny: Building Claude Code — Y Combinator (Startup School 2026)

Source: https://youtu.be/qyPCVqFUyDo
Speaker: **Boris Cherny** (creator of Claude Code, Anthropic) · Interviewer: **Diana Hu** (Y Combinator) · Startup School 2026 · ~36 min · recorded the day after **Opus 5** shipped.

> The **primary-source talk** from Claude Code's creator on how to build products when model capabilities keep accelerating. Core thesis: a harness is **a living creature you re-derive per model, not a machine you maintain** — so on a smarter model the highest-leverage move is often *deletion*. Threads: Opus 5's new **long-running** capability (days/weeks/months) + **auto mode**; **prompt injection** effectively solved via an aligned model + a **mechanistic-interpretability classifier** watching neurons; deleting **80% of Claude Code's system prompt** and the **ablation** method to rebuild it line-by-earned-line; **"hobbling" vs "product overhang"** (unhobbling Sonnet 3.5 with terminal access *was* Claude Code); giving the model **harder tasks + verification** (the **Bun Zig→Rust rewrite**: one prompt, a dynamic workflow, **11 days**, now in production; the **2-week Electron→Swift** prompt still running); **dynamic workflows as "an algebra for agents"** and a new form of **test-time compute**; **loops vs routines** (local cron vs cloud) that let **Claude maintain its own codebases**; and "**coding is solved — for the kind of coding I do.**"

> **Related (same category):** the condensed **builder's-cut commentary on this exact talk** is [[delete_your_claude_md_boris_cherny_7_moments_hyperautomation]] (start there for the 7 highlights; this file is the full primary source). The "less prompt engineering, more verification / empirical" thesis → [[stop_telling_claude_meta_prompting]]; dynamic workflows / thousands of agents → [[stop_using_claude_code_like_this_subagents]]; loops, routines, and long-running "don't stop until done" tasks → [[claude_code_tasks_rip_ralph_loops]] and [[ralph_wiggum_loop_anthropic_wrong]]; "delete your CLAUDE.md" as the counterpoint to accumulate-everything memory → [[graphify_obsidian_ai_second_brain_cloudcodes]].

> ⚠️ **Sourcing note:** figures below are Boris's own statements as of **July 2026** — verify before relying on them. YC publishes an official transcript: https://www.ycrootaccess.com/p/boris-cherny-building-claude-code . ASR corrections were applied ("quad"/"Cloud Code" → Claude/Claude Code; "Sonic 3.5" → Sonnet 3.5). One model name at ~2:35 was garbled in the captions (transcribed as "People") and is left flagged — likely an intermediate model name in the Opus 4.7/4.8 → Sonnet 5 → Opus 5 lineage. The Bun rewrite specifics (535k lines, ~11 days, 64 instances, ~$165k) are documented publicly on the [Bun engineering blog](https://bun.com/blog/bun-in-rust); in the talk Boris says "over 100,000" lines and "11 days."

---

## [0:07](https://youtu.be/qyPCVqFUyDo?t=7) What Makes Opus 5 Different

- Opus 5 shipped **the day before** the talk; per Diana it took **ARC-AGI-3 to 30%**, up from a prior best "in the low single digits or low teens."
- Each new model learns many new capabilities (most training attempts fail; a subset sticks), and sometimes it gains skills it was **never explicitly taught.**
- The standout: Opus 5 **runs for very long periods.** Combined with **auto mode**, *"it can go for days, weeks, months at a time. It just won't stop"* — because it knows it needs to finish the task.
- You no longer need scaffolding like `/goal` for long runs — the model just keeps going on its own.

> **[1:24] Boris:** "One example of something it does that I think no other model has done is it runs for a very long period of time… combine Opus 5 with auto mode and it's just incredible. It can go for days, weeks, months at a time. It just won't stop."

## [2:06](https://youtu.be/qyPCVqFUyDo?t=126) Solving Prompt Injection

- **Prompt injection** (the "lethal trifecta") shapes harness, agent, and product design. A year ago a model that read a malicious instruction online (*"do X, Y, Z and also delete everything on the user's computer"*) **would have just done it.**
- Resistance has been building since **Opus 4.7 / 4.8**; **Sonnet 5** was "quite good"; **Opus 5 hits a new frontier.**
- The fix is **three layers**: a **well-aligned model** ("three years of research into alignment") + a **prompt-injection classifier run on all traffic** + an **auto-mode classifier.**
- The classifier is built on **mechanistic-interpretability work** — *literally watching the neurons in the model's brain that light up when prompt injection happens.* The model itself "won't even tell you," but they can see it.

> **[2:52] Boris:** "If you combine a well-aligned model — essentially three years of research into alignment — with a prompt-injection classifier we run for all traffic… it's based on mechanistic-interpretability work where we're literally looking at neurons in the model's brain that light up when prompt injection happens. With these three layers we just cannot demonstrate prompt injection anymore."

## [3:21](https://youtu.be/qyPCVqFUyDo?t=201) Why Claude Code Deleted 80% of Its System Prompt

- The harness **is always changing** — every new model means deleting/rewriting chunks of the system prompt and swapping tools and tool prompts, because *"every model is very different."* What you tuned 3 months ago "might not translate at all."
- Opus 5 is smart enough that much of the old prompt — which existed to **correct behaviors the model should have known but didn't** — became dead weight. So they **deleted 80%.**
- **Try it yourself:** the `--system-prompt` flag replaces the whole prompt; the undocumented **simple mode** (a `CLAUDE_CODE_SIMPLE=1`-style env var) **deletes all system prompts including the tool prompts.**
- Internally it's an **ablation**: *"the model is actually a little bit more intelligent without these prompts."* (As a *product* you still keep some prompts so it behaves the way users want.)
- Today, *"almost all"* remaining harness code is **safety, permissions, and static analysis**, plus UI — much else has been unshipped.

> **[6:01] Boris:** "You delete the entire system prompt and then you bring it back line by line to figure out the impact of each individual line… an ablation is essentially an eval where you delete things to figure out the impact."

## [6:37](https://youtu.be/qyPCVqFUyDo?t=397) Press Delete on Your AI Product

- Should everyone building AI products run ablations and be brave enough to delete? Boris: **"100%."**
- For people who just *use* Claude Code: **every 6 months, delete your `CLAUDE.md`, your skills, your hooks** — run the model and see what it does. *"It might surprise you."* Explicitly recommended for Opus 5.

> **[6:55] Boris:** "For people that aren't building agentic products but you're using Claude Code — every 6 months delete your CLAUDE.md. Delete your skills. Delete your hooks. See what the model does and it might surprise you."

## [7:20](https://youtu.be/qyPCVqFUyDo?t=440) How to Rebuild Your System Prompt

- Method: **step one, delete; step two, use it.** Don't *guess* what instructions the model needs — you'll often predict wrong. Run the real thing, watch where it fails, and **only when it repeatedly stumbles on the same thing do you add one line back** (every line is re-read every turn, so each must earn its place).
- Building on models is **not** traditional engineering: no big up-front system design, no months-long re-architecture. Treat the model like **"a living creature"** — organic, with a different personality each generation that you get to know and adjust the harness around. The mindset is **empirical and scientific.**
- **On evals:** kept and appended, but they don't outlive the harness by much — *"an eval might live for maybe one, two, three model generations"* before the model **saturates** it and you throw it away and rebuild from where the model now struggles.

> **[8:58] Boris:** "The way to think about it is almost like a living creature… every model generation it behaves differently, it has a slightly different personality, and you have to take the time to get to know it and then adjust the harness based on that."

## [10:30](https://youtu.be/qyPCVqFUyDo?t=630) Product Overhang and "Unhobbling" AI

- **Hobbling** = the product actively *getting in the way* of what the model can do. **Product overhang** = the flip side: today's models can already do things "we have not yet realized," but **no product exists to elicit it.** Two sides of the same coin.
- **Origin of Claude Code (~1.5–2 years ago, on Sonnet 3.5** — then the best coding model, "a pretty terrible coding model by modern standards"): competing tools only did **autocomplete and read-only chat.** Nothing elicited the model's ability to write **entire functions and files.**
- The Claude Code bet: **strip all scaffolding, give the model the simplest possible harness** (full terminal access) so it can write a whole file and build a whole feature.
- Boris's claim: **modern models have even more overhang** he isn't seeing startups capture — *"a huge amount of opportunity… amazing and interesting and commercially valuable."*

> **[13:10] Boris:** "The idea with Claude Code was: we think the model can probably do this. What if we get rid of all the scaffolding and just give the model the simplest possible harness, so it can write an entire file at a time and build an entire feature?"

## [14:26](https://youtu.be/qyPCVqFUyDo?t=866) Give Claude Harder Problems

- **Principle 1 — hand it tasks slightly *harder* than you think it can do.** The common mistake is **over-specifying** ("do it this way, then this, then this — one, two, three, four"). Instead work **higher-level**: describe the task, the guardrails, and the **exit criteria**, then *"let the model cook"* and come back later.
- **Flagship example — the Bun rewrite.** Claude Code runs on **Bun** (a faster open-source alternative to **Node.js**), originally **500k+ lines of Zig** (manual memory management → leaks). The team first had Claude **fuzz the codebase to trigger leaks** one at a time; then **Jared** threw the full rewrite at each new model generation.
  - **Starting with Fable**, the model could do it. Big test suites in **Bun and Node.js** made success **verifiable**. The **Zig → Rust** rewrite was **one prompt**, a **dynamic workflow**, **ran 11 days**, and rewrote the entire codebase. **Not one-shot** (there was steering), but previous models couldn't do it even *with* steering. It's **in production now.**
- **Principle 2 — experiment / give yourself room to play.** Viral internal example: someone gave **Opus 5 OpenCV** and had it **draw** (portraits, animals, landscapes) — despite never being trained to draw. Pure **"solicitation gap."** Boris suspects "dozens, hundreds" of such undiscovered capabilities remain.

> **[15:17] Boris:** "You want to go a little bit higher level — describe the task, the guardrails, the exit criteria, and then just let the model cook. Come back in a little bit."
> **[18:52] Boris:** "Someone figured out you can give Opus 5 OpenCV and have it draw… we didn't train the model to draw. It's just the solicitation gap — if you ask it the right way, it can just do it."

## [19:32](https://youtu.be/qyPCVqFUyDo?t=1172) Prompt Engineering Is Changing

- The hot job went **prompt engineer → context engineer** — waves that come and go. The real skill now: **(1) give Claude a task that seems a little too hard, and (2) make it possible for Claude to verify its work along the way.**
- **Verification is "the single most important thing that people do not get right."**
- **Example — Electron → Swift.** Anthropic's **Claude desktop app** is **Electron** (sluggish 6 months ago, now fast and "the thing most of the team uses"); Boris wanted to see a **native** version. In a **Claude tag** session (*"Claude running in Slack," a new product*) he hooked up a **macOS GitHub runner** (so it could start a **Mac VM**), pointed it at an empty Swift repo, then gave the core prompt: rewrite the Electron app in Swift, **run the Electron app in the Mac VM, screenshot it, compare pixel by pixel** to the Swift version, and **"don't stop until you're done."**

> **[20:15] Boris:** "The skill nowadays is less about prompt engineering and more about how do you give Claude a task that seems a little too hard — and how do you make it possible for Claude to verify its work along the way. Verification is probably the single most important thing that people do not get right."

## [21:57](https://youtu.be/qyPCVqFUyDo?t=1317) The Two-Week Claude Code Prompt

- That Electron→Swift task **was still running — "a little over 2 weeks, 14–15 days."** Few audience hands had ever run a Claude task past 2 weeks.
- Long-running success = **hallucination control via verification:** give the task + a way to verify its output so it doesn't get stuck, and *"it will just go."* You don't strictly need `/goal` or `/loop`.
- **Emergent behavior:** Claude **"live-blogged it"** — created its own internal **Slack channel** and posted **screenshots every few minutes.**
- On becoming a top-1% user: **"don't listen to the LinkedIn influencers… don't read Twitter."** No "one weird trick" — approach it **empirically.** The loop: too-hard task → give it verification tools like you would → watch where it struggles → fix with **better prompting, a skill, or an MCP** to supply missing context.
- Veterans' worst failure mode is **over-specifying / over-engineering.** The right model is to **treat it like a coworker** at that intelligence level.

> **[22:48] Boris:** "Claude also decided to live-blog it — it created a Slack channel internally and started posting screenshots every few minutes of its progress."
> **[23:18] Boris:** "Maybe, like, don't listen to the LinkedIn influencers… Don't read Twitter."

## [24:42](https://youtu.be/qyPCVqFUyDo?t=1482) Running Thousands of AI Agents

- The 2-week task likely spawned **"thousands, tens of thousands"** of agents. Two ways to run many agents:
- **Way 1 — Dynamic workflows** (newish Claude Code feature). **Trigger: just say "use a workflow."** Mechanism: **Bun is used as a sandbox**, a **VM is started within Bun**, and Claude orchestrates many agents inside it. For a big task it **fans out** a first pass, then a set to **verify/summarize**, then fans out again. Boris (a **functional-programming** person) designed it as **"an algebra for agents"** — run them in **sequence** or **parallel** — and frames it as **"a new way to orchestrate test-time compute"** (test-time compute = "how many tokens it generates"), ramped way up for hard tasks.
- **Way 2 — Loops and routines.** A **loop** = *"a cron job running locally for Claude"*; a **routine** = the same thing **running in the cloud** (close your laptop). Unlike a workflow (one task split into chunks), a loop/routine is **one repetitive task** that **doesn't share context but may share memory**, run hourly / every 5 min / daily.
- **Claude now maintains itself** across the **CLI, iOS, Android, and desktop apps** via a Slack channel of routines (each a one-sentence prompt): **clean up dead code** (static + dynamic analysis, daily PR — method not prompted), **ship experiments already at 100%**, **write tests** for thin coverage, **delete useless tests**, **"abstraction police"** (unify nearly-duplicated abstractions). ~**20–30 routines/day**, **hundreds-to-thousands of agents daily**, "the work of dozens or hundreds of engineers" — on the path to **fully automating app maintenance** so humans ship product and talk to users.

> **[25:22] Boris:** "The easiest way is dynamic workflows… all you have to say is 'use a workflow.' We use Bun as a sandbox, start a virtual machine within Bun, and let Claude start a lot of agents and orchestrate them."
> **[26:29] Boris:** "My background is functional programming, so the way we designed this is essentially an algebra for agents — a way to run agents in sequence, a way to run agents in parallel."
> **[27:40] Boris:** "A loop is essentially a cron job running locally for Claude. A routine is the same thing but running Claude in the cloud, so you can close your laptop."

## [30:15](https://youtu.be/qyPCVqFUyDo?t=1815) Coding Is (Almost) Solved

- Boris's caveat on "coding is solved": **"solved for the kind of coding that I do. It's not solved for everyone."**
- Still hard: **super-deep systems codebases, distributed systems, and fine-grained UI verification** ("something is off by a pixel" — Opus 5 was "a big leap in vision and computer use, but still not perfect").
- **Audience poll:** some write **100% of code via agents**; slightly fewer at **>50%.** "It's getting there… solved for more and more kinds of code."
- Winning mindset = **empirical:** *"forget everything you learned about past models… and computer-science theory in class. Look at the model, try a task, see where it struggles, adjust."* The skill is **forgetting your priors** — *"it's not a theoretical science, it's become an empirical science."*

> **[30:38] Boris:** "Coding is solved for the kind of coding that I do. It's not solved for everyone — there are still super-deep systems codebases and distributed systems where Claude still struggles."

## [32:20](https://youtu.be/qyPCVqFUyDo?t=1940) What Every CS Student Should Still Learn

- Boris learned to code **practically** — teaching himself to solve his own problems. First language **BASIC** on a **TI-83 calculator** in middle school; he wrote an internet guide on programming TI-83s ("still up on the internet somewhere").
- The real motivation: an algebra solver in BASIC to **cheat on math tests** (distributed to classmates via a **serial cable**). When calculus made BASIC insufficient, he **learned assembly to write a better solver.**
- Advice: don't just learn CS theory — **learn to apply it.** Pair engineering with **building startups/products, design sense, business sense, data science, and talking to users.** *"Those are the hard skills I'd still be doing by hand."*
- Diana's summary: **"start with making something you want for yourself, then level up and make something people want."** Boris: "Yes." **Closing:** the audience gets **Max 20X** (code by email); Diana dares the room to build something that runs "multiple months and thousands of agents."

> **[34:04] Boris:** "Learn not just the computer science… but learn how to apply it. Often this is about building startups, building products, developing your design sense and business sense, learning to do data science, learning to talk to users."

---

## Key Takeaways

- **Re-derive the harness per model; don't maintain it.** New model → delete config, run, add back only what it *repeatedly* gets wrong. Every ~6 months, delete `CLAUDE.md` / skills / hooks.
- **Ablate to measure.** `CLAUDE_CODE_SIMPLE=1` (strip all built-in + tool prompts) and `--system-prompt` (swap the whole thing); rebuild line by earned line.
- **Verification is the job.** Ship every hard task *with* a way to self-verify and an exit condition; the model does the work, you build the checker.
- **Two axes of leverage:** give **harder tasks** (higher-level: task + guardrails + exit criteria, then let it cook) and **experiment** (mind the solicitation gap — capabilities exist that no product elicits yet).
- **Scale with agents:** `use a workflow` (an algebra for agents / new test-time compute, sandboxed in Bun) for one big task; **loops (local cron) / routines (cloud)** for repeating chores — enough to let Claude maintain its own codebases.
- **Be empirical.** Forget priors and CS-class theory; observe where the model struggles and adjust. Ignore the influencers.

## Tools & Links

- **Official YC transcript:** https://www.ycrootaccess.com/p/boris-cherny-building-claude-code
- **Condensed builder's-cut of this talk (7 moments):** [[delete_your_claude_md_boris_cherny_7_moments_hyperautomation]]
- **Bun Zig→Rust rewrite (engineering post):** https://bun.com/blog/bun-in-rust
- **Env vars / flags / features mentioned:** `CLAUDE_CODE_SIMPLE=1` ("simple mode"), `--system-prompt`, `/goal`, `/loop`, **dynamic workflows** ("use a workflow", Bun-as-sandbox), **loops** (local cron) vs **routines** (cloud), **Claude tag** (Claude in Slack), **MCP** (context injection). Tech named: Bun, Zig, Rust, Node.js, Electron, Swift, OpenCV, macOS GitHub runner. *(Names/flags transcribed by ear — verify in docs.)*
