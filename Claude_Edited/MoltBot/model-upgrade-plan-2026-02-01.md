# Model Upgrade Plan — 2026-02-01 (COMPLETED)

## Problem
`qwen2.5:14b` had three critical issues:
1. Wrong tool parameters — `read(filePath=...)` instead of `read(path=...)`
2. Language drift — Thai/Chinese output when confused
3. Hallucinated actions — called `sendMessage` to fabricated email

## Solution
- **Primary**: `ollama/llama3.1:8b` — reliable tool calling, fits in 8GB GPU
- **Fallback**: `ollama/qwen2.5:14b` — smarter reasoning, riskier tools
- **Monthly model-scout cron** (1st Saturday, 11 AM ET) researches upgrades

## Cognitive Load Split
- Local model: mechanical work (file reads, API calls, data writes)
- User + Claude Code: judgment, analysis, decisions

## Hardware
- RTX 3060 Ti (8GB VRAM), 32GB RAM (23.5GB Docker)
- llama3.1:8b = 4.9GB, fits entirely in GPU

## Changes Made
- `config-examples/moltbot.json` — primary → llama3.1:8b, fallback → qwen2.5:14b
- `~/.moltbot/moltbot.json` — same
- `config-examples/cron-jobs.json` — added model-scout cron
- `~/.moltbot/cron/jobs.json` — same
- `CLAUDE.md` / `AGENTS.md` — Local Models section, cron count → 13

## Commits
- `d164770` — chore: switch primary model to llama3.1:8b, add model-scout cron
- `1cd0ba2` — feat: add forex-trading skill with education and paper trading cron jobs
