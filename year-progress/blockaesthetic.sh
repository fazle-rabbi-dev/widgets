#!/usr/bin/env bash

YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL=$(date -d "$YEAR-12-31" +%j)
PERCENT=$(( 100 * TODAY / TOTAL ))

# 10-block visual bar
FILLED=$(( TODAY * 10 / TOTAL ))
EMPTY=$(( 10 - FILLED ))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="■"; done
for ((i=0; i<EMPTY; i++)); do BAR+="□"; done

echo -e ">$YEAR \e[1m$PERCENT%\e[0m"
echo -e "\e[36m$BAR\e[0m" # Cyan color
