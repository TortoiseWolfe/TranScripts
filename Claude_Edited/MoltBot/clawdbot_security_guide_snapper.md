# Don't Use ClawdBot Until You Watch This (Security Guide)

**Source:** Snapper AI — [YouTube](https://youtu.be/AbCHaAeqC_c)
**Date:** 2026-01-26 | **Duration:** 12 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## Why ClawdBot Needs Security Guardrails

ClawdBot is a 24/7 AI agent running on your server with access to shell commands, file system, browser, calendar, and email. It acts autonomously whether you're watching or not.

**Burak Eregar's warning (400K+ views on X, reposted by ClawdBot creator Peter Steinberger):**

> "Most people will install ClawdBot and accidentally hand it their entire life. If you run this with default settings, you're one prompt injection away from wiping your entire GitHub organization, losing your emails, or much worse."

---

## ClawdBot vs Browser Chat vs CLI Agents

| Type | Access | When Active | Risk Level |
|------|--------|-------------|------------|
| **Browser chat** (Claude, ChatGPT) | Provider's environment only | While you're using it | Low |
| **CLI agents** (Claude Code, Codex) | File system + commands | While terminal is open | Medium |
| **ClawdBot** | Shell, files, browser, messaging, APIs | 24/7, even while you sleep | High |

**Key difference:** Anyone who can message ClawdBot can potentially trigger its capabilities. A malicious message, hidden instructions in a link, or a crafted document could manipulate it into running commands, exfiltrating data, or taking unauthorized actions.

---

## 5 Security Steps Before Deploying

### Step 1: Enable Sandbox Mode

By default, ClawdBot has **no sandbox configuration** — commands execute directly on your server with full access.

**Add sandbox config to `claudebot.json`** inside the `agents.default` section:

| Setting | Recommended Value | What It Does |
|---------|-------------------|--------------|
| **mode** | `all` | Every session runs inside a Docker container |
| **scope** | `session` | Each conversation gets its own isolated container |
| **workspace_access** | `none` | Sandbox can't access agent workspace directory |

**Mode options:**
- `all` — safest, everything sandboxed
- `non-main` — personal DM unsandboxed, group chats isolated

**Scope options:**
- `session` — strongest isolation (one container per conversation)
- `agent` — one container per agent
- `shared` — single container for everything

**Requires Docker** installed on your server. Run `claudebot gateway restart` after changes.

**Sandboxing isn't bulletproof** — it reduces blast radius, not eliminates risk.

---

### Step 2: Whitelist Tools

By default, ClawdBot gives the agent access to **all tools**: file reading, writing, shell execution, browser control, and more.

**Restrict via allow list and deny list** in your config. Example: allow file reading and web search, block shell execution and browser control.

**Key distinction:**
- **Sandbox mode** limits blast radius if something goes wrong
- **Tool policies** limit what can happen in the first place
- **Combining both** gives layered protection

---

### Step 3: Run the Security Audit

Three built-in commands:

1. **`claudebot security audit`** — checks config for common issues (credential permissions, attack surface, elevated tools, browser control exposure)
2. **`claudebot security audit --deep`** — additional live probes of your gateway for network exposure
3. **`claudebot security audit --fix`** — automatically applies safe corrections

**Example findings:**
- **Critical:** Credentials directory permissions too open → auto-fixed to `700`
- **Warning:** Reverse proxy configuration (fine for local setups)
- **Info:** Attack surface summary — open groups, elevated tools, browser control status

**Run regularly**, especially after config changes or exposing network surfaces.

---

### Step 4: Scope Your Tokens (Minimum Permissions)

When connecting external services (GitHub, Google Calendar, Gmail), apply the **principle of minimum permissions**.

| Service | Don't Do This | Do This Instead |
|---------|--------------|-----------------|
| **GitHub** | Full `repo` scope (complete control) | `public_repo` only, or scope to specific repos |
| **Google** | Full account access | Read-only calendar, or read-only email |
| **Email** | Send + read permissions | Read-only if you only need to read |

**GitHub example:** Use fine-grained personal access tokens → select public repos only → skip additional permissions (email, SSH keys, profile).

**Why it matters:** If the agent gets manipulated, it can only do what the token allows. A read-only token can't delete repos. A calendar-only token can't send emails.

Burak: "99% of people will mess this up."

---

### Step 5: Keep It Private (No Group Chats)

**Burak:** "Never add your personal ClawdBot to a WhatsApp or Telegram group chat. Every person in that chat effectively has shell access to your server via the bot."

**Peter Steinberger** echoes the same: don't add it to group chats if it's your personal bot.

**Treat ClawdBot like a sudo terminal**, not a chatbot. More people with access = larger attack surface.

**If you must use groups:**
- Enable sandbox mode
- Apply tool restrictions
- Set group policy to allow list (only approved users interact)

---

## Model Recommendation

Peter Steinberger recommends **Anthropic Pro Max plan with Opus 4.5** for:
- Long context strength
- **Better prompt injection resistance** — more capable models are better at recognizing manipulation

A cheaper model might follow malicious instructions embedded in a document without questioning them. Not the place to cut costs when the agent has real system access.

---

## Pre-Deployment Checklist

1. **Sandbox mode** — Docker containers, `session` scope, `none` workspace access
2. **Tool restrictions** — allow list only what the agent needs
3. **Security audit** — run `claudebot security audit --fix` regularly
4. **Token scoping** — minimum permissions on every external service
5. **Private access** — no group chats, treat as sudo terminal

Based on Peter Steinberger's guardrails list and Burak Eregar's security thread.
