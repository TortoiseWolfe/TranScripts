# AI Builders — Lovable Clone Tutorial

**Source:** [Build a Full Stack Lovable Clone | SaaS AI Builder | Cloudflare & Clerk | React 19](https://youtu.be/Q9qAPQv-biQ) by Kishan Sheth (~12 hours)

## Operational Costs of a Lovable Clone

### AI API Costs (the big variable)

Development-phase cost estimates from the tutorial:

| Provider | Dev Cost | Minimum Purchase | Notes |
|----------|----------|-----------------|-------|
| **DeepSeek** | ~$0.04/month | $2 top-up | Cheapest, but no image/vision support |
| **OpenAI** (GPT-4o-mini) | Low | ~$5 credit purchase | Cheap for the mini model |
| **Anthropic** (Claude Sonnet) | ~$1-2/month | Pay-as-you-go | Higher quality output |
| **Google Gemini** | — | ~$200 minimum [uncertain] | Most expensive entry point |

You only need **one provider** to start. DeepSeek or OpenAI are the cheapest to get going.

### Cloudflare Infrastructure (near-free at small scale)

- **Cloudflare Workers** — free tier includes 100K requests/day
- **Cloudflare KV** — metadata storage, free tier generous
- **Cloudflare R2** — file/project storage, free tier includes 10GB + 10M reads/month
- Zero cold starts, edge-deployed

### Auth/Billing

- **Clerk** — free tier covers 10K monthly active users. Billing/payments handled through Clerk's built-in gateway (they take a percentage on transactions).

### In-App Credit Model

- **Free plan**: 50 credits/month, max 3 projects, free-tier models only
- **Pro plan**: Unlimited credits, all 8 models, CodeSandbox export
- Premium models cost **2 credits** per generation, fast-tier models cost **1 credit**

### Bottom Line

At hobby/dev scale, you could run this for **under $10/month** total (mostly AI API costs). The infrastructure (Cloudflare + Clerk) is essentially free at small scale. The cost scales with **usage** — specifically how many AI generations your users trigger and which models they pick. At production scale with real users, the AI API costs would be 90%+ of your bill.

## Tech Stack

- **Frontend**: React 19, Tailwind CSS v4, ShadCN/UI + Radix UI
- **Backend**: Cloudflare Workers + Hono
- **Auth/Billing**: Clerk (JWT + webhooks + payments)
- **AI**: Vercel AI SDK with 8 models across 4 providers (Claude, GPT-4o, Gemini, DeepSeek)
- **Code Preview**: Sandpack (CodeSandbox)
- **Code Editor**: Monaco Editor
- **Storage**: Cloudflare R2 (files) + KV (metadata)
- **Streaming**: Server-Sent Events (SSE)

## Chapters

| # | Chapter | Raw | Cleaned |
|---|---------|-----|---------|
| 01 | Intro | `01_Intro.txt` | `AI_Builders_Edited/01_Intro.md` |
| 02 | Demo | `02_Demo.txt` | `AI_Builders_Edited/02_Demo.md` |
| 03 | Project Bootstrap | `03_Project_Bootstrap.txt` | `AI_Builders_Edited/03_Project_Bootstrap.md` |
| 04 | Auth | `04_Auth.txt` | `AI_Builders_Edited/04_Auth.md` |
| 05 | Landing Page | `05_Landing_Page.txt` | `AI_Builders_Edited/05_Landing_Page.md` |
| 06 | Dashboard CRUD | `06_Dashboard_CRUD.txt` | `AI_Builders_Edited/06_Dashboard_CRUD.md` |
| 07 | Editor Shell | `07_Editor_Shell.txt` | `AI_Builders_Edited/07_Editor_Shell.md` |
| 08 | AI Engine | `08_AI_Engine.txt` | `AI_Builders_Edited/08_AI_Engine.md` |
| 09 | Chat System | `09_Chat_System.txt` | `AI_Builders_Edited/09_Chat_System.md` |
| 10 | Live Preview | `10_Live_Preview.txt` | `AI_Builders_Edited/10_Live_Preview.md` |
| 11 | Code Editor | `11_Code_Editor.txt` | `AI_Builders_Edited/11_Code_Editor.md` |
| 12 | Versioning | `12_Versioning.txt` | `AI_Builders_Edited/12_Versioning.md` |
| 13 | Billing & Credits | `13_Billing_Credits.txt` | `AI_Builders_Edited/13_Billing_Credits.md` |
| 14 | Multi Modal | `14_Multi_Modal.txt` | `AI_Builders_Edited/14_Multi_Modal.md` |
