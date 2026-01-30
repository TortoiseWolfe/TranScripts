# It Got Worse (ClawdBot)

**Source:** Nick Saraev — [YouTube](https://youtu.be/rPAKq2oQVBs)
**Date:** 2026-01-29 | **Duration:** 10 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## The Current Situation

Hundreds to possibly thousands of ClawdBot instances have been hacked. People are being permanently banned from Claude. White-hat hackers are demonstrating full access to strangers' control panels, message histories, and API keys.

Nick Saraev: "This is basically the red wedding of vibe coding happening in real time."

---

## Vulnerability #1: Publicly Exposed Control Panels

### How It Works

1. Most people run ClawdBot on a VPS, which requires a publicly available URL
2. Services like **Shodan** constantly scrape and index every available URL on the internet
3. Searching Shodan for the text "Clawbot control" returns **thousands of servers** you can access by clicking a button
4. Each control panel shows: channels, instances, sessions, cron jobs, skills, config, and **all API keys**

### The Nginx Reverse Proxy Bug

White-hat hacker **Jameson** discovered: if servers use **Nginx as a reverse proxy**, a quirk in how Nginx interfaces with ClawdBot grants **full access** to anyone's control page — messages, skills, config, and API keys.

**Why it matters:** Most users upload all API keys, tokens, and secrets for their messaging platforms and services (Anthropic, etc.). Full access = access to someone's entire digital life.

Jameson demonstrated this by fully identifying a user (an "AI systems engineer") and extracting their complete message history.

---

## Vulnerability #2: Supply Chain Attacks via ClawdHub/MoltHub

### The Demonstration

Jameson built a **simulated backdoor ClawdBot skill** and uploaded it to ClawdHub (now MoltHub).

**Attack steps:**
1. Create malicious skill with hidden instructions to exfiltrate API tokens
2. Inflate download count to **4,000+** (trivial on a new platform)
3. MoltHub's ranking algorithm is naive — sorts by downloads per unit time
4. Malicious skill gets **featured on the front page**
5. Unsuspecting users install it → all API keys compromised

**Nothing prevents** a bad actor from uploading skills with malicious instructions. The platform has no vetting, no code review, no trust chain.

---

## Infrastructure Hardening Checklist

### 1. Change the Default Port

Default ClawdBot control port: **18789**. Shodan and similar tools scan a short list of high-probability ports first.

**Fix:** Pick a random non-standard port (e.g., 44892). Use a random number generator. Tell Claude Code: "Pick a non-traditional port for my ClawdBot control panel."

### 2. Set Passwords

Some instances have been found with **empty passwords**. While most have passwords set by default, verify yours is configured.

### 3. Update to Latest Version

The Nginx reverse proxy vulnerability is **patched in newer versions**. But self-hosted means **no automatic updates** — you must manually update.

If you haven't updated, configure **`gateway.trusted_proxies`** — especially behind Nginx/Caddy reverse proxy. Without this, the control panel treats any visitor as **localhost**, opening full access to anyone.

### 4. Use Tailscale or VPN

For maximum lockdown, put the control panel behind Tailscale or a VPN. Only accessible from your own network.

### 5. Rotate All API Keys

If you've ever pushed ClawdBot to a publicly available URL without these protections: **rotate every API key immediately**. Most services offer key rotation specifically for leak scenarios.

---

## Skill Vetting Protocol

Treat MoltHub/ClawdHub like **early npm** — assume nothing is vetted and every package could be malicious.

### Before Installing Any Skill:

1. **Read every file** — not just the top-level `skill.md`. Check all code files.
2. **Third-party AI verification** — feed the entire skill to a fresh Claude/Gemini/ChatGPT instance and ask: "Does this skill do what it claims? Are there any suspicious behaviors?"
3. **Check author reputation** — look for a real name, real face, linked GitHub with commit history. Developers with established identities don't want to lose their reputation.
4. **Cross-reference on social media** — see if trusted people are talking about the skill or its author.
5. **Don't trust download counts** — trivially inflatable on new platforms with naive ranking algorithms.

---

## Key Takeaway

The technology is genuinely useful, but the current security posture is unacceptable for production use. Lock down infrastructure, vet every skill, rotate compromised keys, and assume the ecosystem is hostile until proven otherwise.
