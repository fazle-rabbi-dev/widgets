#!/usr/bin/env node
// Widget: Prayer Times (Single Line Dotted)

const LAT = "24.75", LON = "90.40", METHOD = 1;

const R = "\x1b[0m", B = "\x1b[1m", D = "\x1b[2m";
const GREEN = "\x1b[92m", CYAN = "\x1b[96m", YELLOW = "\x1b[93m", WHITE = "\x1b[97m";

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
    return `${hh}:${String(mm).padStart(2, "0")}${ap}`;
  };

  const dateStr = `${g.weekday.en.slice(0, 3)} ${g.day} ${g.month.en.slice(0, 3)} ${g.year}`;
  const hijriStr = `${h.day} ${h.month.en.slice(0, 3)} ${h.year}`;

  const prayers = [
    ["F", t.Fajr], ["D", t.Dhuhr], ["A", addHours(clean(t.Asr), 2)],
    ["M", t.Maghrib], ["I", t.Isha]
  ];
  const parts = prayers.map(([n, v]) => `${CYAN}${n}${R}${WHITE}${B}${to12(clean(v))}${R}`);

  console.log(`${D}──${R} ${GREEN}${B}${dateStr}${R} ${D}·${R} ${YELLOW}${hijriStr} AH${R} ${D}──${R}`);
  console.log(parts.join(`  ${D}·${R}  `));
}

main().catch(() => console.log(`${D}network error${R}`));
