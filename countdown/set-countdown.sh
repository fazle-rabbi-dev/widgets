#!/usr/bin/env bash
# Countdown Config Setter
# Usage:
#   ./set-countdown.sh "New Year" "2027-01-01 00:00:00"
#   ./set-countdown.sh                      # show current

CONFIG="$HOME/widgets/countdown/.countdown.conf"

if [ $# -eq 0 ]; then
    if [ -f "$CONFIG" ]; then
        echo "Current countdown:"
        grep '^TITLE=' "$CONFIG" | cut -d= -f2-
        grep '^TARGET=' "$CONFIG" | cut -d= -f2-
    else
        echo "No countdown set."
        echo "Usage: $0 \"Title\" \"YYYY-MM-DD HH:MM:SS\""
    fi
    exit 0
fi

TITLE="${1:-Countdown}"
TARGET="${2:-}"

if [ -z "$TARGET" ]; then
    echo "Please provide a target date."
    echo "Usage: $0 \"Title\" \"YYYY-MM-DD HH:MM:SS\""
    exit 1
fi

# Validate date
if ! date -d "$TARGET" +%s >/dev/null 2>&1; then
    echo "Invalid date format. Use: YYYY-MM-DD HH:MM:SS"
    exit 1
fi

printf 'TITLE="%s"\nTARGET="%s"\n' "$TITLE" "$TARGET" > "$CONFIG"
echo "Countdown set:"
echo "  Title: $TITLE"
echo "  Target: $TARGET"
