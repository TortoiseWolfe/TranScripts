# Chapter 1: Introduction — Lovable Clone Tutorial

Overview of the full-stack Lovable.dev clone project: what you will build, the complete feature set, the tech stack, and the 12-chapter roadmap.

## What You Are Building

A production-grade AI app builder clone of **Lovable.dev**. You type a prompt, the AI generates full React components in real time, code streams into files, and the app updates live in the browser.

## Feature Set

- **AI code generation** with real-time streaming
- **Live Sandpack preview** updating in the browser
- **Monaco code editor** (same editor as VS Code)
- **Multi-model support** — 8 models across 4 providers (Claude, GPT-4o, Gemini, DeepSeek) with different speed tiers, credit costs, and vision support; swap between them in one click
- **Auto-heal** — if the generated code breaks, the AI automatically attempts to fix itself
- **Full version history** with file diffs
- **Image uploads** in prompts (for vision-capable models)
- **Zip export** and CodeSandbox export
- **Dark mode**
- **Credit-based billing** with Clerk

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Next.js 16 with React 19 |
| **Backend** | Cloudflare Workers with Hono (edge-deployed, zero cold starts) |
| **Preview** | Sandpack |
| **Code editor** | Monaco Editor |
| **Auth and billing** | Clerk |
| **Storage** | Cloudflare R2 (files) and KV (metadata) |

## Tutorial Structure

The project is broken into **12 chapters**, covering:

1. Project setup
2. Authentication
3. Editor
4. AI engine
5. Chat
6. Preview
7. Versioning
8. Billing
9. Deployment

Total runtime: **12+ hours**, step by step from zero.
