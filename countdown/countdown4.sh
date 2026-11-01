#!/usr/bin/env bash
# Widget: Countdown Timer (Label Value)

# --- Config (edit via set-countdown.sh) ---
CONFIG="$HOME/yr-progress/countdown/.countdown.conf"
[ -f "$CONFIG" ] && . "$CONFIG"
TITLE="${TITLE:-Countdown}"
TARGET="${TARGET:-2027-01-01 00:00:00}"

# --- Colors ---
RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
ORANGE='\e[38;5;208m'
CYAN='\e[96m'
GREEN='\e[92m'
WHITE='\e[97m'
RED='\e[91m'

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
SECS=$(( DIFF % 60 ))

# --- Output ---
echo -e "${ORANGE}${BOLD}${TITLE}${RESET}"
echo -e "${ORANGE}DAYS${RESET} ${WHITE}${BOLD}${DAYS}${RESET}  ${CYAN}HRS${RESET} ${WHITE}${BOLD}${HOURS}${RESET}  ${GREEN}MIN${RESET} ${WHITE}${BOLD}${MINS}${RESET}  ${DIM}SEC${RESET} ${WHITE}${BOLD}${SECS}${RESET}"
