# Claude Code's Creator: "Delete Your CLAUDE.md" — 7 Moments That Matter (Boris Cherny at YC) — Hyperautomation Labs

Source: https://youtu.be/Egd65CLmb6w
Speaker: Hyperautomation Labs ("HAL" — independent AI-tooling commentary channel) · published Jul 27, 2026 · ~19 min · a builder's-cut of **Boris Cherny's** Y Combinator Startup School talk ("Building Claude Code," with YC GP **Diana Hu**), recorded one day after **Opus 5** shipped.

> A condensed, fact-checked commentary on **7 moments** from the talk by the engineer who created and still runs **Claude Code**. The through-line: a harness is not a machine you maintain, it's **a creature you re-derive for each new model** — so the highest-leverage move on a smarter model is often *deletion*. Anthropic deleted **80% of Claude Code's own system prompt** when Opus 5 landed (the old lines were compensating for dumber models); Boris tells everyone to **delete their `CLAUDE.md`, skills, and hooks every 6 months** and add lines back only when the model *repeatedly* stumbles. Also: the "**product overhang**" formula behind Claude Code, an **11-day Zig→Rust rewrite of Bun** driven by one dynamic-workflow prompt, a **3-sentence prompt still running after 2 weeks** whose real content is a *verification loop*, and **self-maintaining codebases** built from one-sentence routines on a timer.

> **Related (same category):** the "less prompt engineering, more verification / empirical" thesis echoes [[stop_telling_claude_meta_prompting]]; the "orchestrate hundreds-to-thousands of agents" dynamic workflow connects to [[stop_using_claude_code_like_this_subagents]]; the long-running "don't stop until you're done" loop and one-sentence timed routines are the disciplined cousins of [[claude_code_tasks_rip_ralph_loops]] and [[ralph_wiggum_loop_anthropic_wrong]]; and "delete your CLAUDE.md" is the direct counterpoint to the accumulate-everything memory approach in [[graphify_obsidian_ai_second_brain_cloudcodes]]. **The full primary-source talk this is cut from is archived as [[boris_cherny_building_claude_code_yc_full_talk]]** — go there for prompt-injection, hobbling/overhang, dynamic-workflow, and loops-vs-routines detail the commentary skips. Same channel as [[scroll_world_3d_brand_skill_hyperautomation]].

> ⚠️ **Sourcing note:** the headline numbers are the video's/Boris's own claims as of **July 2026** and should be verified before relying on them. HAL says it fact-checked the Bun rewrite against public sources — the [Bun engineering blog](https://bun.com/blog/bun-in-rust) (535k lines Zig→Rust, ~11 days, 64 parallel cloud instances, ~$165k tokens), the [Anthropic "acquires Bun" post](https://www.anthropic.com/news/anthropic-acquires-bun-as-claude-code-reaches-usd1b-milestone), the [ARC Prize Opus 5 results](https://arcprize.org/results/anthropic-claude-opus-5), and Boris's still-live [2004 TI-83 BASIC guide](https://www.ticalc.org/programming/columns/83plus-bas/cherny/). Feature/product names ("dynamic workflow," "Claude tag" = Claude running in Slack, "simple mode") and the `CLAUDE_CODE_SIMPLE=1` env var are transcribed by ear from the talk — confirm against the docs. This is independent commentary, **not affiliated with Anthropic or YC**; the full official talk is *"Boris Cherny: Building Claude Code" (Y Combinator, 2026)*.

---

## [0:00](https://youtu.be/Egd65CLmb6w?t=0) The Headline: Delete, Don't Tweak

- Boris Cherny — the engineer who **created Claude Code** and still runs it — sat down at **Y Combinator Startup School** with GP **Diana Hu**, one day after **Opus 5** shipped.
- His advice to a room of founders: **delete your `CLAUDE.md` files. Not tweak them — delete them.**
- Three claims the video unpacks and fact-checks: Anthropic **deleted 80% of Claude Code's system prompt**; a **3-sentence Slack prompt ran for two straight weeks**; an **entire JavaScript runtime was rewritten in 11 days**.

## [0:48](https://youtu.be/Egd65CLmb6w?t=48) Who Is Boris Cherny

- Creator of Claude Code inside Anthropic; still leads it.
- Context: Opus 5 had just shipped and (per the talk) **jumped ARC-AGI-3 from a prior best under ~8% to ~30%** — see the [ARC Prize results](https://arcprize.org/results/anthropic-claude-opus-5) to verify.

## [1:16](https://youtu.be/Egd65CLmb6w?t=76) Moment 1 — They Deleted 80% of Their Own System Prompt

- **The harness is always changing.** Every time a new model ships, the Claude Code team deletes and rewrites chunks of the system prompt, swaps tools, and rewrites tool prompts. *"Every model is very different"* — what you did for a model 3 months ago **may not transfer at all** to the next one.
- **Why 80% got cut for Opus 5:** most of that prompt was **correcting for behaviors a dumber model got wrong**. Opus 5 "just does it," so the corrections became dead weight.
- **Two things you can try yourself:**
  - `--system-prompt` — replace Claude Code's entire system prompt with your own to experiment.
  - **"Simple mode"** — an *undocumented* env var, `CLAUDE_CODE_SIMPLE=1`, that **strips all built-in prompts, including the tool prompts.** Anthropic uses it as an **ablation** to test whether the prompt is even helping.
- **The surprise:** *"the model is actually a little bit more intelligent without these prompts."* The instructions weren't helping Opus 5; they were compensating for its predecessors.
- **Takeaway:** every line is re-read on **every single turn**. *"Lines have rent to pay."*

## [3:41](https://youtu.be/Egd65CLmb6w?t=221) Moment 2 — Delete Your CLAUDE.md Every 6 Months

- Diana asks: should everyone building AI products be brave enough to press delete? Boris: **"100%."**
- For everyone *using* Claude Code (not building agentic products): **every 6 months, delete your `CLAUDE.md`, delete your skills, delete your hooks. See what the model does — it might surprise you.** Explicitly recommended for Opus 5.
- **The rebuild method (don't guess):** delete everything → use it normally → and **only when it stumbles on the same thing repeatedly do you add one line back.** Rebuild the config **line by earned line.**
- **Mental model:** the harness is something you **re-derive per model** — *getting to know a new creature, not maintaining an old machine.* Config that's been accumulating since Sonnet 3.5 isn't memory, it's **scar tissue from models that no longer exist.**

## [5:10](https://youtu.be/Egd65CLmb6w?t=310) Moment 3 — "Product Overhang": the Birth Story of Claude Code

- **Product overhang** = the gap between **what a model can already do** and **what any product actually lets it do.**
- Two years ago: coding tools were **read-only chat** — you could ask about a codebase but not have the model *write*. Nothing was eliciting the model's ability to write **entire functions and files** at a time.
- **The Claude Code bet:** *"strip all the scaffolding and give the model the simplest possible harness"* so it can write a whole file, then a whole feature. The product was **the thinnest possible harness dropped into the gap.**
- Boris's claim today: **the overhang with current models is bigger than it was then** — largely unclaimed and commercially valuable. The next Claude Code is sitting in that gap right now.

## [7:07](https://youtu.be/Egd65CLmb6w?t=427) Moment 4 — The 11-Day Bun Rewrite (Zig → Rust)

- Claude Code runs on **Bun** (the fast JS runtime Anthropic acquired in December). Bun was **500,000+ lines of low-level Zig** (manual memory management); the team had been having Claude hunt memory leaks one at a time.
- Engineer **Jared** made it a recurring **test problem** thrown at each new model generation. **Starting with Fable** the model could begin to do it; **Opus 5** could too.
- **How:** define a **test suite** (Bun and Node.js both have big ones, so correctness is checkable) → **one prompt**, a **dynamic workflow** (Claude Code's feature for orchestrating *dozens, hundreds, thousands* of agents productively) → it **ran for 11 days and rewrote the entire codebase.**
- **Not one-shot** — there was **human steering** — but *previous models couldn't do it even with steering.* It's **in production now**: what Claude Code runs on today.
- Scale: *"over a year"* of work for the best engineers, compressed into 11 days.

## [9:00](https://youtu.be/Egd65CLmb6w?t=540) Fact-Check — The Receipts (All Public)

- Per the [official Bun engineering blog](https://bun.com/blog/bun-in-rust): **535,000 lines of Zig → Rust in ~11 days** (this May), **64 cloud instances in parallel**, **~$165,000 of tokens** at API prices. Claude Code has shipped the Rust port **since June**; Bun's repo now lists **Rust as its primary language.**
- **Honest caveats from the same sources:** human steering was involved; **adversarial Claude reviewers caught 3 critical bugs before merge**; and Zig's creator publicly disliked it.
- **The real enabler was boring:** a **brutal test suite on both sides** telling the model, at every step, whether it was right. (That's the whole next moment.)

## [10:18](https://youtu.be/Egd65CLmb6w?t=618) Moment 5 — The 2-Week Prompt (Steal the Anatomy)

- Boris: the skill now is **less prompt engineering, more (1) giving Claude a task that seems a little too hard and (2) making it possible for Claude to verify its own work.** *"Verification is probably the single most important thing people do not get right."*
- **The receipt** (a `Claude tag` / Claude-in-Slack session, still running as he spoke): he wired up a **macOS GitHub runner** and an empty repo (a Swift rewrite of the Claude desktop app), then gave a **three-sentence prompt**:
  1. **Rewrite the Electron app in Swift.**
  2. **Run the Electron app in the Mac VM, screenshot it, and compare pixel by pixel to the Swift version.**
  3. **Don't stop until you're done.**
- It had been running **~14–15 days** — likely longer than anyone in the audience had kept Claude on a single task.
- **The anatomy:** *a task beyond what he knew the model could do + a verification loop (run the real app → screenshot → compare) + an exit condition (don't stop until done).* No framework, no scaffolding. Claude even opened its own Slack channel to **live-blog progress with screenshots.**
- **What separates the top 1%:** not a secret prompt — **they build the checker before they hand over the task.** *The model does the work; the verifier is your job.*

## [13:06](https://youtu.be/Egd65CLmb6w?t=786) Moment 6 — Claude Maintains Its Own Codebase (Routines on a Timer)

- Anthropic now has **Claude maintaining Claude Code itself** — CLI, iOS, Android, and desktop apps — via a **Slack channel of scheduled routines.**
- Example routines (each a **single one-sentence prompt on a timer**):
  - **Clean up dead code** — finds dead code across all codebases via static *and* dynamic analysis (Claude chose that method itself, unprompted) and opens a PR to delete it, **every day.**
  - **Abstraction police** — finds nearly-duplicated abstractions scattered across the codebase and **unifies** them.
  - Others in the same vein: *ship experiments that hit 100%, write tests where coverage is thin, delete tests that earn nothing.*
- **~20–30 routines run per day**, hundreds-to-**thousands of agents daily**, doing the work of *dozens or hundreds of engineers* — on the path to **fully automating app maintenance** so humans ship products instead of chores.
- **No big-company infra required:** *a cron job + a one-line prompt* is something you can set up **tonight** on your own repo. **The moat isn't the routine — it's deciding what's worth repeating.**

## [15:36](https://youtu.be/Egd65CLmb6w?t=936) Moment 7 — The Empirical Mindset (+ the TI-83 Receipt)

- How to get good: **"don't listen to the LinkedIn influencers, don't listen to me, don't read Twitter."** There is **no one weird trick** — from the person who'd know if there were.
- The winning skill is **empirical:** forget what you learned about *past* models and CS theory in class → **look at the model, try a task, see where it struggles, adjust, repeat.** It's *"become an empirical science, not a theoretical one."*
- **20-year veterans struggle most** because **over-specifying used to be the job** — the hard part is forgetting priors and being open to retrying ideas that failed on older models.
- **The through-line, made literal:** Boris learned to code on a **TI-83** to pass math tests; his **2004 "Beginner's Guide to Calculator BASIC v2.5"** is [still live on ticalc.org](https://www.ticalc.org/programming/columns/83plus-bas/cherny/). *Practical problem first, theory second* — the same loop that built Claude Code.

## [17:40](https://youtu.be/Egd65CLmb6w?t=1060) The 7 Moments in 40 Seconds

1. Deleting **80%** of the system prompt produced a **smarter** model.
2. **Delete your `CLAUDE.md` every 6 months** and rebuild it line by earned line.
3. **Product overhang** built Claude Code — and the gap is **bigger today.**
4. A **half-million-line runtime** was rewritten in **11 days**, with a **test suite as referee.**
5. The elite skill is **building the verifier** (the 3-sentence prompt still running after 2 weeks).
6. Put **one-sentence routines on a timer** and let Claude maintain your codebase.
7. **Ignore the influencers — the only method is empirical.**

## [18:22](https://youtu.be/Egd65CLmb6w?t=1102) Free PDF + The Closing Nudge

- HAL's free "**Delete Protocol**" PDF (comment "delete," or [hyperautomationlabs.co/free/delete](https://hyperautomationlabs.co/free/delete)): every quote timestamped, the delete-and-rebuild checklist, the 2-week prompt template, and the routine list.
- **The parting line:** *before you add one more line to your `CLAUDE.md` tonight, try deleting one instead.*

---

## Practical Checklist (from the talk)

- **New model dropped?** Treat the harness as a new creature: delete config, run tasks, re-add only what the model *repeatedly* gets wrong.
- **Every ~6 months:** delete `CLAUDE.md` / skills / hooks and re-derive from behavior.
- **Ablation tools:** `CLAUDE_CODE_SIMPLE=1` (strip all built-in + tool prompts) and `--system-prompt` (swap the whole thing) to test whether your instructions still earn their rent.
- **Every hard task:** ship it *with* a verification loop and an exit condition ("run the real thing → compare → don't stop until done"). Build the checker first.
- **Recurring chores:** encode as one-sentence prompts on a cron (dead-code cleanup, abstraction unification, test coverage). The judgment is in *what to repeat*, not the prompt.

## Tools & Links

- **Full official talk:** *"Boris Cherny: Building Claude Code"* — Y Combinator Startup School 2026 (with Diana Hu): https://www.youtube.com/watch?v=qyPCVqFUyDo
- **Bun Zig→Rust rewrite (engineering post):** https://bun.com/blog/bun-in-rust
- **Anthropic acquires Bun (Claude Code $1B milestone):** https://www.anthropic.com/news/anthropic-acquires-bun-as-claude-code-reaches-usd1b-milestone
- **ARC Prize — Opus 5 results:** https://arcprize.org/results/anthropic-claude-opus-5
- **Boris's 2004 TI-83 BASIC guide (still live):** https://www.ticalc.org/programming/columns/83plus-bas/cherny/
- **Env var / flags mentioned:** `CLAUDE_CODE_SIMPLE=1` (undocumented "simple mode"), `--system-prompt` (transcribed by ear — verify in docs).
