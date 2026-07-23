# This FREE Claude Code Skill Turns Any Brand Into a 3D World (scroll-world) — Hyperautomation Labs

Source: https://youtu.be/Src-a8GJR20
Speaker: Hyperautomation Labs ("HAL" — independent AI-tooling field-test channel) · published Jul 16, 2026 · ~12 min

> A field test of **scroll-world**, an open-source **Claude Code / Codex agent skill** (by developer **oso95**, MIT) that generates an Apple-style **scroll-scrubbed 3D landing page** for any brand in an afternoon. The core reveal: these pages aren't real-time animation — a camera-flight **film is pre-rendered, and scroll position is just a video timestamp** (scrubber), so scrolling up runs it in reverse. The skill's machine is a **three-piece pipeline** — *stills → dives → connectors* — governed by one make-or-break **SEAM RULE**: every connecting clip must start/end on the **actual last/first frame** of the neighbouring clip, never on the original artwork, or the joint pops and the illusion dies. Covers install (Claude Code `plugin marketplace add` / Vercel Skills CLI), the 6-question interview, a real **$0 build** (route stills through Codex's GPT Image instead of Higgsfield), the portable single-file scroll engine (memory-blob playback to survive byte-range/scrubbing issues), four hard-won gotchas, and honest Higgsfield credit math.

> **Related:** A concrete, single-purpose instance of the agent-skill mechanics explained in [[cracked_claude_agent_skills_indydevdan]] (what a skill *is*, plugins, progressive disclosure) and the marketplace-install path in [[skills_sh_vercel_marketplace]] (the "Vercel Skills CLI" the video uses for Codex/Cursor); good companion to [[7_claude_code_skills_beginners]]. Cross-category note: the output is a browser 3D-world *effect* (pre-rendered video scrubbing), **not** photogrammetry/reconstruction — so it lives here under Claude/Skills, not in the Spatial category, despite the "3D World" title.

> ⚠️ **Sourcing note:** the adoption and pricing figures (2,500+ stars in 10 days; ~15 credits/still, 40–55/clip; ~500–700 credits per desktop world; ~$30 draft-tier pitch build) are the video's own observed/claimed numbers as of **July 2026**, on a Higgsfield **Plus** plan. Recorded here as *what the presenter said* — verify current pricing and the repo before relying on them. Tool/model names (GPT Image 2, Seedance, Seedance Mini, Kling, Higgsfield) are transcribed by ear.

---

## [0:00](https://youtu.be/Src-a8GJR20?t=0) The Page Is a Movie

- A landing page in a normal browser tab with **no cut, no page change, no loading spinner**: the camera drops out of the hills, flies through a bubble-tea kitchen, into the shop, out to the delivery streets.
- **The only input driving the camera is the scroll wheel.** Stop scrolling → the world freezes. Scroll up → **time runs backwards.**
- Built by an open-source skill that appeared on GitHub ~10 days prior: **scroll-world**. The video promises: how the trick works, how to run it, honest cost, and the **one rule** separating "magic" from "broken slideshow."

## [1:03](https://youtu.be/Src-a8GJR20?t=63) The Trick — Scroll Position = Timestamp

- You've felt this on **Apple's product pages** (AirPods drifting apart / rebuilding as you scroll).
- **The secret: the page animates nothing in real time.** Someone pre-rendered a **film** of the camera move; the **scroll bar is just a video scrubber**. Your **scroll position becomes a timestamp**, and the browser paints that exact frame. Scroll fast → plays fast; scroll up → plays reverse.
- The **direct inspiration**: German logistics company **Emons**, who turned their whole trucking business into one miniature world the camera flies through.
- What changed: a page like this used to require a **design agency and a five-figure invoice**.

## [2:08](https://youtu.be/Src-a8GJR20?t=128) The Skill — What scroll-world Actually Is

- **Repo:** `scroll-world` by **oso95**, free/open-source, **MIT**. *(GitHub: github.com/oso95/scroll-world)*
- **Not an app — an agent skill:** a folder of instructions + tools that plugs into **Claude Code, Codex, or any agent that speaks the skill format.** Two commands to install.
- **What it produces end-to-end:** generates artwork with **GPT Image 2** → animates camera flights with **video models that can lock frames together** → wires it into a **portable scroll engine** → hands you a working page. *(Claimed 2,500+ GitHub stars in 10 days — see sourcing note.)*

## [3:03](https://youtu.be/Src-a8GJR20?t=183) The Machine — Stills, Dives, Connectors + THE SEAM RULE

Every Scroll World is exactly **three kinds of pieces** (example: a 5-scene world):

1. **Stills** — 5 still images, one per scene. **Every prompt reuses the same style paragraph, word for word** — that repetition is why 5 images read as *one place* instead of 5 random pictures.
2. **Dives** — 5 dive clips; each starts *outside* a scene and flies the camera *inside*.
3. **Connectors** — 4 short flights that pull up out of one scene, cross the world, and land on the next.

- **THE SEAM RULE (the make-or-break):** a connector **never starts from your artwork.** It starts from the **actual last frame of the previous clip** and ends on the **actual first frame of the next clip.**
- **Why:** every AI render differs slightly; build the join from the *original still* and the joint **pops on screen** → illusion dies. **"Real frames in, invisible seams out."** This one rule is most of the skill's value.

## [4:13](https://youtu.be/Src-a8GJR20?t=253) Install + the 6-Question Interview

- **Claude Code:** `plugin marketplace add oso95/scroll-world` → `plugin install`.
- **Codex / Cursor:** one line via **Vercel's Skills CLI**.
- Then ask for a landing page and it **interviews you** instead of guessing:
  1. **Business** — a word or sentence is enough.
  2. **Brand kit** — can pull colors, name, tone straight from your existing website.
  3. **Art direction** — soft clay miniatures (default), paper craft, glossy toy, claymation, neon night, or **photoreal architecture** (for real estate).
  4. **Journey** — usually 5–7 scenes, proposed from your **actual value chain** (farm → kitchen → shop).
  5. **Mobile** — a real *second film shot natively in portrait*, not a crop.
  6. **Cost gate** — before spending, it **estimates full cost against your live balance and asks for a yes.** ("More AI tools need to be built like this.")

## [6:03](https://youtu.be/Src-a8GJR20?t=363) The $0 Build — 3 Scenes, Free

- Full camera flights render on **Higgsfield** (costs credits). To demo free, the presenter generated **3 scenes with OpenAI's image model** using the **skill's own prompt template**: hillside coffee farm, roastery, corner cafe.
- **Same style paragraph pasted into all three prompts** → they came out as one coherent world. *(That's the whole trick, again.)*
- **The scroll engine** ships inside the repo as **one self-contained JavaScript file** — no framework, no dependencies, injects its own CSS. Mount it with a small config: per section a **still, a clip, a headline, an accent color**. (Demo used simple push/pan stand-ins where the real skill uses true AI camera flights.)

## [7:09](https://youtu.be/Src-a8GJR20?t=429) It Lives — and the Engine Earns Its Star

- Running locally: scrolling down dives farm → roastery → cafe, ending on a normal **call-to-action button**; scroll up and **time reverses**. It's **one continuous film**, not an animation library — the scroll wheel owns the clock.
- The engine handles the weekend-eating parts:
  - **Plays every clip from memory (blobs)** → scrubbing works on any host; a fast phone flick can't freeze the video.
  - **Holds the poster image** until the film actually paints.

## [8:08](https://youtu.be/Src-a8GJR20?t=488) The Gotchas (from the skill's own notes)

1. **The content filter will fight you.** **Seedance** flags innocent clips — especially **bedrooms, pools, spas**, and trigger words like *bed, wine, waterfall*. Fixes, in order: **re-roll** (often passes on the 2nd try) → add **"empty, unoccupied, architectural"** → render that one clip with **Kling** instead (its filter disagrees with Seedance's).
2. **Byte-range trap.** Serve video the normal way and scrubbing can **pin you to frame zero** because simple servers don't answer **byte-range requests** — which is *why* the engine plays from **memory blobs**.
3. **Never reverse camera direction across a scene.** Diving forward in, then pulling backward out, reads as a **rewind glitch**. Keep the camera flying **forward the whole way** and hand every clip the **last real frame** of the one before it (the seam rule again).
4. **Mac shell gotcha:** run the batch scripts with **`bash`, not `zsh`** — zsh counts arrays from **1**, so it quietly feeds your connectors the **wrong frames**.

## [9:38](https://youtu.be/Src-a8GJR20?t=578) The Honest Bill + 2 Moves That Cut It

- Runs on **Higgsfield credits**. Observed Plus-plan pricing: **~15 credits/still, ~40–55/clip.** A **6-scene world** = 6 stills + 11 clips ≈ **500–700 credits** desktop; native mobile **~doubles** the clip count.
- **Cut #1 — draft tier:** **Seedance Mini** renders the whole chain at **~¼ cost**. Fly the journey cheap, approve, then re-render only the final legs at full quality.
- **Cut #2 — free stills:** if you pay for ChatGPT and have **Codex** installed, route all stills through **Codex's built-in image generation** (same GPT Image model) for **zero Higgsfield credits**.
- Because it **estimates before rendering, you approve the bill — you never discover it.**

## [10:46](https://youtu.be/Src-a8GJR20?t=646) Who This Is Really For

- Sites like the Emons world come from agencies at **five-figure prices**. For a freelancer/studio, scroll-world is **a brand-new product on the shelf** this week.
- **The pitch play:** for a local coffee brand / gym / wedding venue / dental clinic — feed their site to the **brand-kit importer**, pick clay-miniature or photoreal, spend **~$30 in draft-tier credits**, and walk in with a **scrollable world of their business**. "You don't sell them a website. You put the laptop down and you scroll, in silence."
- Because the engine is **one portable file**, it drops into whatever they run — **plain HTML, Next, Vue, even a Python-served page** — nothing about their stack changes.

## [11:44](https://youtu.be/Src-a8GJR20?t=704) The Playbook + The Big Idea

- The presenter's free **"Scroll World Playbook"** (comment "scroll" / link in description) collects the 3-piece pipeline, the seam-rule diagram, install commands, style-preamble templates, content-filter fixes, and the credit math.
- **The framing to remember:** for 30 years scrolling meant *reading*; this is the first time the **scroll wheel became a movie camera** — and the people who learn to build these worlds first will be hard to compete with.

---

## Tools & Links

- **scroll-world** (the skill, MIT, by oso95): https://github.com/oso95/scroll-world
- **Install** — Claude Code: `plugin marketplace add oso95/scroll-world` + `plugin install`; Codex/Cursor: Vercel **Skills CLI** (`npx skills ...` — see [[skills_sh_vercel_marketplace]]).
- **Models used:** GPT Image 2 (stills; free via **Codex** built-in image gen), **Higgsfield** (camera-flight video credits), **Seedance / Seedance Mini** (video + cheap draft tier), **Kling** (content-filter fallback).
- **Inspiration:** Emons (German logistics) scroll-world site; Apple product pages (the scroll-scrub technique).
