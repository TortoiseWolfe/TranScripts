# Full Interview: ClawdBot's Peter Steinberger — First Public Appearance Since Launch

**Source:** TBPN — [YouTube](https://youtu.be/qyjTpzIAEkA)
**Date:** 2026-01-28 | **Duration:** 36 minutes

---

## Peter Steinberger Background

- Ran his own software company for **13 years** (Apple/iOS background)
- Sold the company ~4 years ago, completely burned out
- Took a 3-year break — "felt like someone sucked my Mojo out"
- **April 2025:** Spark returned. Looked into AI, found Claude Code (just released in beta)
- Started a meetup called **"Cloud Code Anonymous"** (now "Agents Anonymous")
- Profile tagline: **"Came back from retirement to mess with AI"**

---

## How ClawdBot Was Born

### The WhatsApp Moment (November 2025)

Peter wanted to chat with his computer from his phone while agents were running. Built a **WhatsApp integration in 1 hour** — receives message, calls Claude Code, returns the response.

Added image support (screenshots as prompts — "agents are really good at figuring out what you want").

### The Voice Message Epiphany

On a trip to Marrakesh, Peter sent a **voice message** to his agent — but he hadn't built voice support. The agent:

1. Received a file link with no extension
2. Checked the file header → identified it as Opus audio
3. Used **ffmpeg** to convert to WAV
4. Tried Whisper but it wasn't installed
5. Found the **OpenAI key** in the environment
6. Sent audio via curl to OpenAI for transcription
7. Responded with the translated text

> "That was the moment where it clicked. These things are damn smart, resourceful beasts if you actually give them the power."

### Early Experiments

- Used it as an **alarm clock** — agent SSH'd into his London MacBook and turned up the volume
- Built a **heartbeat** system with the prompt: "Surprise me"
- "World's most expensive alarm clock"
- Built CLIs for Google Places, Sonos, cameras, home automation — each one gave the agent more power

---

## Architecture Philosophy

### CLIs Over MCPs

> "My premise: MCPs are crap. Doesn't really scale. But you know what scales? **CLIs.**"

- Agents know Unix — they can discover and use a thousand small programs
- They call `--help`, load what's needed, figure out the tool
- **Build for models, not humans** — design CLI interfaces the way models think
- "It's a new kind of software"

### Apps Will "Melt Away"

Example: **MyFitnessPal becomes unnecessary** — just photograph your food, the agent already knows your location, dietary goals, and fitness program. It adapts everything automatically.

> "Most apps will be reduced to API, and then the question is: do you still need the API if I can just save it somewhere else?"

---

## Model Rankings

| Model | Strength |
|-------|----------|
| **Claude Opus** | Best overall, best personality, best in Discord (feels human, brings "bangers") |
| **OpenAI Codex** | More reliable for coding, navigates large codebases — "prompt and push to main with 95% certainty" |
| **Claude Code** | Needs "more tricks" and "more handholding" than Codex for coding |

On Opus personality: "I don't know what they trained their model on... but it behaves so good in Discord. It listens to the conversation and sometimes brings a banger that actually makes me laugh."

The agent uses a **"no reply" token** — it can choose not to respond to a message, so it doesn't spam every conversation. It listens and contributes when relevant.

---

## The Anthropic Rename

- Got an email from Anthropic to rename the project (from ClawdBot to MoltBot)
- **"Kudos, they were really nice. They didn't send their lawyers. They sent someone internally."**
- Timeline was rough — renaming a project with that much traction
- During the rename: opened two Twitter windows, pressed rename on one, the other account was **immediately snatched by crypto bots** ("they have scripts waiting")
- X/Twitter team helped resolve it within 20 minutes

---

## Growth & Traction

- GitHub stars: **"I need to talk to someone at GitHub because I don't think there's been a project before that's been like straight [up]"** — unprecedented vertical chart
- Broke containment into non-tech audiences — "people on Instagram at the Apple store getting a Mac Mini"
- Discord exploded — at one point Peter was copy-pasting questions into Codex to generate answers, then "copied the whole channel: answer the 20 most questions"

> "What people don't realize is this is not a company. This is like one dude sitting at home having fun."

---

## Hardware & Self-Hosting

- Peter runs a **Mac Studio, 512 GB maxed out** (not a Mac Mini — "my agent is a princess")
- Can run **MiniMax 2.1** locally (best open source model at the time)
- "One machine is not enough. You probably need two or three."
- **Doesn't think everyone will buy Mac Minis** long-term — but local hosting bypasses API red tape
- Running locally = **"liberation of data that big tech doesn't really want"**

### Non-Technical Adoption Already Happening

Met someone from a design agency at a Vienna meetup — never coded, started using MoltBot in December:
> "We have 25 web services now. We just build internal tools for whatever we need."

Uses Telegram to talk to his agent, which builds whatever he needs. **Hyperpersonalized software that solves exactly your problem — and it's free.**

---

## Security Reality Check

- Built for personal use on WhatsApp/Telegram — **trusted environment**
- People are now using it for **untrusted experiences** (exposing the web UI to the open internet)
- "All the threat models I didn't care about are now there because people use it differently"
- Bombarded with security reports — "I'm one guy, I do this for fun, and you expect me to sift through 100 security things for use cases I don't really care about"
- **Prompt injection is not solved** — "I don't know if any company would touch it"
- Building a team, expects it to become "a very secure product eventually"
- Believes the demand will **accelerate security research**

---

## Business & Future

### Foundation Over Company

> "Instead of a company, I would much rather consider a foundation or something nonprofit."

- Motivation: **"Have fun, inspire people, not make a whole bunch of money. I already have a whole bunch of money."**
- VCs frantically trying to acquire/invest — "10,000 VCs just punched a hole in the wall"
- MIT license by design — code can be copied and sold, but **"code is not worth that much anymore"**

### Vision

> "Last year was the year of the coding agent. **This year is the year of the personal assistant.**"

> "I don't know if MoltBot is the answer. It should show people the way."

- Has other ideas for "what something like this could become"
- Looking for **open source maintainers** — "I want this to outlive me"
- Call to action: "If you love open source, if you have experience, if you love security... email me"

---

## Key Quotes

> "The best way to learn these new technologies is if you have fun with it. You have to play with it."

> "Build it so the agent has the best possible way to build software. That's the secret."

> "All the technology blends away. You just talk to a friend or a ghost."

> "This is the worst the models ever are. This is only going to go up."

> "You could delete [the code] and build it again in months. It's much more the idea and the eyeballs and maybe the brand that has value."
