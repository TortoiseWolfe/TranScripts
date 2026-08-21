# Career — Cowork Manifest

Read this file first. It tells you which of the ~590 files in this folder to load,
and — more importantly — which to leave alone.

This folder is large enough that "read everything in here" will burn a large share
of a task's context before any actual work starts. Load by tier.

---

## Tier 1 — Canonical. Read these first, every task.

| File | What it is |
|---|---|
| `CLAUDE.md` | Folder rules, including the **No Fabrication Policy** |
| `Resume_Edited/private/resume.md` | Master resume. Single source of truth for work history |
| `Resume_Edited/RESUME_SYSTEM_PROMPT.md` | Resume review frameworks (6-second scan, Action+Task+Result) |
| `CoverLetter_Edited/COVERLETTER_SYSTEM_PROMPT.md` | Cover letter frameworks (3-paragraph structure) |
| `LinkedIn_Edited/LINKEDIN_SYSTEM_PROMPT.md` | LinkedIn review frameworks |
| `JobSearch/private/tracker.md` | Master application tracker, 60+ scored rows |
| `JobSearch/private/inbox.md` | Action queue: applied / ready / deferred / leads |

Together these are small — a few thousand tokens. Everything else is on demand.

---

## Tier 2 — Domain. Load only when the task touches that domain.

| Domain | Path | Notes |
|---|---|---|
| Resume variants | `Resume_Edited/private/*.rtf`, `*.docx` | WebReact, DotNet, AI, ReactNative, OfficeMgr, GraphicDesign, ABG |
| Cover letters (current) | `JobSearch/private/cover-letters/` | 18 letters, `.md` + `.docx`, Feb 2026 |
| Cover letters (earlier) | `CoverLetter_Edited/private/*.rtf` | 7 letters incl. ABG (Apr 2026, newest) |
| Cover letter templates | `CoverLetter_Edited/private/cover-letter-templates.md` | Software/Dev and AI/ML starting points |
| Job research | `JobSearch/private/job-details/` | 23 per-company dossiers |
| Search logs | `JobSearch/private/daily-search-*.md` | 16 logs, 2026-01-30 → 2026-02-19 |
| Coaching frameworks | `Resume_Edited/*.md` | 22 cleaned transcripts, weeks 1–14 |
| LinkedIn coaching | `LinkedIn_Edited/*.txt`, `*.md` | Profile, SEO, networking, outreach |
| Interview prep | `TechInterview/` | 246 files — largest subtree. Scope to the specific file |
| Coach persona | `Chelsea_GPT/` | Packaged Custom GPT: system prompt + knowledge base |

Load one row, not the table.

---

## Tier 3 — Archival. Ignore unless explicitly asked.

These are derived, superseded, or raw. They inflate context and add nothing a
Tier 1/2 file doesn't already say.

- `*/graphify-out/` — 85 files. Derived knowledge-graph cache, regenerable
- `*/timed/` — 97 JSON files. Raw timestamped transcript pulls
- `Resume/*.txt`, `LinkedIn/*.txt` — raw transcripts, superseded by `*_Edited/`
- `Resume_Edited/private/linkedin_export/` — LinkedIn data export dump
- `*_BACKUP.rtf`, `*.zip:Zone.Identifier` — backups and Windows metadata cruft

---

## Known state — read before acting on anything

**The job search is frozen mid-flight.** `tracker.md` and `inbox.md` were last
updated 2026-02-04. They still list 6 applications as "ready to submit." Those
letters were drafted but never sent, and at least one deadline (Alpha Omega,
2026-02-27) has long since passed. Treat every status in those files as stale
until confirmed — do not describe anything there as current.

**A referenced background file is missing.** `JobSearch/README.md` and the
tracker both point to `~/repos/moltbot/AGENTS.md` as the canonical source for
work history, skills, and cover-letter rules. That repo does not exist on this
machine. Do not reconstruct or infer its contents. Use
`Resume_Edited/private/resume.md` as the background source instead, and ask if
something isn't in it.

**The newest thread is a design pivot.** The most recent work (April 2026) is
the ABG Senior Graphic Designer application — resume plus cover letter leaning
on 23 years at Creative Touch rather than the development history. If a task
mentions "the latest resume," clarify which track is meant.

---

## The rule that overrides everything

`CLAUDE.md` in this folder carries a **No Fabrication Policy**. It applies to
every task here:

> Never fabricate, invent, or assume details about work history, skills, or
> experience. Use only what is in `private/` or stated directly. Flag any
> addition with `[VERIFY: assumed detail]`.

Resumes and cover letters are documents someone else will check. An invented
metric is not a draft — it is a liability. When a detail is missing, ask.

---

## Privacy

Every `private/` directory here is gitignored and exists only on this machine.
They hold real personal data: phone number, home address, employment history,
and unsent applications. Nothing from them belongs in a commit, a shared file,
or anything sent outside this folder.
