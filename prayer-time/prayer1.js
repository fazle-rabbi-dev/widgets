#!/usr/bin/env node
// Widget: Prayer Times (Compact Inline)

const LAT = "24.75", LON = "90.40", METHOD = 1;

const R = "\x1b[0m", B = "\x1b[1m", D = "\x1b[2m";
const GREEN = "\x1b[92m", CYAN = "\x1b[96m", YELLOW = "\x1b[93m", WHITE = "\x1b[97m", MAGENTA = "\x1b[95m";

async function main() {
  const url = `https://api.aladhan.com/v1/timings?latitude=${LAT}&longitude=${LON}&method=${METHOD}`;
  const res = await fetch(url);
  const j = await res.json();
  if (j.code !== 200) { console.log(`${D}prayer times unavailable${R}`); return; }

  const t = j.data.timings;
  const g = j.data.date.gregorian;
  const h = j.data.date.hijri;
  const clean = s => s.split(" ")[0];
  const addHours = (s, h) => {
    let [hh, mm] = s.split(":").map(Number);
    hh = (hh + h) % 24;
    return `${String(hh).padStart(2, "0")}:${String(mm).padStart(2, "0")}`;
  };
  const to12 = s => {
    let [hh, mm] = s.split(":").map(Number);
    const ap = hh < 12 ? "AM" : "PM";
    if (hh === 0) hh = 12; else if (hh > 12) hh -= 12;
    return `${hh}:${String(mm).padStart(2, "0")} ${ap}`;
  };

  const dateStr = `${g.weekday.en}, ${g.day} ${g.month.en} ${g.year}`;
  const hijriStr = `${h.day} ${h.month.en} ${h.year}`;

  const prayers = [
    ["Fajr", t.Fajr], ["Dhuhr", t.Dhuhr], ["Asr", addHours(clean(t.Asr), 2)],
    ["Maghrib", t.Maghrib], ["Isha", t.Isha]
  ];
  const parts = prayers.map(([n, v]) => `${D}${n}${R} ${WHITE}${B}${to12(clean(v))}${R}`);

  console.log(`${GREEN}${B}${dateStr}${R} ${D}· ${YELLOW}${hijriStr} AH${R}`);
  console.log(parts.join(`  ${D}·${R}  `));
}

main().catch(() => console.log(`${D}network error${R}`));
