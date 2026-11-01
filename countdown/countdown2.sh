#!/usr/bin/env bash
# Widget: Countdown Timer (Bar Style)

# --- Config (edit via set-countdown.sh) ---
CONFIG="$HOME/yr-progress/countdown/.countdown.conf"
[ -f "$CONFIG" ] && . "$CONFIG"
TITLE="${TITLE:-Countdown}"
TARGET="${TARGET:-2027-01-01 00:00:00}"
BAR_WIDTH=12

# --- Colors ---
RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
GREEN='\e[92m'
YELLOW='\e[93m'
RED='\e[91m'
WHITE='\e[97m'

# --- Calculate ---
NOW=$(date +%s)
TGT=$(date -d "$TARGET" +%s 2>/dev/null)
DIFF=$(( TGT - NOW ))

if [ "$DIFF" -le 0 ]; then
    echo -e "${RED}${BOLD}${TITLE}${RESET}"
    echo -e "${DIM}time's up!${RESET}"
    exit 0
fi

DAYS=$(( DIFF / 86400 ))
HOURS=$(( (DIFF % 86400) / 3600 ))
MINS=$(( (DIFF % 3600) / 60 ))

# Bar: filled based on remaining vs total (default 365 days)
TOTAL=31536000
PCT=$(awk "BEGIN {if($TOTAL>0) p=100*$DIFF/$TOTAL; else p=0; if(p>100)p=100; printf \"%.0f\", p}")
FILLED=$(( PCT * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))

[ "$PCT" -gt 50 ] && COLOR="$GREEN"
[ "$PCT" -le 50 ] && [ "$PCT" -gt 20 ] && COLOR="$YELLOW"
[ "$PCT" -le 20 ] && COLOR="$RED"

BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="${COLOR}█${RESET}"; done
for ((i=0; i<EMPTY; i++)); do BAR+="${DIM}░${RESET}"; done

# --- Output ---
echo -e "${COLOR}${BOLD}${DAYS}d ${HOURS}h ${MINS}m${RESET} ${BAR} ${WHITE}${PCT}%${RESET}"
echo -e "${DIM}${TITLE} · ${TARGET%% *}${RESET}"
