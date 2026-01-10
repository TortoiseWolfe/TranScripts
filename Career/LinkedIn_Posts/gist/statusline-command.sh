#!/bin/bash

# Claude Code Token Tracking Statusline
# Based on Leon van Zyl's video: https://youtu.be/fiZfVTsPy-w
# Extended with rolling 7-day weekly tracking and daily burn rate

# Exit quickly if interrupted
trap 'exit 0' SIGPIPE

# Cache static values
USER_NAME="${USER:-$(whoami)}"
HOST_NAME="${HOSTNAME:-$(hostname -s)}"

# Read JSON input from stdin
input=$(cat)

# Early exit if no input
[ -z "$input" ] && exit 0

# Extract data from JSON using bash (no jq dependency for basic fields)
model_name=$(echo "$input" | grep -oP '"display_name"\s*:\s*"\K[^"]+' || echo "Claude")
current_dir=$(echo "$input" | grep -oP '"current_dir"\s*:\s*"\K[^"]+')
if [ -z "$current_dir" ]; then
    current_dir=$(echo "$input" | grep -oP '"cwd"\s*:\s*"\K[^"]+' || echo "unknown")
fi

# Extract token usage data
# Full context = cache_read (system/tools) + cache_creation (new) + input (current turn)
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0' 2>/dev/null || echo "0")
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0' 2>/dev/null || echo "0")
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0' 2>/dev/null || echo "0")
context_used=$((cache_read + cache_create + input_tokens))
context_limit=$(echo "$input" | jq -r '.context_window.context_window_size // 200000' 2>/dev/null || echo "200000")

# Calculate FREE space (what's left before autocompact)
# Autocompact buffer is ~22.5% so usable space is ~77.5% of limit
usable_limit=$((context_limit * 775 / 1000))
context_free=$((usable_limit - context_used))
if [ "$context_free" -lt 0 ] 2>/dev/null; then context_free=0; fi

# Calculate free percentage
if [ "$usable_limit" -gt 0 ] 2>/dev/null; then
    free_pct=$((context_free * 100 / usable_limit))
else
    free_pct=0
fi

# Build progress bar (10 chars) - solid = USED, empty = FREE
used_pct=$((100 - free_pct))
filled=$((used_pct / 10))
empty=$((10 - filled))
bar=""
for i in $(seq 1 $filled 2>/dev/null); do bar+="█"; done
for i in $(seq 1 $empty 2>/dev/null); do bar+="░"; done

# Color based on remaining space (green > yellow > red)
if [ "$free_pct" -gt 30 ] 2>/dev/null; then
    bar_color="\033[32m"  # green - comfortable
elif [ "$free_pct" -gt 15 ] 2>/dev/null; then
    bar_color="\033[33m"  # yellow - getting tight
else
    bar_color="\033[31m"  # red - autocompact imminent
fi

# Format free space in k
if [ "$context_free" -gt 1000 ] 2>/dev/null; then
    free_display="$((context_free / 1000))k"
else
    free_display="$context_free"
fi

token_info="${bar_color}${bar}\033[0m ${free_pct}% free (${free_display})"

# Weekly usage tracking
WEEKLY_STATE=~/.claude/weekly-usage.json
WEEKLY_CONFIG=~/.claude/weekly-config.json

# Read config (defaults if missing)
# Adjust these limits based on your Claude plan
if [ -f "$WEEKLY_CONFIG" ]; then
    input_limit=$(jq -r '.input_limit // 2500000' "$WEEKLY_CONFIG" 2>/dev/null)
    output_limit=$(jq -r '.output_limit // 500000' "$WEEKLY_CONFIG" 2>/dev/null)
else
    # Default limits for Claude Max ($200/month)
    input_limit=2500000
    output_limit=500000
fi

# Get session data from JSON
session_id=$(echo "$input" | jq -r '.session_id // "unknown"' 2>/dev/null)
session_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0' 2>/dev/null)
session_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0' 2>/dev/null)
[[ "$session_input" =~ ^[0-9]+$ ]] || session_input=0
[[ "$session_output" =~ ^[0-9]+$ ]] || session_output=0

# Rolling 7-day window: get cutoff timestamp (Unix epoch)
now_ts=$(date +%s)
cutoff_ts=$((now_ts - 7 * 24 * 60 * 60))

# Initialize state file if missing
if [ ! -f "$WEEKLY_STATE" ]; then
    echo '{"usage":[],"sessions":{},"baselines":{}}' > "$WEEKLY_STATE"
fi

# Compression counter: per-session baseline tracking
# Get or set baseline for this session (first input token count)
baseline=$(jq -r ".baselines[\"$session_id\"] // 0" "$WEEKLY_STATE" 2>/dev/null)
[[ "$baseline" =~ ^[0-9]+$ ]] || baseline=0
if [ "$baseline" -eq 0 ] && [ "$session_input" -gt 0 ]; then
    # First call for this session - set baseline
    baseline=$session_input
    jq --arg sid "$session_id" --argjson base "$baseline" \
        '.baselines[$sid] = $base' "$WEEKLY_STATE" > "$WEEKLY_STATE.tmp" 2>/dev/null \
        && mv "$WEEKLY_STATE.tmp" "$WEEKLY_STATE"
fi

# Calculate compressions relative to session baseline
tokens_since_start=$((session_input - baseline))
[ "$tokens_since_start" -lt 0 ] && tokens_since_start=0
compress_count=$((tokens_since_start / usable_limit))

if [ "$compress_count" -eq 0 ]; then
    compress_info=""  # hide when no compressions
elif [ "$compress_count" -eq 1 ]; then
    compress_info=" \033[33m[C:1]\033[0m"  # yellow - first compression
else
    compress_info=" \033[31m[C:$compress_count]\033[0m"  # red - multiple
fi

# Get previous session values to calculate delta
prev_input=$(jq -r ".sessions[\"$session_id\"].input // 0" "$WEEKLY_STATE" 2>/dev/null)
prev_output=$(jq -r ".sessions[\"$session_id\"].output // 0" "$WEEKLY_STATE" 2>/dev/null)
[[ "$prev_input" =~ ^[0-9]+$ ]] || prev_input=0
[[ "$prev_output" =~ ^[0-9]+$ ]] || prev_output=0

# Calculate delta for this session update
delta_input=$((session_input - prev_input))
delta_output=$((session_output - prev_output))

# Only add entry if there's actual new usage
if [ "$delta_input" -gt 0 ] || [ "$delta_output" -gt 0 ]; then
    # Add new timestamped usage entry and update session, filter expired entries
    jq --argjson ts "$now_ts" \
       --argjson cutoff "$cutoff_ts" \
       --argjson dinput "$delta_input" \
       --argjson doutput "$delta_output" \
       --arg sid "$session_id" \
       --argjson sinput "$session_input" \
       --argjson soutput "$session_output" \
       '
       # Filter out entries older than 7 days and add new one
       .usage = ([.usage[] | select(.ts > $cutoff)] + [{ts: $ts, input: $dinput, output: $doutput}])
       | .sessions[$sid] = {input: $sinput, output: $soutput}
       ' "$WEEKLY_STATE" > "$WEEKLY_STATE.tmp" 2>/dev/null && mv "$WEEKLY_STATE.tmp" "$WEEKLY_STATE"
else
    # Just filter expired entries, no new usage
    jq --argjson cutoff "$cutoff_ts" \
       '.usage = [.usage[] | select(.ts > $cutoff)]' \
       "$WEEKLY_STATE" > "$WEEKLY_STATE.tmp" 2>/dev/null && mv "$WEEKLY_STATE.tmp" "$WEEKLY_STATE"
fi

# Sum usage within the 7-day window
weekly_input=$(jq --argjson cutoff "$cutoff_ts" \
    '[.usage[] | select(.ts > $cutoff) | .input] | add // 0' \
    "$WEEKLY_STATE" 2>/dev/null)
weekly_output=$(jq --argjson cutoff "$cutoff_ts" \
    '[.usage[] | select(.ts > $cutoff) | .output] | add // 0' \
    "$WEEKLY_STATE" 2>/dev/null)
[[ "$weekly_input" =~ ^[0-9]+$ ]] || weekly_input=0
[[ "$weekly_output" =~ ^[0-9]+$ ]] || weekly_output=0

# Calculate daily average (output tokens per day)
days_with_data=$(jq --argjson cutoff "$cutoff_ts" \
    '[.usage[] | select(.ts > $cutoff) | .ts / 86400 | floor] | unique | length' \
    "$WEEKLY_STATE" 2>/dev/null)
[[ "$days_with_data" =~ ^[0-9]+$ ]] || days_with_data=1
[ "$days_with_data" -eq 0 ] && days_with_data=1
avg_daily_output=$((weekly_output / days_with_data))

# Format daily average
if [ "$avg_daily_output" -ge 1000000 ]; then
    daily_display="~$((avg_daily_output / 1000000)).$((avg_daily_output % 1000000 / 100000))M/d"
elif [ "$avg_daily_output" -ge 1000 ]; then
    daily_display="~$((avg_daily_output / 1000))k/d"
else
    daily_display="~${avg_daily_output}/d"
fi

# Calculate REMAINING tokens (countdown)
input_remaining=$((input_limit - weekly_input))
output_remaining=$((output_limit - weekly_output))
[ "$input_remaining" -lt 0 ] && input_remaining=0
[ "$output_remaining" -lt 0 ] && output_remaining=0

# Calculate remaining percentages
input_pct_left=$((input_remaining * 100 / input_limit))
output_pct_left=$((output_remaining * 100 / output_limit))

# Format REMAINING display (in millions/thousands)
if [ "$input_remaining" -ge 1000000 ]; then
    input_display="$((input_remaining / 1000000)).$((input_remaining % 1000000 / 100000))M"
else
    input_display="$((input_remaining / 1000))k"
fi
if [ "$output_remaining" -ge 1000000 ]; then
    output_display="$((output_remaining / 1000000)).$((output_remaining % 1000000 / 100000))M"
else
    output_display="$((output_remaining / 1000))k"
fi

# Color based on LOWEST remaining percentage (most critical resource)
min_pct=$input_pct_left
[ "$output_pct_left" -lt "$min_pct" ] && min_pct=$output_pct_left
if [ "$min_pct" -gt 30 ]; then
    weekly_color="\033[32m"  # green - lots remaining
elif [ "$min_pct" -gt 10 ]; then
    weekly_color="\033[33m"  # yellow - caution
else
    weekly_color="\033[31m"  # red - running low
fi

weekly_info=" ${weekly_color}[I:${input_display} O:${output_display} ${daily_display}]\033[0m"

# Convert full path to tilde notation
home_dir="$HOME"
display_dir=$(echo "$current_dir" | sed "s|^$home_dir|~|")

# Get current time in 12-hour format
local_time=$(date +"%I:%M %p")

# Get git branch if in a git repository
git_branch=""
if [ -d "$current_dir/.git" ] || git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
    branch_name=$(git -C "$current_dir" branch --show-current 2>/dev/null)
    if [ -n "$branch_name" ]; then
        git_branch=" \033[33m($branch_name)\033[0m"
    fi
fi

# Build the statusLine
# Customize this line to your preference - add/remove sections as needed
echo -e "\033[33m${local_time}\033[0m ${USER_NAME}@\033[34m${HOST_NAME}\033[0m | ${token_info}${compress_info}${weekly_info} | \033[36m${display_dir}\033[0m${git_branch} | \033[35m${model_name}\033[0m"
