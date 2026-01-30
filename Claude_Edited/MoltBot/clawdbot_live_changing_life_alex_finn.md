# LIVE: How I'm Using ClawdBot to Change My Life

**Source:** Alex Finn — [YouTube](https://www.youtube.com/live/6RMpUnvHmJw)
**Date:** 2026-01-28 | **Duration:** 60 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns. Live stream format — Q&A with demos.

---

## OOTH (OAuth) vs. API Keys

Using the Claude Max subscription ($200/mo) via OAuth to power ClawdBot is against Anthropic's terms of service. Some users report getting tokens revoked.

**Alex's position:** Use OAuth anyway. If revoked, switch to API. API usage with any regularity costs significantly more than $200/month.

**Alternative models tested:**
- **Kimmy K2.5** — reportedly near-Opus quality, needs more testing
- Nothing else comes close to Opus for both intelligence and personality

---

## Hardware Prediction: 12-Month Bum Rush

Alex predicts a hardware buying surge within 12 months:

1. ClawdBot goes mainstream → companies cut off OAuth access
2. API costs become extreme → users pivot to local models
3. Local models improve rapidly (Kimmy K2.5 ≈ Opus, runs on 2 Mac Studios for ~$30K)
4. Hardware demand spikes → prices increase

**Specific predictions:**
- Mac Studio M5 (June 2026): slightly more expensive than current
- Mac Studio M6 (2027): **double** current prices
- Mac Mini M6 (2027): minimum $1,000 (up from $600)

**Alex's investment:** Mac Studio M3 Ultra, 512 GB memory, $8,400 (with Apple employee discount; $10K retail). He believes this setup will cost $20K+ in 18 months.

---

## VPS vs. Local Hardware

| Factor | VPS | Local (Mac Mini) |
|--------|-----|-----------------|
| **Default security** | Not secure — must configure manually | Secure by default (behind firewall) |
| **Cost** | Low monthly | One-time $600+ |
| **Oversight** | Remote only | Watch agent work in real-time |
| **Apple ecosystem** | None | AirDrop files from iPhone/iPad |
| **Fun factor** | Low | High — "there's an AI agent on my desk" |

**Strong recommendation:** Local hardware over VPS for non-technical users. VPS instances are being scanned and hacked (Shodan). Mac Mini secure by default; VPS not secure by default.

---

## Memory Fix (Critical Config)

Two memory features are **disabled by default** in ClawdBot:

1. **`compaction.memoryFlush.enabled`** — Before context gets wiped during compaction, saves everything important and puts it back into context
2. **`memorySearch.experimental.sessionMemory`** — Allows AI to search through every past conversation, even ones it no longer remembers, for relevant context

**Fix:** Paste Alex's prompt (from the livestream description) into ClawdBot to enable both features. Solves the problem of ClawdBot forgetting context and acting like a fresh session after compaction.

---

## Brain + Muscles Architecture

**Brain** = the model you talk to, that decides what to do and which tools to use.
- Best: **Claude Opus 4.5** (highest intelligence + personality)

**Muscles** = specialized tools the brain delegates to:
- **Codex CLI (GPT 5.2)** — coding tasks. Saves Claude tokens by offloading code generation.
- **Gemini / Nano Banana Pro** — image generation (thumbnails)
- **11 Labs** — voice synthesis
- **Local models via Ollama** — future direction for privacy and unlimited usage

**Cost-saving tip:** Tell ClawdBot "Please use Codex CLI for any coding activities." This offloads coding from your Claude subscription to your ChatGPT subscription, reducing token usage and making OAuth usage less suspicious to Anthropic.

---

## Demos Shown

### Second Brain (Built Proactively)
ClawdBot built a Next.js app on its own initiative that:
- Records all conversations into journal entries daily
- Creates documentation on important conversations
- Built a document viewer interface
- Writes workflow improvement ideas
- Self-improving system — no prompting required

### CRM (Built Proactively)
ClawdBot built a V1 CRM without being asked. Vision for full version:
- Monitor emails and text messages in real-time
- Record names, conversations, important details, follow-up items
- Auto-tag contacts (coworker, follower, etc.)
- Track all interactions across platforms (posts, replies, YouTube views)

**Why Alex hasn't enabled email/text monitoring yet:** He's a high-profile target (followers = attack surface). Gets 100+ phishing attempts daily. Waiting for better prompt injection protections before connecting those channels.

### Morning Brief (8 AM Daily)
Configured with a single prompt. Includes:
- Weather
- **Competitive radar** — researches other AI YouTube channels overnight, flags videos that outperform their channel's average (outlier detection)
- **Mission control** — connected to Things 3 to-do list. Shows what Henry did overnight, what it plans to do today, and what Alex needs to do
- **Trending stories** — finds articles based on Alex's interests
- **Ideas for the day** — recommends productive tasks

### Mac Studio Workflow Vision
Planned pipeline using multiple local models on 512 GB Mac Studio:
1. Local model watches downloads folder for new video recordings
2. Hands off to transcription model
3. Transcript → description + chapter markers
4. Flux (local image model) → 10 thumbnail options
5. Audio model → translations in 20 languages
6. All outputs organized into upload-ready folder

---

## Security Stance

**Core principle:** "With great power comes great responsibility." Don't avoid powerful tools because of risk — use them responsibly.

**Practical advice:**
- Security step #1: Don't let other people talk to your ClawdBot. No group chats, no shared Discord servers.
- Don't give it access to email/texts until prompt injection protections mature
- File system access alone is still highly valuable
- "If you're so scared to use a tool because bad things might happen, you're in the permanent underclass"

---

## Don't Use ClawdBot For Trading

Using ClawdBot for stock/crypto trading is "the stupidest thing you can do." AI models can't compete with microsecond trading systems built by Goldman Sachs engineers. You're gambling, not trading. Use the technology to improve your life, learn, and build — not to speculate.

---

## Messaging Platform Recommendation

**Telegram preferred** over iMessage:
- Simpler setup, more out-of-the-box
- iMessage integration is hacky (Apple doesn't want third-party access)
- New Telegram features: **threading** (multiple conversation threads with one bot) and **chunking** (word-by-word streaming like chatgpt.com)
- WhatsApp and Discord also work well

---

## Key Quotes

On going all-in: "When you find an obsession, get all the way obsessed. If you half-measure it, someone who gets obsessed will destroy you."

On the viral moment: "I tweet a picture of my Mac Mini — '24/7 AI employee acquired.' Two million likes. Saturday everything goes insane."
