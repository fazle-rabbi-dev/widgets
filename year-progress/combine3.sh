#!/usr/bin/env bash
# Unified Widget: Year Progress & Sun Times (Minimal Gradient)

# --- Configuration ---
LAT="24.75"
LON="90.40"
METHOD="1"
BAR_WIDTH=12

# --- Colors ---
GREEN='\e[92m'
BLUE='\e[94m'
WHITE='\e[97m'
DIM='\e[2m'
RESET='\e[0m'

# --- Fetch Sun Data ---
DATA=$(curl -sL "https://api.aladhan.com/v1/timings?latitude=${LAT}&longitude=${LON}&method=${METHOD}")
SUNRISE_RAW=$(echo "$DATA" | jq -r '.data.timings.Sunrise')
SUNSET_RAW=$(echo "$DATA" | jq -r '.data.timings.Sunset')

format_time() {
    local h=$(echo "$1" | cut -d: -f1)
    local m=$(echo "$1" | cut -d: -f2)
    h=$((10#$h % 12))
    [ "$h" -eq 0 ] && h=12
    echo "$h:$m"
}
SUNRISE=$(format_time "$SUNRISE_RAW")
SUNSET=$(format_time "$SUNSET_RAW")

# --- Calculate Year Progress ---
YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL_DAYS=$(date -d "$YEAR-12-31" +%j)
PROGRESS=$(awk "BEGIN {printf \"%.2f\", 100 * $TODAY / $TOTAL_DAYS}")
FILLED=$(( TODAY * BAR_WIDTH / TOTAL_DAYS ))
EMPTY=$(( BAR_WIDTH - FILLED ))

# Build Bar (gradient blocks)
BAR=""
for ((i=0; i<FILLED; i++)); do
    if [ $i -lt $((FILLED / 3)) ]; then
        BAR+="${GREEN}▮${RESET}"
    elif [ $i -lt $((2 * FILLED / 3)) ]; then
        BAR+="${BLUE}▮${RESET}"
    else
        BAR+="${WHITE}▮${RESET}"
    fi
done
for ((i=0; i<EMPTY; i++)); do BAR+="${DIM}▯${RESET}"; done

# --- Output ---
echo -e "${GREEN}✺ ${WHITE}${SUNRISE}${DIM} · ${BLUE}☽ ${WHITE}${SUNSET}${RESET}"
echo -e "${GREEN}${YEAR}${RESET} ${BAR} ${WHITE}${PROGRESS}%${RESET}"
