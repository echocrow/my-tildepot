#!/bin/bash
# Claude Code status line.
# Simple single-line status: repo/dir name, git branch, model name on the
# left; context-window usage (absolute tokens + percent used) on the right.

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // empty')
model_name=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
model_id=$(printf '%s' "$input" | jq -r '.model.id // empty')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')

# --- resolve the model's context-window size ---
window=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
if [ -z "$window" ] || [ "$window" = "null" ]; then
  case "$model_id" in
    *opus*) window=1000000 ;;
    *)      window=200000 ;;
  esac
fi

# --- tokens used, from the last assistant message w/ usage in the transcript ---
used=0
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  usage=$(tail -n 1000 "$transcript" 2>/dev/null \
    | jq -c 'select(.message.usage != null) | .message.usage' 2>/dev/null \
    | tail -n 1)
  if [ -n "$usage" ]; then
    used=$(printf '%s' "$usage" | jq '(.input_tokens // 0) + (.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.output_tokens // 0)' 2>/dev/null)
    [ -z "$used" ] && used=0
  fi
fi

pct_used=0
if [ "$window" -gt 0 ] 2>/dev/null; then
  pct_used=$(( used * 100 / window ))
  [ "$pct_used" -gt 100 ] 2>/dev/null && pct_used=100
fi

fmt_tokens() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n/1000000
    else if (n >= 1000) printf "%.1fk", n/1000
    else printf "%d", n
  }'
}
used_fmt=$(fmt_tokens "$used")

# --- repo/dir name: basename of the git repo root, else basename of cwd ---
# (skip optional locks to stay fast/safe)
git_root=""
git_branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  if [ -z "$git_branch" ]; then
    git_branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi
fi
if [ -n "$git_root" ]; then
  name=$(basename "$git_root")
else
  name=$(basename "$cwd")
fi

RESET="\033[0m"
# Claude Code's dark-theme `inactive`/secondary-text gray (rgb 153,153,153),
# used as an explicit color instead of a bare dim attribute so it renders
# brighter/neutral rather than the terminal's very dark default dim.
GRAY="\033[38;2;153;153;153m"
# Matches Claude Code's "auto mode on" indicator color (theme `warning`, dark).
ACCENT="\033[38;2;255;193;7m"

line="${ACCENT}${used_fmt}${RESET} ${GRAY}(${pct_used}%)${RESET}"
line="${line} ${GRAY}·${RESET} ${GRAY}${name}${RESET}"
[ -n "$git_branch" ] && line="${line} ${GRAY}·${RESET} ${GRAY}${git_branch}${RESET}"
line="${line} ${GRAY}·${RESET} ${GRAY}${model_name}${RESET}"

printf "%b\n" "$line"
