# Claude Code Token Tracking Statusline

Custom statusline for Claude Code that tracks context window usage AND rolling 7-day weekly limits.

## Inspiration

Based on [Leon van Zyl's video](https://youtu.be/fiZfVTsPy-w) "Your Claude Code Terminal Should Look Like This" - which appeared in my feed right after I burned 25% of my weekly Claude Max limit on day one. Perfect timing.

I started with Leon's base concept and extended it for my context engineering workflow.

## What This Adds

Leon's original shows context window usage. This version adds:

- **Rolling 7-day tracking**: Weekly limits aren't calendar-based—they're a sliding window. Usage from 7 days ago gradually expires.
- **I/O breakdown**: See remaining input AND output tokens separately. Output costs 5x more ($75/M vs $15/M for Opus).
- **Daily burn rate**: `~158k/d` shows your average daily output usage—are you on pace?
- **Compression counter**: `[C:2]` shows how many times context has been autocompacted this session
- **Configurable limits**: Set your plan's limits in `weekly-config.json`

## Output Example

```
| █████████░ 9% free (14k) [I:1.5M O:341k ~158k/d] |
```

**Reading the display:**
- `█████████░` - Progress bar showing context window usage (solid = used, empty = free)
- `9% free (14k)` - Percentage and tokens remaining before autocompact (~78% threshold)
- `[I:1.5M O:341k` - Input/output tokens remaining in your 7-day rolling window
- `~158k/d]` - Your average daily output burn rate

## Setup

1. **Save the script** to `~/.claude/statusline-command.sh`

2. **Make it executable:**
   ```bash
   chmod +x ~/.claude/statusline-command.sh
   ```

3. **Create config** (optional) - `~/.claude/weekly-config.json`:
   ```json
   {
     "input_limit": 2500000,
     "output_limit": 500000
   }
   ```
   Adjust limits based on your Claude plan.

4. **Configure Claude Code** - Add to `~/.claude/settings.json`:
   ```json
   {
     "env": {
       "CLAUDE_CODE_CUSTOM_STATUSLINE": "~/.claude/statusline-command.sh"
     }
   }
   ```

5. **Restart Claude Code**

## Requirements

- `jq` for JSON parsing
- Bash shell (Linux, Mac, WSL)

## State Files

The script creates/uses these files in `~/.claude/`:

- `weekly-usage.json` - Timestamped usage entries for 7-day rolling calculation
- `weekly-config.json` - Your plan's token limits (optional, has defaults)

## Why This Matters

Output tokens cost 5x more than input. Once I could SEE my burn rate, I started practicing context engineering:

**Priming input instead of patching output.** Better system prompts, clearer requirements, relevant examples upfront = focused outputs on the first try. Less iteration, less "can you also..." follow-ups.

If you're paying for premium AI tools, visibility isn't optional.

## License

MIT - Use freely, credit appreciated

---

*Script originally developed while customizing Claude Code for context engineering workflows. January 2026.*
