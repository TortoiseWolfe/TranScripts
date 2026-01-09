#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON using bash (no jq dependency)
# Uses grep -oP for Perl-compatible regex with lookbehind
model_name=$(echo "$input" | grep -oP '"display_name"\s*:\s*"\K[^"]+' || echo "Claude")
current_dir=$(echo "$input" | grep -oP '"current_dir"\s*:\s*"\K[^"]+')
if [ -z "$current_dir" ]; then
    current_dir=$(echo "$input" | grep -oP '"cwd"\s*:\s*"\K[^"]+' || echo "unknown")
fi
output_style=$(echo "$input" | grep -oP '"output_style"\s*:\s*\{[^}]*"name"\s*:\s*"\K[^"]+' || echo "")

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

# Convert full path to tilde notation
home_dir="/home/$(whoami)"
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

# Check for Docker indicator (simplified check)
docker_icon=""
if grep -qE '/docker|/lxc' /proc/1/cgroup 2>/dev/null; then
    docker_icon=" \033[35m🐳\033[0m"
fi

# Output style indicator
style_info=""
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    style_info=" [\033[36m$output_style\033[0m]"
fi

# Build the statusLine (condensed to one line for status bar)
# Use echo -e to interpret escape sequences in variables
echo -e "\033[33m${local_time}\033[0m 🐢 $(whoami) 🐺 @ \033[34m$(hostname -s)\033[0m${docker_icon} | ${token_info} | \033[36m${display_dir}\033[0m${git_branch} | \033[35m${model_name}\033[0m${style_info}"