# Graphify + Obsidian: Build an AI Second Brain That Never Forgets — Cloud Codes

Source: https://youtu.be/22iy2mDFiF8
Speaker: Cloud Codes (AI/dev-tooling explainer channel) · published Jul 19, 2026 · ~9.5 min

> A system-design walkthrough of **agent memory as a maintained knowledge graph** rather than a vector index. The problem: a coding assistant starts every chat having read nothing, so it re-derives your architecture from files on every question — a per-query token tax that a bigger context window makes *worse*, not better. The fix, traced to **Andrej Karpathy's "LLM wiki"** sketch: do the expensive reading **once**, persist it as an explicit graph of entities and relationships, and let the model **walk the map** instead of rereading the library. **Graphify** is the tool that implements this (three ingest passes, confidence-labeled edges, incremental rebuilds, exports to Obsidian/Neo4j/MCP); **Obsidian** is where the graph lands as plain Markdown you own. The last third is the honest part most tutorials skip: these vaults **rot** — via scale, confident fiction, and AI-quoting-AI feedback loops — unless you run Karpathy's third operation, **lint**, every week.

> **Related:** The memory/context-discipline counterpart to the agent-workflow patterns in [[stop_using_claude_code_like_this_subagents]] and [[stop_telling_claude_meta_prompting]]; the "graph rebuilds on every commit" idea is the same automation surface as [[claude_code_hooks_indydevdan]]. Note the self-referential angle for this repo: `MEMORY.md` + `memory/*.md` is already a hand-run instance of Karpathy's three-layer wiki, and the **"do not add anything I didn't write"** rule at [8:12] is the same discipline as the **No Fabrication Policy** in this repo's `CLAUDE.md`.

> ⚠️ **Sourcing note:** every adoption figure below (90k stars, 50k likes, 14k gist stars, the 71× benchmark) is the video's own unverified claim, several of them implausibly large. They are recorded here as *what the speaker said*, not as fact. Verify before citing. The architecture and the failure modes are the durable content.

---

## [0:00](https://youtu.be/22iy2mDFiF8?t=0) The Problem — Your Assistant Has Amnesia

- **Every new chat, the assistant has read nothing.** Ask how the login flow works and it opens every file from scratch to reconstruct the answer.
- Across **200 files, on every single question**, that is a recurring **token tax** — you pay to rebuild the same knowledge repeatedly.
- **Bigger context is not the fix:** stuffing the entire repo into a giant context window "just makes the answers worse." (Context rot — dilution, not comprehension.)

## [0:26](https://youtu.be/22iy2mDFiF8?t=26) Karpathy's Fix — Give It a Wiki It Maintains Itself

- The core reframe: **stop making the model rebuild your knowledge every query — give it a wiki it keeps up to date itself.**
- Timeline as told: Karpathy posted the idea **April 3rd**; a developer shipped **Graphify** two days later. [REVIEW: no year stated; "90,000 GitHub stars in ~3 months" is an extraordinary claim — verify against the actual repo before repeating]
- **Pair it with Obsidian** and the graph becomes **plain Markdown you own** on your own disk.
- Roadmap for the talk: how the graph gets built → why Obsidian is its home → **the four ways it falls apart if you get lazy.**

## [0:58](https://youtu.be/22iy2mDFiF8?t=58) The Adoption Wave (claimed)

- "Claude Code + Obsidian" posts: **50,000+ likes on X in a week**; one "note-taking is dead" post at **54,000** on its own.
- Karpathy's gist alone: **14,000 stars, 900 forks.** [REVIEW: all figures unverified]

## [1:18](https://youtu.be/22iy2mDFiF8?t=78) Why RAG / Vector Search Is the Wrong Shape for Code

- **Standard RAG:** chunk files → embed as vectors → retrieve nearest matches per question.
- **Works great for prose. Shaky for code** — and the reason is structural, not a tuning problem:
  - The link between **a function and its callers is not lexical similarity.** It **lives in the call graph.**
  - Embeddings can't see an edge that no words share.
- Net effect: **"you pay to load the whole library just to find one paragraph."**

## [1:42](https://youtu.be/22iy2mDFiF8?t=102) The Graphify Model — Read Once, Then Walk the Map

- **Invert the cost curve:** do the expensive reading **once, up front**; compress the project into an **explicit graph of entities and the relationships between them.**
- Afterward, answering a question = **walking the graph**, not rereading files.
- **The human analogy that justifies it:** this is how a senior engineer already works — **build the mental map once, then follow it.**
- **Not code-only.** One graph absorbs **SQL schemas, shell scripts, R notebooks, architecture PDFs, even recorded video** — so **application code, database schema, and infrastructure finally sit on the same map** instead of in five different people's heads.

## [2:21](https://youtu.be/22iy2mDFiF8?t=141) Running It

- Inside **Claude Code, Codex, or Cursor**: type **`/graphify`** and point it at a directory.
- It writes a **`graphify-out/` folder next to your code** with the whole graph persisted **to disk**.
- **Assistant-agnostic** — not locked to one vendor.

## [2:40](https://youtu.be/22iy2mDFiF8?t=160) The Three-Pass Architecture — and Where Your Data Goes

The design point worth stealing: **it does not treat every file the same way**, and each pass has a different privacy story.

| Pass | Input | Method | Leaves your machine? |
|---|---|---|---|
| **1 — Code** | Source files | **Tree-sitter** (compiler-grade parser), **40 languages** | **No** — deterministic, no model, no network |
| **2 — Recordings** | Audio / video (e.g. a recorded design meeting) | **faster-whisper**, transcribed **locally** | **No** — nothing uploaded |
| **3 — Docs & images** | PDF specs, whiteboard photos | Sent to **your AI provider** to be interpreted | **Yes** — but via **your own API key**, no middleman |

- **Pass 1 is deterministic**, so **every link it finds is tagged as a hard fact** — the graph's trustworthy backbone.
- **Pass 3 is the only egress.** Want it fully private? **Run code-only mode and skip pass 3.**

## [3:45](https://youtu.be/22iy2mDFiF8?t=225) Confidence Labels — Edges That Admit What They Are

Every connection in the graph carries a provenance label:

- **`Extracted`** — it's literally in your code. **Trust it.**
- **`Inferred`** — the model reasoned it from context. **Probably true.**
- **`Ambiguous`** — **the model itself raised a hand.** Check before you build on it.

> This is the single most portable idea in the video: a knowledge store that **encodes its own uncertainty per-edge** instead of flattening derived guesses into facts. It is also the direct antidote to Crack 3 below.

## [4:00](https://youtu.be/22iy2mDFiF8?t=240) Modules Fall Out of the Graph by Themselves

- Graphify runs **community detection** over the graph; **your modules emerge from the shape of the code** — auth in one cluster, billing in another, infrastructure on its own — with the **bridge files between clusters lit up.**
- **"You didn't draw that map. The relationships did."**

## [4:18](https://youtu.be/22iy2mDFiF8?t=258) Query Time — The Payoff

- Ask *"How does a user log in?"* → instead of loading 50 files, it **walks the graph and returns a short path: three hops, zero files opened.** The assistant reads **a few node summaries** rather than half the repo.
- Three query modes:
  - **`graphify explain`** — plain-English tour of any entity.
  - **`graphify path`** — shortest chain between two things (e.g. auth → the database pool it secretly leans on).
  - **deep mode** — hunts the **fuzzier inferred links** a fast pass would skip.

## [4:53](https://youtu.be/22iy2mDFiF8?t=293) The 71× Claim — and the Caveat

- Claimed: **~71× fewer tokens per query** on a mixed codebase.
- **Stated caveat, verbatim in spirit:** *their own benchmark, on their own data, not independently reproduced* — **take the exact figure with a grain of salt.**
- **The direction is still sound:** walking a map is cheaper than rereading the whole library every time. [REVIEW: treat 71× as marketing until reproduced]

## [5:09](https://youtu.be/22iy2mDFiF8?t=309) Exports — The Graph Isn't Trapped in the Tool

- **Clickable HTML graph** (rendered with vis.js)
- **Plain JSON** for scripts
- **Markdown report** of your busiest files
- **Neo4j database**
- **An MCP server** — so **any agent can call your codebase graph as a built-in tool**

## [5:32](https://youtu.be/22iy2mDFiF8?t=332) Staying Current Without Babysitting

- Every file gets a **SHA-256 hash**, so **re-runs only reread what changed** (incremental, not full rebuild).
- **Add a git hook → the graph rebuilds on every commit**, so the assistant always sees a map matching **the exact branch you're standing on.**

## [5:46](https://youtu.be/22iy2mDFiF8?t=346) Why Obsidian Is the Right Home

- Obsidian = **plain Markdown files on your disk**, not on someone's server. Claimed **~1.5M users**, plugins past **100M downloads.**
- **Graphify's Obsidian export → a real vault:** every **entity becomes a page**, every **relationship becomes a `[[wikilink]]`**, and **Obsidian's graph view renders the whole thing as a browsable web** — your codebase as a mind map you can wander on a Sunday.

## [6:18](https://youtu.be/22iy2mDFiF8?t=378) Closing the Loop — Claude Code in the Obsidian Sidebar

- **Claudian** drops **Claude Code straight into the Obsidian sidebar.** The **vault becomes the agent's working directory** — it reads notes, writes new ones, and runs commands without leaving the app your knowledge lives in.
- **You don't have to grant full write access on day one.** Escalation ladder of alternatives:
  - **Smart Connections** — read-only; surfaces related notes via embeddings.
  - **Khoj** — self-hosted, run-it-all-locally option. [REVIEW: name inferred from audio ("Cudge") — verify spelling]
  - **Copilot for Obsidian** — vault-aware chat, claimed 100,000+ users.
- **"Start light, then give it more rope."**

## [6:52](https://youtu.be/22iy2mDFiF8?t=412) Karpathy's Three-Layer Wiki Design

The underlying architecture, which is deliberately simple:

**Three layers**

1. **Raw** — a folder of source material **the AI never touches.**
2. **Wiki** — the layer **the AI does own**: it writes the pages and keeps the cross-links honest.
3. **Schema** — a file telling the model **how your wiki is laid out.**

**Three operations**

1. **Ingest** — pull in new sources, update **every page they touch.**
2. **Query** — search the wiki, answer **with citations.**
3. **Lint** — health check for **contradictions, dead pages, and stale claims.**

> **Remember `lint`.** It's the operation everyone skips and the reason these systems fail.

## [7:27](https://youtu.be/22iy2mDFiF8?t=447) The Idea Is From 1945 — Vannevar Bush's Memex

- Karpathy traces the concept to **Vannevar Bush's Memex (1945)**: the dream of **link trails between documents**, where **the links matter as much as the pages.**
- **What was always missing was maintenance** — no one is patient enough to keep the trails current. **The model now does that upkeep for free.** That, not storage, is what actually changed.

## [7:45](https://youtu.be/22iy2mDFiF8?t=465) The Catch — Four Cracks the Viral Demos Skip

### [7:56](https://youtu.be/22iy2mDFiF8?t=476) Crack 1 — Scale

- **50 tidy notes feels like magic. 2,000 notes becomes a search problem all over again**, because the model burns its context **navigating your structure instead of answering your question.**
- **The graph softens this. It does not erase it.**

### [8:12](https://youtu.be/22iy2mDFiF8?t=492) Crack 2 — Confident Fiction

- Writing up your notes, the assistant **cheerfully fills gaps with things you never said — in your own voice.**
- **The fix is a blunt instruction:** ***"Do not add anything I didn't write."***
- Without that rule, **your second brain starts inventing memories.**

### [8:29](https://youtu.be/22iy2mDFiF8?t=509) Crack 3 — The Feedback Loop

- The AI writes a page → **weeks later cites its own page as a source** → builds further on top of it.
- Unattended, you get **AI quoting AI**, where **small mistakes harden into facts.** The vault **fills with its own echo.**

### [8:45](https://youtu.be/22iy2mDFiF8?t=525) Crack 4 — Skipping Lint (the big one)

- **Karpathy put a cleanup pass in the design on purpose, and almost every tutorial drops it.**
- **The whole maintenance cost: ~5 minutes a week** — read what the agent wrote, **prune stale pages, kill contradictions.**
- **Skip it → decays into noise. Do it → compounds into something real.**

## [9:03](https://youtu.be/22iy2mDFiF8?t=543) The Verdict

- A second brain that never forgets **is genuinely here** and is the best version we've had — **but memory cuts both ways: it also keeps every bad note and lazy guess** unless you clean up after it.
- **Own your Markdown. Keep it on your disk. Treat the weekly lint pass as the rent.**
- **Start embarrassingly small: one folder, one graph, one vault.** Let it earn trust **on a project you already understand** before feeding it your entire life.
- **"The people who win with this aren't the ones with the sickest demo — they're the ones whose vault still tells the truth three months from now."**

---

## Portable Takeaways

1. **Persist the map, don't re-derive it.** Pay the reading cost once; make retrieval a graph walk.
2. **Structure beats similarity for code.** Call graphs are edges, not embeddings — RAG is the wrong shape for the question.
3. **Label every edge with its provenance** (`extracted` / `inferred` / `ambiguous`). A memory that can't express doubt will launder guesses into facts.
4. **Keep the ingest boundary explicit.** Deterministic-local, transcribe-local, model-remote — know exactly which pass leaves your machine.
5. **Make the memory incremental and hook-driven** (content hash + git hook), or it silently goes stale.
6. **The wiki layer must be separate from the raw layer.** The AI owns one; it never touches the other.
7. **`lint` is not optional.** Without a scheduled human pass, feedback loops and confident fiction guarantee decay.
8. **Ban invention explicitly.** "Do not add anything I didn't write" is a load-bearing instruction, not a nicety.
