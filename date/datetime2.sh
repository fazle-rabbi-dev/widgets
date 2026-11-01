#!/usr/bin/env bash
# Widget: Date (Minimal Dot)

RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
GREEN='\e[92m'
WHITE='\e[97m'

DATE_STR=$(date "+%a %d %b %Y")
YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL_DAYS=$(date -d "$YEAR-12-31" +%j)

echo -e "${DIM}──${RESET} ${GREEN}${BOLD}${DATE_STR}${RESET} ${DIM}──${RESET}"
echo -e "${DIM}day ${WHITE}${BOLD}${TODAY}${RESET}${DIM}/${TOTAL_DAYS} · wk $(date +%V)${RESET}"
