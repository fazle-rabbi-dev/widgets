#!/usr/bin/env bash
# Widget: Date (Boxed)

RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
MAGENTA='\e[95m'
WHITE='\e[97m'

DATE_STR=$(date "+%A, %d %B %Y")

echo -e "${MAGENTA}${BOLD}${DATE_STR}${RESET}"
echo -e "${DIM}wk $(date +%V) · day $(date +%j) · month $(date +%m)${RESET}"
