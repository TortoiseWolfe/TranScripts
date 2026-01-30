# ClawdBot Is Out of Control

**Source:** Wes Roth — [YouTube](https://www.youtube.com/watch?v=7fltOAg8ZGI)
**Date:** 2026-01-27 | **Duration:** 27 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## Peter Steinberger: The Creator

Austrian developer. Founded PSPDFKit (PDF toolkit). Came back from retirement to build ClawdBot. Andrej Karpathy tagged him on X saying "You can do it" in response to the idea of a one-person billion-dollar company.

**Origin story:** Started as "WhatsApp Relay" — a 2-hour hack to type commands from his phone to run on his computer. Then the pivotal moment: he accidentally sent a voice message. 10 seconds later, the model replied. It had:
1. Checked the file headers → found Opus format
2. Used FFmpeg to convert to WAV
3. Tried Whisper (not installed) → found an OpenAI API key → sent to OpenAI for transcription
4. Replied with the answer

Peter: "That's when I saw the potential. These beasts are incredibly smart at general purpose problem solving."

---

## Architecture (From Peter's Demo)

| Component | Purpose |
|-----------|---------|
| **agents.md** | Base system prompt |
| **identity file** | Everything about the user |
| **soul.md** | Core values and behavior rules |
| **bootstrap.md** | First-run personality setup |
| **Markdown daily files + vector search** | Memory system (primitive but effective) |
| **Sub-agents** | Spun up for longer tasks |
| **Cron jobs** | Scheduled tasks |
| **Embedded browser** | Playwright-based, modified for better performance |
| **Heartbeat function** | Calls the agent every 10 minutes with "surprise me" |
| **Client apps** | Knows if user is at computer, can check screen |
| **Peekaboo** | Screen takeover — can click, type, continue tasks |
| **Web server** | File distribution via Tailscale |
| **Native apps** | Morning report with dynamic UI and interactive buttons |

**Key design philosophy:** CLIs are better than MCPs. Peter built **McPorter** to convert any MCP into a CLI. Agents are good at calling CLIs. CLIs scale to 100,000+ on a machine. Progressive disclosure — agent just needs to know a CLI exists, calls `--help`, then uses it.

---

## What People Are Building

- **Restaurant reservations** — when Open Table failed, used 11 Labs to call the restaurant by voice (Alex Finn)
- **Self-teaching skills** — "Here's an 11 Labs key. Learn how to use it." It figured it out.
- **Phone calls** — Twilio (phone number) + 11 Labs (voice) + Deepgram (listening)
- **Voice cloning** — offered to clone the user's voice ("This is why we need AI safety")
- **Tamagotchis** — visual representations of ClawdBot doing tasks
- **Spam filtering** — sorting messages by urgent/non-urgent
- **GitHub issues** — auto-creating from conversations
- **1Password integration** — own vault for storing/retrieving credentials
- **Daily morning briefs** — with pre-meeting research and briefing docs
- **Fitness coaching** — connected to health data, nags about sleep and weight
- **Flight check-in** — found passport on Dropbox, extracted details, checked in on British Airways
- **Full site rebuild** — via Telegram while watching Netflix (Notion → Astro, 18 posts, DNS to Cloudflare)
- **Screen monitoring** — checks if Codex tasks are done, types "continue" while user gets food

---

## Hardware Options

| Option | Notes |
|--------|-------|
| **Mac Mini** | Most popular. Native Mac support. People buying them specifically for ClawdBot. |
| **MacBook** | Wes Roth's approach. Dusted off his old MacBook. |
| **Old Android phones** | 3 phones = 3 agents + sub-agents. "Mac Mini energy, junk drawer budget." |
| **VPS** | Many people hosting on virtual private servers. Cheapest option. |

---

## Installation Walkthrough

1. Go to `clawd.bot` for quick start
2. Open Terminal on Mac → run install command
3. Run `cloudbot onboard`
4. **Security notice** — acknowledge risks
5. **Choose model provider** — Anthropic (Opus 4.5 recommended), OpenAI, Qwen, Google, etc.
6. **Enter API key** from provider
7. **Choose messaging platform:**
   - **WhatsApp** — easiest (QR code scan)
   - **Telegram** — recommended by ClawdBot
   - **Discord** — requires developer portal + bot creation
   - **Slack** — works but API setup needed
8. **Configure skills** — 1Password, Apple Notes, Google Places, Nano Banana Pro (can skip)
9. **Enable hooks** — Wes selected all three on Gemini 3's recommendation
10. **Choose interface** — TUI (recommended) or Web UI
11. **Start chatting** — via TUI, web, or phone messaging app

**Tip:** Use another AI chatbot (Gemini, ChatGPT) to walk you through installation issues.

---

## Security Assessment

### Why Frontier Labs Won't Build This

There's a reason Google, Anthropic, and OpenAI haven't released anything like this. People will get wrecked — data lost, accounts hacked, disasters incoming. The AI labs don't want the liability. Open source means "at your own risk."

### Shodan Scan Results (ZD's Investigation)

- 450 gateways discovered via MDNS
- **Zero vulnerable instances** found in the wild
- 10 publicly accessible gateways all had proper auth tokens
- 429 others bound to localhost (unreachable)

### Prompt Injection Reality

Peter himself acknowledges: "I wouldn't say this is safe. I'm sure eventually this will be prompt injected because nobody has a great solution for that yet."

He tested it in a public Discord (5,000 members including AI researchers and CEOs). People tried to trick it — "it was basically laughing at them the whole time." But he adds this was before sandboxing was implemented.

**Peter's recommendation:** Only use a really good model like Opus 4.5, which has good prompt injection resistance.

---

## Key Insight

Peter sees ClawdBot as a **new product category** — personal agents. The community is still boxed into thinking coding agents are for coding, "when they're really clever beasts and can do anything."

Wes Roth's prediction: The biggest future productivity hack will be giving your AI assistant a full week's worth of tasks before going to sleep. "You wake up to massive amounts of progress. It's like Christmas morning every morning."
