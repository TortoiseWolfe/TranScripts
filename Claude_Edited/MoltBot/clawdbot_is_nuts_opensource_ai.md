# ClawdBot IS NUTS: Open-Source AI Employee That Runs 24/7

**Source:** Income Stream Surfers (Hamish) — [YouTube](https://youtu.be/h9EXG9BJqqI)
**Date:** 2026-01-24 | **Duration:** 10 minutes
**Note:** ClawdBot was later renamed to **MoltBot** due to Anthropic copyright concerns.

---

## What Is ClawdBot (MoltBot)?

An open-source AI assistant that runs 24/7 on any machine (spare laptop, AWS free tier, cloud service). You can interact with it via WhatsApp, Telegram, or other messaging interfaces. It executes Claude Code, manages files, and operates autonomously.

**Installation:** Single command from their homepage. Open source.

## Hamish's Honest Take

Hamish is skeptical of the hype but identifies legitimate use cases after initial confusion. His main concerns:

### Criticisms

- **Token inefficiency** — burns tokens constantly running 24/7
- **Unsupervised coding is dangerous** — "If you just let this cook, it will break everything"
- **Potential TOS violation** — connecting through Claude Code may violate Anthropic's terms of service; getting banned means losing access to Claude entirely
- **Overhyped on X** — the word "ClawdBot" alone guarantees 10K impressions; actual utility doesn't match the buzz
- **Not the same as Claude Code** — if you're not watching it run, quality degrades

### Use Cases That Actually Make Sense

1. **Own identity setup** — Give it its own Apple account, Gmail, and GitHub (not yours). It signs up for things, pushes code, operates as its own AI profile.

2. **AWS always-on assistant** — Deploy on AWS free tier. Write to it whenever you want something done. It can execute code and run Claude Code tasks.

3. **Voice note → MVP** — Walk down the street, leave a voice note with an idea, come home to a fleshed-out MVP. The gateway system supports voice messages.

4. **Content automation pipeline** — Use Remotion skills to create motion graphics → ClawdBot posts them to X and engages with people. Automated content marketing.

5. **Competitor monitoring** — Blog Watcher CLI monitors competitor RSS feeds 24/7 → webhooks back to your system → auto-generates response articles in your style.

6. **Session teleporting** — If ClawdBot could integrate with Claude Code's session teleporting feature, you could leave a coding session and continue the conversation via messaging.

## ClawdBot Gateway System

The more structured "gateway" configuration includes:
- **Automated routines:** Daily brief, evening check, content generation/drafting
- **`soul.md`** — Personality and tone configuration
- **`user.md`** — Who you are, your context
- **`memory.md`** — Long-term knowledge
- **Daily logs** — Persistent record
- **Voice messages** — Async interaction

## Warnings

- **TOS risk** — Connecting through Claude Code may violate Anthropic's terms. If banned, you lose Claude access entirely. OpenRouter fallback is ~100x more expensive.
- **Unsupervised execution** — Don't let it autonomously ship code to production repos without review
- **Token burn** — Running 24/7 consumes significant API tokens

## Key Takeaway

ClawdBot/MoltBot is genuinely interesting as a 24/7 bot you can wake up anytime via messaging to execute tasks. The strongest use cases involve async workflows (voice notes, competitor monitoring, content pipelines) rather than unsupervised coding. The hype on X outpaces the current practical utility, but the concept of an always-on AI assistant with its own computing environment has real potential.
