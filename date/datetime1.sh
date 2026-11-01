#!/usr/bin/env bash
# Widget: Date (Classic)

RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
CYAN='\e[96m'
WHITE='\e[97m'

DATE_STR=$(date "+%A, %d %B %Y")

echo -e "${CYAN}${BOLD}${DATE_STR}${RESET}"
echo -e "${DIM}week $(date +%V) · day $(date +%j)${RESET}"
