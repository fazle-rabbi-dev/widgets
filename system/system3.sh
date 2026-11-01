#!/usr/bin/env bash
# Widget: Battery + RAM (Single Line Dotted)

RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
GREEN='\e[92m'
YELLOW='\e[93m'
RED='\e[91m'
CYAN='\e[96m'
WHITE='\e[97m'

# Battery
BAT=$(termux-battery-status 2>/dev/null | jq -r '.percentage' | cut -d. -f1)
[ -z "$BAT" ] && BAT=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
[ -z "$BAT" ] && BAT="--"
if [ "$BAT" != "--" ]; then
    [ "$BAT" -ge 60 ] && BAT_COLOR="$GREEN"
    [ "$BAT" -lt 60 ] && [ "$BAT" -ge 30 ] && BAT_COLOR="$YELLOW"
    [ "$BAT" -lt 30 ] && BAT_COLOR="$RED"
else
    BAT_COLOR="$DIM"
fi

# RAM
MEM_TOTAL=$(awk '/MemTotal/{print $2}' /proc/meminfo)
MEM_AVAIL=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
RAM_PCT=$(awk "BEGIN {printf \"%.0f\", 100 * ($MEM_TOTAL - $MEM_AVAIL) / $MEM_TOTAL}")

echo -e "${DIM}──${RESET} ${BAT_COLOR}${BOLD}${BAT}%${RESET} ${DIM}·${RESET} ${WHITE}${BOLD}${RAM_PCT}%${RESET} ${DIM}──${RESET}"
echo -e "${DIM}battery · ram${RESET}"
