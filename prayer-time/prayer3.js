#!/usr/bin/env node
// Widget: Prayer Times (Vertical Minimal)

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

  const weekday = g.weekday.en.toUpperCase();
  const dayNum = g.day;
  const monthName = g.month.en;
  const year = g.year;
  const hijriStr = `${h.day} ${h.month.en} ${h.year} AH`;

  console.log("");
  console.log(`  ${GREEN}${B}${weekday}${R}`);
  console.log(`  ${WHITE}${B}${dayNum}${R} ${D}${monthName} ${year}${R}`);
  console.log(`  ${YELLOW}${D}${hijriStr}${R}`);
  console.log(`  ${D}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${R}`);
  console.log("");

  const rows = [
    ["◐", "Fajr", t.Fajr],
    ["◑", "Dhuhr", t.Dhuhr],
    ["◒", "Asr", addHours(clean(t.Asr), 2)],
    ["◐", "Maghrib", t.Maghrib],
    ["◑", "Isha", t.Isha],
  ];

  for (const [icon, name, time] of rows) {
    console.log(`  ${CYAN}${icon}${R}  ${D}${name.padEnd(8)}${R}${WHITE}${B}${to12(clean(time))}${R}`);
  }
  console.log("");
}

main().catch(() => console.log(`${D}network error${R}`));
