# LinkedIn Post: Claude Token Tracking

**Status:** Draft
**Target Length:** 2,000-2,500 chars
**Actual:** ~2,400 chars

---

Paying $200/month for Claude Max and burned 25% of my weekly limit on day one. The dashboard gave no breakdown of where. Built a custom statusline to practice context engineering properly.

As a power user of Claude Code, I burned through 25% of my weekly limit on the first day. The dashboard told me that much, but gave no visibility into WHERE those tokens were going. The $200/month Max plan gives you 20x the capacity of Pro, but Anthropic's weekly limits are a rolling 7-day window—not a billing cycle reset.

I needed granular visibility. So I built a bash script that shows me exactly where I stand:

| █████████░ 9% free (14k) [I:1.5M O:341k ~158k/d] |

What this tracks:
- Progress bar: Context window usage (autocompacts at ~78%)
- I/O remaining: Input and output tokens left in my 7-day rolling window
- Daily burn rate: Am I on pace to use my full allocation?

The rolling window means usage from 7 days ago gradually expires. No fixed reset day—capacity refreshes as old usage ages out. Planning around this requires knowing your daily average.

Here's the economics that changed everything: Output tokens cost 5x more than input ($75/M vs $15/M for Opus). That ~158k/day output burn was my real problem.

Once I could SEE this, I could finally apply context engineering with precision:

**Priming input instead of patching output.** I rewrote my custom slash commands to be less verbose in their instructions to Claude—silent where possible. But I added MORE context upfront: better system prompts, clearer requirements, relevant examples, explicit constraints.

The result? Claude's outputs became more focused on the first try. Less iteration, less "can you also..." follow-ups, less burning expensive output tokens on revisions.

I also identified heavy hitters—MCP tools like Playwright that load substantial context just by being enabled. Sometimes turning off what you're not using matters.

If you're paying for premium AI tools, visibility isn't optional. You need to know exactly what you're spending and WHERE, so you can optimize how you work with the model—not just track a number.

Comment "TRACK" below and I'll send you the bash script.

#ClaudeAI #AITools #DeveloperProductivity #ContextEngineering #Anthropic

