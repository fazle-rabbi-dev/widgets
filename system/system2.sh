#!/usr/bin/env bash
# Widget: Battery + RAM (Bar Style)

RESET='\e[0m'
BOLD='\e[1m'
DIM='\e[2m'
GREEN='\e[92m'
YELLOW='\e[93m'
RED='\e[91m'
BLUE='\e[94m'
MAGENTA='\e[95m'
WHITE='\e[97m'

BAR_WIDTH=8

make_bar() {
    local pct=$1 color=$2
    local filled=$(( pct * BAR_WIDTH / 100 ))
    local empty=$(( BAR_WIDTH - filled ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="${color}█${RESET}"; done
    for ((i=0; i<empty; i++)); do bar+="${DIM}░${RESET}"; done
    echo "$bar"
}

# Battery
BAT=$(termux-battery-status 2>/dev/null | jq -r '.percentage' | cut -d. -f1)
[ -z "$BAT" ] && BAT=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
[ -z "$BAT" ] && BAT=0
[ "$BAT" -ge 60 ] && BAT_COLOR="$GREEN"
[ "$BAT" -lt 60 ] && [ "$BAT" -ge 30 ] && BAT_COLOR="$YELLOW"
[ "$BAT" -lt 30 ] && BAT_COLOR="$RED"

# RAM
MEM_TOTAL=$(awk '/MemTotal/{print $2}' /proc/meminfo)
MEM_AVAIL=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
RAM_PCT=$(awk "BEGIN {printf \"%.0f\", 100 * ($MEM_TOTAL - $MEM_AVAIL) / $MEM_TOTAL}")

echo -e "${GREEN}⚡ ${BAT}% ${RESET}$(make_bar $BAT $GREEN)"
echo -e "${MAGENTA}ram ${WHITE}${RAM_PCT}% ${RESET}$(make_bar $RAM_PCT $MAGENTA)"
