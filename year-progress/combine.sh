#!/usr/bin/env bash
# Unified Widget: Year Progress & Sun Times (Mymensingh)

# --- Configuration ---
LAT="24.75"
LON="90.40"
METHOD="1"
BAR_WIDTH=12
CITY="Mymensingh"

# --- Colors ---
TEAL='\e[36m'
WHITE='\e[97m'
DIM='\e[2m'
RESET='\e[0m'

# --- Fetch Sun Data ---
DATA=$(curl -sL "https://api.aladhan.com/v1/timings?latitude=${LAT}&longitude=${LON}&method=${METHOD}")
SUNRISE_RAW=$(echo "$DATA" | jq -r '.data.timings.Sunrise')
SUNSET_RAW=$(echo "$DATA" | jq -r '.data.timings.Sunset')

# Format Time (24h to 12h, strip leading zero)
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

# Build Bar (Teal Filled, Dim Empty)
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="●"; done
for ((i=0; i<EMPTY; i++)); do BAR+="${DIM}○${RESET}${TEAL}"; done

# --- Output ---
# Top Line: Sun Data
echo -e "${TEAL}✺ ${WHITE}${SUNRISE}${TEAL}  ☾ ${WHITE}${SUNSET}${RESET}"

# Bottom Line: Year Data
echo -e "${TEAL}${YEAR} ${BAR} ${PROGRESS}%${RESET}"
