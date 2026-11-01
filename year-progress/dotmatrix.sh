#!/usr/bin/env bash

YEAR=$(date +%Y)
TODAY=$(date +%j)
TOTAL=$(date -d "$YEAR-12-31" +%j)
PERCENT=$(( 100 * TODAY / TOTAL ))
WIDTH=12
FILLED=$(( TODAY * WIDTH / TOTAL ))
EMPTY=$(( WIDTH - FILLED ))

# Using dots
BAR=$(printf "%0.s•" $(seq 1 $FILLED))$(printf "%0.s⋅" $(seq 1 $EMPTY))

# Simple two-line output
echo "YEAR $YEAR"
echo "$BAR $PERCENT%"
