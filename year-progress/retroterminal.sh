#!/usr/bin/env bash

YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL=$(date -d "$YEAR-12-31" +%j)
PERCENT=$(( 100 * TODAY / TOTAL ))
WIDTH=10
FILLED=$(( TODAY * WIDTH / TOTAL ))
EMPTY=$(( WIDTH - FILLED ))

# Build ASCII Bar
BAR_FILLED=$(printf "%0.s=" $(seq 1 $FILLED))
BAR_EMPTY=$(printf "%0.s " $(seq 1 $EMPTY))

# Color codes
GREEN='\033[0;32m'
RESET='\033[0m'

echo -e "${GREEN}${YEAR}${RESET} [${GREEN}${BAR_FILLED}${RESET}${BAR_EMPTY}] ${PERCENT}%"
