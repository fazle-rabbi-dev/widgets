#!/usr/bin/env bash

# Config
BAR_WIDTH=15
YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL_DAYS=$(date -d "$YEAR-12-31" +%j)

# Math
PROGRESS=$(( 100 * TODAY / TOTAL_DAYS ))
FILLED=$(( TODAY * BAR_WIDTH / TOTAL_DAYS ))
EMPTY=$(( BAR_WIDTH - FILLED ))

# Build Bar
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done

# Output
echo "$YEAR  [$BAR]  $PROGRESS%"
