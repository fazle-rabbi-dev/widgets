#!/usr/bin/env node
// Widget: Prayer Times (Boxed Grid)

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
    return `${hh}:${String(mm).padStart(2, "0")} ${ap}`;
  };

  const dateStr = `${g.weekday.en}, ${g.day} ${g.month.en} ${g.year}`;
  const hijriStr = `${h.day} ${h.month.en} ${h.year} AH`;

  const W = 42;
  const pad = s => s.length + (s.replace(/\x1b\[[0-9;]*m/g, "").length - s.length);
  const center = (s, w) => {
    const len = s.replace(/\x1b\[[0-9;]*m/g, "").length;
    const left = Math.floor((w - len) / 2);
    return " ".repeat(Math.max(0, left)) + s;
  };

  const top = `${D}┌${"─".repeat(W)}┐${R}`;
  const bot = `${D}└${"─".repeat(W)}┘${R}`;

  const line1 = `${GREEN}${B}${center(dateStr, W)}${R}`;
  const line2 = `${YELLOW}${center(hijriStr, W)}${R}`;
  const sep = `${D}${center("┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄", W)}${R}`;

  const names = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  const vals = [t.Fajr, t.Dhuhr, addHours(clean(t.Asr), 2), t.Maghrib, t.Isha];

  console.log(top);
  console.log(`${D}│${R}${line1}${D}│${R}`);
  console.log(`${D}│${R}${line2}${D}│${R}`);
  console.log(`${D}│${R}${sep}${D}│${R}`);
  names.forEach((n, i) => {
    const left = `  ${D}${n}${R}`;
    const right = `${WHITE}${B}${to12(clean(vals[i]))}${R}`;
    const line = `${left}${" ".repeat(W - 2 - n.length - 11)}${right}`;
    console.log(`${D}│${R}${line}${D}│${R}`);
  });
  console.log(bot);
}

main().catch(() => console.log(`${D}network error${R}`));
