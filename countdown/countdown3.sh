#!/usr/bin/env bash
# Widget: Countdown Timer (Minimal Dotted)

# --- Config (edit via set-countdown.sh) ---
CONFIG="$HOME/widgets/countdown/.countdown.conf"
[ -f "$CONFIG" ] && . "$CONFIG"
TITLE="${TITLE:-Countdown}"
TARGET="${TARGET:-2027-01-01 00:00:00}"

# --- Colors ---
RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
MAGENTA='\e[95m'
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
echo -e ""
echo -e ""
echo -e "Study Daily"
echo -e "${DIM}${RESET}» ${MAGENTA}${BOLD}${TITLE}${RESET} ${DIM}──${RESET}"
echo -e "${DAYS}${DIM}d ${WHITE}${BOLD}${HOURS}${RESET}${DIM}h ${WHITE}${BOLD}${MINS}${RESET}${DIM}m ${WHITE}${BOLD}${SECS}${RESET}${DIM}s${RESET} ${DIM}· ${TARGET%% *}${RESET}"
