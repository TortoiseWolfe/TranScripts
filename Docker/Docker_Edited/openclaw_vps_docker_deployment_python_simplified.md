# Deploying an AI Agent on a VPS with Docker

**Source:** "I Built a Python-Powered OpenClaw Agent That Finds Jobs 24/7" — Python Simplified (2026)

**Focus:** VPS provisioning, Docker container isolation, SSH access, file transfer, background processes, cron scheduling

---

## VPS Provisioning (Hostinger One-Click-Deploy)

- OpenClaw uses a **One-Click-Deploy VPS image** — pre-configured Docker environment
- Recommended specs: **2 CPU cores, 8GB RAM, 100GB NVMe**
- Same specs work for portfolio projects and bot hosting
- **Choose a server location geographically close** to reduce latency
- After payment, you receive a **gateway token** for authentication

## Docker Container Isolation

- The bot runs inside a **Docker container managed by Docker Manager**
- The container provides **extra isolation** — the bot is sandboxed from the host OS
- Docker Manager handles the container lifecycle (start, stop, deploy)
- OpenClaw's One-Click-Deploy image **blocks dangerous skills by default** — most built-in capabilities are intentionally disabled for safety
- Available tools inside the container: **read, write, execute (bash), web search, web fetch, cron task management**

## SSH Access and Server Setup

- Set an **SSH password** from the VPS dashboard before connecting
- Copy the root password command from the overview section
- Connect via terminal: paste the SSH command and enter your password

### Finding the Workspace Path Inside Docker

- The OpenClaw workspace lives inside the Docker container at a non-obvious path
- **Trick to find it:** Ask the bot to save a test file, then use `find / -name "testfile.py"` on the server to locate the workspace directory
- Navigate with `cd` to the discovered path
- Use `ls` to verify you see the expected files

## Secure Copy (scp) — Transferring Files to the Server

- Use `scp` to copy local files to the remote server:

```bash
scp pull_jobs.py pull_desc.py exec_loop.sh resume.json root@[SERVER_IP]:/docker/[PROJECT_NAME]/data/.openclaw/workspace/
```

- **Replace placeholders** with your server's IP address and project name
- Open a **second terminal** (keep SSH session in the first) to run scp from your local machine
- Verify files arrived: `ls` in the workspace directory on the SSH terminal

## File Permissions

- **Set permissions before executing scripts:**

```bash
chmod 700 exec_loop.sh
```

- Without this, the server will deny execution

## Running Background Processes with nohup

- Use `nohup` (no hang up) to keep processes running after you disconnect:

```bash
nohup ./exec_loop.sh > output.log 2>&1 &
```

- **Breakdown:**
  - `nohup` — prevents the process from stopping when you close your terminal
  - `> output.log` — redirects stdout to a log file
  - `2>&1` — redirects stderr to the same log file
  - `&` — runs the process in the background

- **Verify it's running:** `cat output.log` to check output

## Cron Job Scheduling

- OpenClaw has a **cron jobs tab** in the dashboard for recurring tasks
- Set up named tasks (e.g., "Job alerts") with a schedule (e.g., every 5 minutes)
- Cron tasks provide **more reliable scheduling** than natural language instructions to the bot
- The bot sometimes "forgets" tasks given via chat — cron ensures consistency

## Architecture Pattern: Offload Heavy Work to the OS

- **Key principle:** Don't waste LLM credits on tasks Python and Bash can handle
- The Docker container runs **Python scripts and Bash loops** at the system level
- LLM is only invoked for **lightweight reasoning and decision-making**
- Heavy lifting (RSS fetching via `curl`, filtering, CSV processing) runs as **system-level scripts in a while loop**
- This dramatically reduces costs compared to having the AI agent do everything

## Data Flow on the Server

1. `exec_loop.sh` — Bash while loop, runs Python scripts every N seconds
2. `pull_jobs.py` — Fetches RSS feeds via `curl`, filters by location/skills, writes to `jobs.csv`
3. `pull_desc.py` — Reads latest entries from CSV, writes to `desc.json`
4. OpenClaw reads **only** `desc.json` — the minimal, freshest data
5. Old listings are automatically excluded — only the most recent batch is kept

## Troubleshooting

- **"Disconnected for no reason" error:** Replace `/chat/session/main` in the URL with `?token=YOUR_TOKEN`
- **Gateway token forgotten:** Find it in Docker Manager under "Copy Gateway token"
- **Process not repeating:** Use cron jobs instead of natural language instructions for reliability
