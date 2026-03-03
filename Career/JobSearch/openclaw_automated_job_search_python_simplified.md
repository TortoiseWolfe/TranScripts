# Automating Your Job Search with an AI Agent

**Source:** "I Built a Python-Powered OpenClaw Agent That Finds Jobs 24/7" — Python Simplified (2026)

**Focus:** Job search automation strategy, resume-based filtering, RSS feeds, WhatsApp alerts, competitive advantage

---

## The Problem with Manual Job Searching

- By the time you find a listing manually, **200 applicants may have already applied**
- Checking job boards daily is time-consuming and inconsistent
- You miss listings that appear between your manual checks

## The Solution: 24/7 Automated Scanning

- Define your **target role, salary, skills, and experience** once
- An AI agent scans the web for new listings **as frequently as you set**
- You get **immediate WhatsApp notifications** only when a real match appears
- The system runs continuously — like a **personal assistant that never sleeps**

## Resume as a Filter (resume.json)

- Create a JSON file with your professional profile:
  - **Target roles** — the positions you're looking for
  - **Salary expectations** — filter out listings below your range
  - **Flags** — relocation willingness, remote work preference
  - **Education** — degree, field of study
  - **Technical skills** — languages, frameworks, tools
- This file drives **automated pre-filtering** before AI analysis
- Adapt it carefully to your actual skills and experience

## Two-Layer Filtering Strategy

### Layer 1: Python (Free, System-Level)

- Python scripts read **RSS job feeds** — structured data meant for machine reading
- Feeds are accessed via `curl` — no scraping, no bot blockers, no Selenium
- Filters applied:
  - **Location** — geographic match
  - **Skills** — technical skill alignment
- Surviving listings are saved to `jobs.csv`
- A second script extracts the latest batch into `desc.json`

### Layer 2: AI Agent (Lightweight Reasoning)

- OpenClaw reads **only** `desc.json` — a small, pre-filtered dataset
- The AI performs **stricter matching** against your resume
- It evaluates: Does this job's title or description match your target roles, skills, and preferences?
- **Only genuine matches** trigger a WhatsApp alert

### Why Two Layers?

- Running AI on every raw listing would be **expensive** (burns LLM credits fast)
- Python filtering is **free** and handles 90% of the work
- AI credits are reserved for the **final judgment call** where reasoning adds real value
- Result: A system that **costs a fraction** of typical AI automation setups

## Alert System

- Matches arrive as **WhatsApp messages** in real-time
- Format: `Job Match: [job title] ([link])`
- Only **new listings** trigger alerts — the system tracks what's already been processed
- No duplicate alerts for the same posting

## Scheduling and Reliability

- The scanning loop runs **every few minutes** via cron scheduling
- More reliable than asking the AI to remember to check — **cron never forgets**
- The system runs on a remote server, so it continues **even when your computer is off**

## Practical Results

- In testing, the system found **28 raw listings** in one pass
- After AI filtering, **6 genuine matches** were sent as alerts
- Over 30 minutes, **additional matches trickled in** as new listings appeared
- The system correctly **ignored stale listings** and only alerted on fresh ones

## Competitive Edge

- Most candidates search manually, maybe once a day
- This system scans **continuously** — you see listings within minutes of posting
- Being among the **first applicants** significantly improves your chances
- The cost is minimal compared to the advantage gained

## What You Need

- A VPS (Virtual Private Server) to host the agent 24/7
- OpenClaw (open-source AI assistant platform)
- WhatsApp account for alerts
- Python scripts for RSS feed processing (available on GitHub)
- A `resume.json` file tailored to your profile
