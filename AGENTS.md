# AGENTS.md

## Project Overview

Terminal widget collection for Android home screen (via Termux + widget app). Widgets output ANSI-colored text meant to be rendered as home screen widgets.

## Structure

```
widgets/
├── countdown/               # Countdown widgets
│   ├── .countdown.conf      # Config: TITLE + TARGET datetime
│   ├── set-countdown.sh     # Config setter CLI
│   ├── countdown1.sh        # Classic
│   ├── countdown2.sh        # Bar with %
│   ├── countdown3.sh        # Minimal dotted
│   └── countdown4.sh        # Label value
├── date/                    # Date-only widgets
│   ├── datetime1.sh         # Classic
│   ├── datetime2.sh         # Minimal dotted
│   ├── datetime3.sh         # Wk/day/month
│   └── datetime4.sh         # Compact split
├── prayer-time/             # Prayer times widgets (Node.js)
│   ├── prayer1.js           # Compact inline
│   ├── prayer2.js           # Boxed grid
│   ├── prayer3.js           # Vertical minimal
│   └── prayer4.js           # Single line dotted
├── system/                  # Battery + RAM widgets
│   ├── system1.sh           # Icon row
│   ├── system2.sh           # Bar style
│   ├── system3.sh           # Dotted single line
│   └── system4.sh           # Label value
└── year-progress/           # Year progress widgets
    ├── combine.sh           # Year progress + sun times (2-line, teal)
    ├── combine2.sh          # Variant: boxed symbols (█░ bar)
    ├── combine3.sh          # Variant: gradient (▮▯ bar)
    ├── combine4.sh          # Variant: segmented (═─ bar)
    ├── blockaesthetic.sh    # 10-block visual bar
    ├── circuler.sh          # Circular-style bar (width 8)
    ├── dotmatrix.sh         # Dot matrix bar
    ├── minimalist.sh        # Minimal bar (width 15)
    └── retroterminal.sh     # Retro terminal bar (width 10)
```

### Countdown Config

`countdown/.countdown.conf` holds `TITLE` and `TARGET` (datetime string).
Update via `bash countdown/set-countdown.sh "Title" "YYYY-MM-DD HH:MM:SS"` or edit the file directly.

## Conventions

### Widget Output
- All widgets output **exactly 2 lines** (except prayer widgets which may use more)
- Use ANSI escape codes for colors — no external dependencies for bash widgets
- Bar width: **12 segments** (hardcoded `BAR_WIDTH=12`)
- Decimal format for percentages (e.g. `83.62%`, not `83%`)

### Colors (common palette)
```
TEAL='\e[36m'    CYAN='\e[96m'    GREEN='\e[92m'    YELLOW='\e[93m'
RED='\e[91m'     BLUE='\e[94m'    MAGENTA='\e[95m'  WHITE='\e[97m'
DIM='\e[2m'      BOLD='\e[1m'     RESET='\e[0m'
```

### Bash Widgets
- Shebang: `#!/usr/bin/env bash`
- No `set -e` — widgets should degrade gracefully
- Battery via `termux-battery-status | jq` (Termux:API app required)
- RAM via `/proc/meminfo` (MemTotal, MemAvailable)
- Sun times via Aladhan API: `https://api.aladhan.com/v1/timings?latitude=...&longitude=...&method=1`
- Year progress: day-of-year / total days, formatted with `awk "%.2f"`

### Node.js Widgets (prayer)
- Shebang: `#!/usr/bin/env node`
- Use global `fetch` (Node 18+)
- Same Aladhan API, method=1 (Muslim World League)
- Asr time offset: **+2 hours** applied via `addHours()` helper
- Location: Mymensingh (24.75, 90.40) — edit `LAT`/`LON` constants to change

### Location (hardcoded)
```
LAT="24.75"  LON="90.40"  METHOD="1"  CITY="Mymensingh"
```

## Dependencies

- `bash`, `awk`, `curl`, `jq` (for bash widgets)
- `node` v18+ (for prayer widgets)
- `termux-api` package + Termux:API APK (for battery)
- Network access (Aladhan API for sun/prayer times)

## Testing

Run any widget directly:
```bash
bash date/datetime1.sh
node prayer-time/prayer1.js
```

Verify 2-line output for non-prayer widgets:
```bash
bash system/system1.sh | wc -l  # should be 2
```

## Notes

- All widgets are grouped by category folder (`date/`, `system/`, `countdown/`, `prayer-time/`, `year-progress/`)
- Combine scripts live in `year-progress/`, variants 2-4 are alternate UI styles
- All variants share same data source and calculations — only presentation differs
- Widgets are refreshed by the home screen widget app on its own interval
- No build step — scripts run as-is
