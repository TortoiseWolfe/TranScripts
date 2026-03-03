# OpenClaw: Cost-Efficient AI Agent Architecture

**Source:** "I Built a Python-Powered OpenClaw Agent That Finds Jobs 24/7" — Python Simplified (2026)

**Focus:** OpenClaw platform, agent architecture, cost optimization, tool availability, WhatsApp integration, sandboxing

---

## What is OpenClaw?

- **Open-source AI assistant platform** (formerly Clawdbot, then Moltbot)
- Connects to **WhatsApp, Telegram, Discord** and other messaging platforms
- Lets you talk to AI agents (ChatGPT, Gemini, Grok, others) through these channels
- Can be self-hosted on a VPS for **always-on availability**

## The Cost Problem with AI Agents

- Running an AI agent for heavy, repetitive tasks **burns through credits fast**
- 10 Nexus AI credits lasted less than a day of heavy use (troubleshooting, complex tasks)
- 40 credits is "plenty" for typical use; 10 is not
- **Key insight:** Credits purchased at registration may include a bonus (e.g., buy 20, get 20 free) — this offer is **one-time only**, not available when topping up

### Credit Strategy

- You can use existing subscriptions (ChatGPT, Gemini, Grok) instead of Nexus credits
- **Configure your preferred model from the start** — switching models later requires rewiring
- Don't wait until credits run out to switch to an API key

## Cost-Efficient Agent Architecture

### Core Principle: Separate Compute from Reasoning

- **Python and Bash handle heavy lifting** — fetching data, filtering, scheduling
- **AI agent handles only lightweight reasoning** — final judgment calls on filtered data
- This means you are **not invoking the LLM** for repetitive, predictable tasks

### Data Pipeline

1. **Bash script** (`exec_loop.sh`) — while loop running every N seconds
2. **Python script 1** (`pull_jobs.py`) — fetches RSS feeds via `curl`, applies location/skill filters, writes `jobs.csv`
3. **Python script 2** (`pull_desc.py`) — extracts latest batch from CSV into `desc.json`
4. **OpenClaw reads only `desc.json`** — minimal, pre-filtered data
5. **Agent decides:** Does this match the user's resume? If yes, send WhatsApp alert

### Why This Works

- RSS feeds are **structured data meant for machine reading** — no scraping, no bot blockers
- `curl` is a system-level command — **no pip installs, no Playwright, no Selenium**
- Old listings are automatically excluded — only the freshest batch is analyzed
- The AI agent's work is **trivial** compared to what Python handles for free

## OpenClaw Security Model (One-Click-Deploy)

- The bot runs in a **Docker container** for isolation
- Built-in skills are **blocked by default** — the vast majority are intentionally disabled
- Anything that "may impose a safety risk is simply not allowed"
- This is how the One-Click-Deploy image handles the risk of **external messaging channels**

### Available Tools

Only a minimal set of tools are enabled:
- **Read/Write** — basic file operations
- **Execute** — run bash scripts
- **Web Search / Web Fetch** — can be bypassed with `curl`
- **Cron task management** — schedule and kill recurring tasks

### Agent Configuration

- Navigate to the **Agents tab** to customize your model
- Choose from available models in the dropdown
- View the list of available tools

## WhatsApp Integration

1. Click **Channels → Show QR Code**
2. **Critical:** Click "Wait for scan" immediately
3. Scan QR code from WhatsApp → Linked Devices on your phone
4. After linking, go to **Config tab → Update**
5. Return to Channels tab to confirm connection

- **Warning:** Missing the "Wait for scan" button will leave you stuck for hours
- This setup is **one-time per device**
- Once connected, the bot responds on **both the web interface and WhatsApp**

## Cron Jobs vs Natural Language Instructions

- You can give the agent instructions via chat, but **it doesn't always repeat tasks reliably**
- The agent sometimes "forgets" it can do things
- **Cron jobs are more reliable** — set up in the Cron Jobs tab with a name, schedule, and precise instructions
- Cron instructions should be **specific and precise** — not natural language, but structured directives

### Example Cron Instruction Pattern

> For every cron run, re-load desc.json fresh from disk immediately before analysis. For each job in desc.json, if the job's title or description matches any skill/target_role or fits all preferences in resume.json, and it is new (not already alerted on): Send a WhatsApp alert: Job Match: [job title] ([link]).

## Troubleshooting

- **"Disconnected for no reason" error:** Replace `/chat/session/main` in the URL with `?token=YOUR_TOKEN`
- **Finding the workspace path:** Ask the bot to save a test file, then use `find / -name "testfile.py"` on the server
- **Agent not repeating tasks:** Use cron scheduling instead of chat instructions
- **Credits running out:** Switch to your own API keys, but do it from the start — not mid-project
