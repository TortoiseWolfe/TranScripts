# Job Search Automation Status

**Updated:** 2026-01-30
**Overall:** Searching works. Applying is next.

## What Works Now

- **LinkedIn search** via MCP `search_jobs` (139 tools discovered, calls execute)
- **Job scoring** pipeline (skills 40pts, location 20pts, experience 20pts, company 20pts)
- **Daily report generation** to `~/clawd/job-search/daily-search-[date].md`
- **Tracker + inbox** management
- **3-session daily pacing** (7:30 AM, 12:00 PM, 5:30 PM) with 3-5 min delays between LinkedIn calls
- **Email monitoring** via Gmail MCP `findMessage`

## What's Blocked

### 1. LinkedIn Cookie Expiry (Recurring)
The `search_jobs` MCP tool uses a `li_at` session cookie. LinkedIn invalidates it
when it detects automated access patterns. Even with 3-5 min delays, the cookie
may still expire mid-session.

**Current behavior:** Tool returns `login_timeout`. Agent stops LinkedIn searching
for that session and reports the failure.

**To refresh:** Docker Desktop → MCP Toolkit → LinkedIn → re-authenticate, or:
```bash
docker mcp secret set linkedin-mcp-server.cookie <new_li_at_value>
```

### 2. Auto-Apply Not Yet Working
The skill's Workflow 3 (auto-apply) uses the built-in `browser` tool for headless
form filling. Two problems:

**Problem A: No logged-in LinkedIn browser session.**
The MCP cookie (for search) and the browser profile (for applying) are separate
auth mechanisms. The `clawd` browser profile doesn't have a LinkedIn login, so
Easy Apply buttons hit a login wall.

**Problem B: LinkedIn anti-bot on form submission.**
Even with a logged-in session, LinkedIn's bot detection on application forms is
stricter than on search. Captchas, device verification, and behavioral analysis
make headless submission unreliable.

**Current fallback:** Agent prepares tailored resume + cover letter, then queues
to `inbox.md` with materials ready for manual submission.

### 3. Brave API Key Missing
Web board searches (Indeed, Glassdoor, etc.) need a Brave API key.

```bash
# Add to .env, then recreate gateway
BRAVE_API_KEY=<key from https://brave.com/search/api/>
docker compose up -d --force-recreate moltbot-gateway
```

## Roadmap to Full Auto-Apply

The goal is moltbot handling the full pipeline autonomously. Steps to get there:

### Phase 1: Reliable Search (NOW)
- [x] MCP tool integration (139 tools)
- [x] 3-session daily pacing to avoid cookie burns
- [x] trustedNetworks for Docker container pairing
- [x] noWait cron so CLI doesn't timeout
- [ ] Brave API key for web board searches
- [ ] Cookie refresh workflow (detect expiry, alert user or auto-refresh)

### Phase 2: Browser-Based Apply
- [ ] Set up `clawd` browser profile with LinkedIn login (persistent session)
- [ ] Test Easy Apply flow with `browser` tool: navigate → snapshot → act → submit
- [ ] Handle multi-step Easy Apply forms (resume upload, additional questions)
- [ ] Screenshot before submission for audit trail
- [ ] Detect and skip captchas / device verification → queue to inbox instead

### Phase 3: Direct API Apply (If Possible)
- [ ] Investigate LinkedIn Partner API for job applications (requires business account)
- [ ] Investigate Indeed Apply API, Greenhouse API, Lever API for direct submission
- [ ] For company career pages: browser automation with form detection

### Phase 4: Full Autonomy
- [ ] Auto-refresh LinkedIn cookie (browser tool logs into LinkedIn periodically)
- [ ] Resume/cover letter PDF generation (not just markdown)
- [ ] Portfolio link injection for creative/DevRel roles
- [ ] Follow-up emails for stale applications (>2 weeks, no response)
- [ ] Interview scheduling assistance via email

## Current Workaround

Until auto-apply works, the agent:
1. Searches LinkedIn + web boards daily (paced across 3 sessions)
2. Scores every match
3. Prepares tailored resume + cover letter for high-match jobs (>=70)
4. Queues everything to `inbox.md` with materials + application URL
5. You click the link and paste the prepared materials

This still saves hours of manual searching/tailoring per day.
