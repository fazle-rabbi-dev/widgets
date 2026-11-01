#!/usr/bin/env bash
# Widget: Date (Two-line Compact)

RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
YELLOW='\e[93m'
BLUE='\e[94m'
WHITE='\e[97m'

DAY=$(date "+%d")
MONTH=$(date "+%b")
YEAR=$(date "+%Y")
DOW=$(date "+%A")

echo -e "${YELLOW}${BOLD}${DOW}${RESET} ${WHITE}${DAY} ${YELLOW}${MONTH} ${WHITE}${YEAR}${RESET}"
echo -e "${BLUE}wk $(date +%V)${RESET} ${DIM}| ${WHITE}day $(date +%j)${RESET}"
