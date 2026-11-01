#!/usr/bin/env bash

YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL=$(date -d "$YEAR-12-31" +%j)
PERCENT=$(( 100 * TODAY / TOTAL ))
WIDTH=8
FILLED=$(( TODAY * WIDTH / TOTAL ))
EMPTY=$(( WIDTH - FILLED ))

BAR=$(printf "%0.s●" $(seq 1 $FILLED))$(printf "%0.s○" $(seq 1 $EMPTY))

# Large text look
echo "  $PERCENT%"
echo "$YEAR $BAR"
