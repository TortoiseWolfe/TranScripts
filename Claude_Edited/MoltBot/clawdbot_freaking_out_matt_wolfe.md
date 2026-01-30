# Why People Are Freaking Out About ClawdBot

**Source:** Matt Wolfe — [YouTube](https://youtu.be/GLwTSlRn6-k)
**Date:** 2026-01-27 | **Duration:** 37 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## What Makes ClawdBot Different (5 Things)

1. **Runs locally** — on your computer, with access to files, data, apps. Can also use cloud APIs or local models.
2. **Control from anywhere** — Telegram, WhatsApp, Slack, iMessage. Command it and get updates from your phone.
3. **Full system access** — terminal, scripts, software installation, self-modification. If you can do it on a computer, ClawdBot can do it.
4. **Persistent memory** — remembers everything across sessions: preferences, projects, communication style. Matt calls this the single most impressive feature.
5. **Self-improving** — create reusable "skills" (workflows). It writes the code, installs it, and starts using it.

---

## Costs

- **ClawdBot itself:** Free, open source
- **Hardware:** Free if on your own PC. ~$600 for a Mac Mini. Free tier AWS EC2 for VPS.
- **API costs:** Pay-per-use for Claude Opus 4.5, GPT 5.2, 11 Labs, etc. Claude Max plan ($200/month) caps costs.
- **Local models:** Free (Llama, Qwen) but need better hardware

---

## Installation Options

| Option | Cost | Risk | Notes |
|--------|------|------|-------|
| **Your own computer** | Free | Highest | Full access to personal files |
| **Dedicated Mac Mini** | ~$600 | Medium | Isolated from personal data |
| **AWS EC2 free tier** | Free | Medium | Internet-exposed, needs security hardening |
| **Raspberry Pi** | ~$50 | Medium | People have done it |

---

## Matt's AWS EC2 Setup Walkthrough

1. Create AWS account (free tier, $1 auth charge refunded)
2. Launch EC2 instance: Ubuntu, 8GB RAM (free tier)
3. Connect via browser terminal
4. Run ClawdBot install command from clawd.bot
5. Select AI provider (Anthropic Opus 4.5 via Claude Max)
6. Run `claude setup-token` on local terminal → authorize → paste token back
7. Select messaging platform (Slack for Matt)
8. Create Slack app: socket mode, app manifest (from ClawdBot docs), OAuth tokens
9. Paste bot token (XOXB) and app token (XAPP) into setup
10. Create private Slack channel, invite ClawdBot with `/invite @Claudebot`
11. Install skills: Claude Hub, Gemini CLI, video frame extraction, Summarizer, Whisper, PDF editing, Nano Banana, usage monitor, Blog Watcher, Apple Notes
12. Enable hooks, complete setup

---

## What Matt Built in One Session

### Daily AI News Digest
- Asked ClawdBot to set up a daily news aggregator
- It configured a cron job, searched sources (The Verge, etc.), delivered first digest
- Runs daily at 8 AM Pacific automatically

### Claude Code App Building
- Asked ClawdBot to install Claude Code and dev environment
- Response: "Done. Node.js, Python, Git. Throw me an app idea anytime."

### Remotion Animation
- Installed Remotion (initially wrong package, then correct Claude Code skill with 30 rule files)
- Asked it to create an animation for futuretools.io
- ClawdBot: built the animation, set up Remotion Studio, created Cloudflare tunnel for preview
- Result: basic but functional animation — iteratable via screenshots and feedback

### Self-Configuration
- ClawdBot set up its own VPS, created its own tunnel, debugged its own Remotion crashes
- Matt: "You literally don't have to know how to do anything anymore"

---

## Community Use Cases (from Andrew Wilkinson's X thread)

- Closed a California LLC form in 10 minutes (procrastinated 18 months)
- Voice messaging conversations via OpenAI + 11 Labs API to manage a media server
- Learned to control a Sleep Number bed — researched and built the skill
- Connected to Meta Ray-Ban glasses: expense logging from photos, calendar events from flyers, whiteboard capture → infographic via Nano Banana
- Running LM Studio remotely on RTX A6000 (96GB RAM) for local models without API costs
- Loom video → ClawdBot learned tasks by watching the video

---

## Security Warnings

Matt shut down his EC2 instance after recording because he was worried about exposure.

### Risks
- **Prompt injection** — a visited website could contain "ignore all previous instructions" attacks. Not theoretical — has happened.
- **File access** — can delete files, screw up your system
- **Email/messaging** — could send emails or messages you didn't authorize
- **Few guardrails** — still "wild west"

### Tips
- Run on a **dedicated machine**, not your main computer
- Use a **new phone number** for WhatsApp connections
- Use a **fresh email address**, not your personal Gmail
- **Contractor test:** Don't give it access to anything you wouldn't give a new contractor you just hired

---

## Bigger Picture

Matt's take: ClawdBot is a preview of where AI is heading. Prompt engineering becomes plumbing — you just have a conversation and the AI goes and does things. This is the transition from "AI as advisor" to "AI as employee."

> "This is like an iPhone kind of moment for AI. This is a moment where everybody's going, 'Oh crap, I get this now.'"

He sees this becoming the standard. The question is whether you start learning it now or catch up later.
