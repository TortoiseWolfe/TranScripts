# Alpha Vantage API Usage

Daily limit: 25 calls (free tier)
Rate limit: 5 calls/minute

## Budget Strategy

- Morning cron: 4 calls (1 per watchlist pair)
- On-demand reserve: 21 calls
- Phase 2 evening cron: +4 calls (reduces reserve to 17)

## Current Week

| Date | Calls Used | Remaining | Notes |
|------|-----------|-----------|-------|
|      | 0         | 25        |       |
