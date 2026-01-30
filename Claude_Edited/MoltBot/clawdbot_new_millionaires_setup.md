# ClawdBot Will Make New Millionaires in 2026: Setup Guide

**Source:** Kevin Badi | AI Operating Systems — [YouTube](https://youtu.be/PrWZe0VmnGg)
**Date:** 2026-01-26 | **Duration:** 19 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## What Is ClawdBot?

A 24/7 AI agent that runs locally on your computer. You interact with it via iMessage, Discord, WhatsApp, or Telegram. It has access to Claude Code, your file system, browser tools, and can execute any task autonomously.

Kevin positions it as a replacement for n8n-style automation workflows — everything that used to require a separate automation platform can now live inside ClawdBot running on a dedicated Mac Mini.

---

## Six Core Features

### 1. Built-In Computer Use Tools
- Chrome DevTools and Playwright MCP tools
- Can open a browser, sign into websites, and save session cookies
- Enables automating any software provider (LinkedIn, Instagram, etc.) by giving it your cookie sessions

### 2. Local Execution
- Runs on your machine with your IP address — more reliable for software logins than cloud VPS (IP stays consistent)
- Sign into any provider via prompt, save session cookies, agent accesses them anytime

### 3. Full macOS Access (Mac Mini)
- Terminal, Notes, Apple notification triggers
- GPU, CPU, RAM, full file system access (videos, audio, images)
- Can create scheduled notifications, send texts, emails

### 4. Vibe Coding from Anywhere
- Access to Claude Code and GitHub repositories
- Tell the agent via text to pull a repo, add skills, write code
- Build apps from your phone

### 5. Cron Job Scheduling
- Build a workflow → test it → set it on a schedule — all via text
- Enable, disable, update frequency, run manually to test
- Replaces n8n's scheduled workflow functionality

### 6. Skills Integration
- Give ClawdBot any skill from your other repos
- Pull skills from GitHub repositories
- Build specialized AI employees with different skill sets

---

## iMessage Demo Highlights

Kevin named his agent "Zeus" and demonstrated via iMessage:

- **Playwright confirmation** — agent confirmed browser control was already set up
- **Cron scheduling** — agent can create, enable/disable, and test scheduled workflows via text
- **GitHub integration** — agent opened GitHub on the computer, signed in, sent Kevin the verification code, got authorized
- **Cookie session management** — agent confirmed it can handle multiple cookie sessions for different software providers
- **Supabase setup** — agent created a Supabase database account using a Gmail provider

---

## Setup Walkthrough (Step by Step)

### Prerequisites
- **Dedicated Mac Mini recommended** — don't run on personal computer (agent gets access to iMessage, Gmail, all files)
- Full disk access granted to Cursor and Terminal (System Settings → Privacy & Security → Full Disk Access)

### Installation Steps

1. **Install ClawdBot:** Run the curl install command from clawd.bot homepage
2. **Choose AI provider:** Select Claude Opus 4.5
3. **Authenticate:** Run `claude setup-token` in a new terminal → authorize in browser → copy OAuth token back to ClawdBot
4. **Name the instance** (e.g., "ClawdBot agent tutorial")
5. **Select model:** Opus 4.5
6. **Choose messaging platform:** Telegram, WhatsApp, Discord, Google Chat, or iMessage

### Configuring Skills

Built-in skills available during setup:
- **CamSnap** — camera access for photos/video
- **Claude Hub** — hub integration
- **MC Porter** — MCP tool management
- **Nano PDF** — PDF handling
- **OpenAI / Whisper** — additional AI models, speech-to-text
- **Peekaboo** — screen capture
- **Summarize** — content summarization
- **Things Mac** — task management integration

Optional API keys: Google Places, Nano Banana (image generation), OpenAI, Whisper

### Enabling Hooks

Two recommended hooks:
1. **Command Logger** — logs every command/code execution to an audit file for review
2. **Session Memory** — persists solutions to errors so the agent doesn't repeat mistakes

### ClawdBot Gateway

Web-based dashboard that opens after setup:
- Chat interface
- Channels, instances, sessions
- Cron jobs management
- Skills management
- Nodes overview

### iMessage Pairing

1. Send yourself a text message from the computer
2. Agent responds with a pairing code
3. Paste pairing code into the ClawdBot environment
4. Connected — agent responds to iMessage texts

**Important:** Use a separate iMessage account on the Mac Mini. If you use your personal account, the agent will respond to anyone who texts you.

---

## Key Warning

**Use a dedicated computer.** Running ClawdBot on your personal machine gives it access to your personal iMessage, Gmail, and all files. You don't want it randomly sending emails or messages, or creating a security risk.
