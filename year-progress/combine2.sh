#!/usr/bin/env bash
# Unified Widget: Year Progress & Sun Times (Boxed Symbols)

# --- Configuration ---
LAT="24.75"
LON="90.40"
METHOD="1"
BAR_WIDTH=12

# --- Colors ---
CYAN='\e[96m'
WHITE='\e[97m'
DIM='\e[2m'
BOLD='\e[1m'
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

# Build Bar
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="${CYAN}█${RESET}"; done
for ((i=0; i<EMPTY; i++)); do BAR+="${DIM}░${RESET}"; done

# --- Output ---
echo -e "${CYAN}✺ ${WHITE}${SUNRISE}${CYAN}  ☽ ${WHITE}${SUNSET}${RESET}"
echo -e "${BOLD}${CYAN}${YEAR}${RESET} ${BAR} ${BOLD}${WHITE}${PROGRESS}%${RESET}"
