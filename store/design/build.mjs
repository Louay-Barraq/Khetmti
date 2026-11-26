// Renders the store screenshots and the Play feature graphic from store/raw/<lang>/*.png.
//   node store/design/build.mjs [lang ...]        (default: ar en fr es)
// Output: store/screenshots/{appstore,play}/<lang>/NN.png and store/screenshots/play/<lang>/feature_graphic.png
// Needs Playwright (Chromium); set PLAYWRIGHT_PATH to its index.mjs if it isn't resolvable.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { slides, copy } from './copy.mjs';

const { chromium } = await import(process.env.PLAYWRIGHT_PATH || 'playwright');
const DIR = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(DIR, '../..');
const url = (p) => pathToFileURL(p).href;

const SIZES = { appstore: [1290, 2796], play: [1080, 2160] };
const LANGS = process.argv.slice(2).length ? process.argv.slice(2) : ['ar', 'en', 'fr', 'es'];

// Material-style icons (24px viewBox)
const ICON = {
  group: 'M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5C15 14.17 10.33 13 8 13zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z',
  book: 'M21 5c-1.11-.35-2.33-.5-3.5-.5-1.95 0-4.05.4-5.5 1.5-1.45-1.1-3.55-1.5-5.5-1.5S2.45 4.9 1 6v14.65c0 .25.25.5.5.5.1 0 .15-.05.25-.05C3.1 20.45 5.05 20 6.5 20c1.95 0 4.05.4 5.5 1.5 1.35-.85 3.8-1.5 5.5-1.5 1.65 0 3.35.3 4.75 1.05.1.05.15.05.25.05.25 0 .5-.25.5-.5V6c-.6-.45-1.25-.75-2-1zm0 13.5c-1.1-.35-2.3-.5-3.5-.5-1.7 0-4.15.65-5.5 1.5V8c1.35-.85 3.8-1.5 5.5-1.5 1.2 0 2.4.15 3.5.5v11.5z',
  bolt: 'M11 21h-1l1-7H7.5c-.58 0-.57-.32-.38-.66.19-.34.05-.08.07-.12C8.48 10.94 10.42 7.54 13 3h1l-1 7h3.5c.49 0 .56.33.47.51l-.07.15C12.96 17.55 11 21 11 21z',
  split: 'M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z',
  key: 'M12.65 10C11.83 7.67 9.61 6 7 6c-3.31 0-6 2.69-6 6s2.69 6 6 6c2.61 0 4.83-1.67 5.65-4H17v4h4v-4h2v-4H12.65zM7 14c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z',
  check: 'M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z',
  filter: 'M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z',
  search: 'M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z',
  history: 'M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z',
  bookmark: 'M17 3H7c-1.1 0-1.99.9-1.99 2L5 21l7-3 7 3V5c0-1.1-.9-2-2-2z',
  star: 'M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z',
  chart: 'M5 9.2h3V19H5zM10.6 5h2.8v14h-2.8zm5.6 8H19v6h-2.8z',
  trophy: 'M19 5h-2V3H7v2H5c-1.1 0-2 .9-2 2v1c0 2.55 1.92 4.63 4.39 4.94.63 1.5 1.98 2.63 3.61 2.96V19H7v2h10v-2h-4v-3.1c1.63-.33 2.98-1.46 3.61-2.96C19.08 12.63 21 10.55 21 8V7c0-1.1-.9-2-2-2zM5 8V7h2v3.82C5.84 10.4 5 9.3 5 8zm14 0c0 1.3-.84 2.4-2 2.82V7h2v1z',
  globe: 'M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm6.93 6h-2.95c-.32-1.25-.78-2.45-1.38-3.56 1.84.63 3.37 1.91 4.33 3.56zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2s.06 1.34.14 2H4.26zm.82 2h2.95c.32 1.25.78 2.45 1.38 3.56-1.84-.63-3.37-1.9-4.33-3.56zm2.95-8H5.08c.96-1.66 2.49-2.93 4.33-3.56C8.81 5.55 8.35 6.75 8.03 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2s.07-1.35.16-2h4.68c.09.65.16 1.32.16 2s-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95c-.96 1.65-2.49 2.93-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2s-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z',
  shield: 'M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z',
};
const svg = (name, size) => `<svg viewBox="0 0 24 24" width="${size}" height="${size}"><path fill="currentColor" d="${ICON[name]}"/></svg>`;

const FONT_CSS = `
@font-face{font-family:Plex;src:url(${url(DIR + '/fonts/IBMPlexSansArabic-Bold.ttf')});font-weight:700}
@font-face{font-family:Plex;src:url(${url(DIR + '/fonts/IBMPlexSansArabic-SemiBold.ttf')});font-weight:600}
@font-face{font-family:Plex;src:url(${url(DIR + '/fonts/IBMPlexSansArabic-Medium.ttf')});font-weight:500}
@font-face{font-family:Pop;src:url(${url(DIR + '/fonts/Poppins-Bold.ttf')});font-weight:700}
@font-face{font-family:Pop;src:url(${url(DIR + '/fonts/Poppins-SemiBold.ttf')});font-weight:600}
@font-face{font-family:Pop;src:url(${url(DIR + '/fonts/Poppins-Medium.ttf')});font-weight:500}
@font-face{font-family:Pop;src:url(${url(DIR + '/fonts/Poppins-Regular.ttf')});font-weight:400}`;

// A realistic phone: titanium rim, black bezel, dynamic island, side buttons, real screenshot inside.
function phone(src, w, { x, y, ry = 0, rx = 4, rz = 0, z = 1, shadow = 1 }) {
  const r = w * 0.16;
  return `
  <div class="ph" style="left:${x}px;top:${y}px;width:${w}px;z-index:${z};transform:perspective(${w * 5}px) rotateY(${ry}deg) rotateX(${rx}deg) rotateZ(${rz}deg)">
    <div class="ph-shadow" style="border-radius:${r}px;opacity:${shadow}"></div>
    <div class="ph-btn" style="left:-${w * 0.012}px;top:${w * 0.42}px;height:${w * 0.13}px;width:${w * 0.016}px"></div>
    <div class="ph-btn" style="left:-${w * 0.012}px;top:${w * 0.6}px;height:${w * 0.13}px;width:${w * 0.016}px"></div>
    <div class="ph-btn" style="right:-${w * 0.012}px;top:${w * 0.5}px;height:${w * 0.2}px;width:${w * 0.016}px"></div>
    <div class="ph-rim" style="border-radius:${r}px;padding:${w * 0.012}px">
      <div class="ph-bezel" style="border-radius:${r * 0.93}px;padding:${w * 0.026}px">
        <div class="ph-screen" style="border-radius:${r * 0.8}px">
          <img src="${src}">
          <div class="ph-island" style="top:${w * 0.03}px;width:${w * 0.29}px;height:${w * 0.085}px"></div>
          <div class="ph-glare"></div>
        </div>
      </div>
    </div>
  </div>`;
}

const BASE_CSS = `
*{margin:0;padding:0;box-sizing:border-box}
html,body{background:#fff}
.stage{position:relative;overflow:hidden;background:#fff}
.dots{position:absolute;inset:0;background-image:radial-gradient(rgba(16,29,45,.07) 2.2px,transparent 2.6px);background-size:var(--dot) var(--dot);
  -webkit-mask-image:linear-gradient(180deg,#000 0%,rgba(0,0,0,.35) 45%,transparent 70%)}
.wave{position:absolute;inset:0}
.ph{position:absolute;transform-style:preserve-3d}
.ph-shadow{position:absolute;inset:3% -2% -3% 4%;background:rgba(5,40,20,.45);filter:blur(40px);transform:translateZ(-1px)}
.ph-btn{position:absolute;background:linear-gradient(90deg,#3a3f46,#8b929b,#3a3f46);border-radius:6px}
.ph-rim{position:relative;background:linear-gradient(135deg,#9aa1a9 0%,#e4e7ea 18%,#6c737b 40%,#c9cdd2 62%,#5b6168 82%,#d8dbde 100%)}
.ph-bezel{background:#05070a}
.ph-screen{position:relative;overflow:hidden;background:#fff;line-height:0}
.ph-screen img{width:100%;display:block}
.ph-island{position:absolute;left:50%;transform:translateX(-50%);background:#000;border-radius:999px}
.ph-glare{position:absolute;inset:0;background:linear-gradient(115deg,rgba(255,255,255,.18) 0%,rgba(255,255,255,0) 32%)}
.chip{display:inline-flex;align-items:center;gap:.45em;background:#E8F5E9;color:#0a7a3a;border-radius:999px;font-weight:600;white-space:nowrap}
.chip .ic{display:inline-flex;align-items:center;justify-content:center;border-radius:50%;background:#fff;color:#00A846}
`;

function portrait(lang, slide, [W, H]) {
  const c = copy[lang], [l1, l2, sub, chips] = c.s[slide.id];
  const rtl = lang === 'ar', u = W / 1290;
  const ff = rtl ? 'Plex' : 'Pop';
  const raw = (n) => url(`${ROOT}/store/raw/${lang}/${n}.png`);
  const mx = (x, w) => (rtl ? W - x - w : x);      // mirror for Arabic: phones and waves swap sides
  const side = rtl ? -1 : 1;

  let phones;
  if (slide.single) {
    const w = 860 * u;
    phones = phone(raw(slide.screens[0]), w, { x: mx(215 * u, w), y: H * 0.385, ry: -12 * side, rz: -2 * side, z: 2 });
  } else {
    const wf = 700 * u, wb = 620 * u;
    phones =
      phone(raw(slide.screens[1]), wb, { x: mx(600 * u, wb), y: H * 0.36, ry: -18 * side, rz: 4 * side, z: 1, shadow: 0.7 }) +
      phone(raw(slide.screens[0]), wf, { x: mx(70 * u, wf), y: H * 0.43, ry: 16 * side, rz: -3 * side, z: 2 });
  }
  const chipHtml = chips.map((t, i) => `<span class="chip" style="font-size:${36 * u}px;padding:${12 * u}px ${26 * u}px ${12 * u}px ${12 * u}px;${rtl ? `padding:${12 * u}px ${12 * u}px ${12 * u}px ${26 * u}px;` : ''}">
      <span class="ic" style="width:${54 * u}px;height:${54 * u}px">${svg(slide.chips[i], 32 * u)}</span>${t}</span>`).join('');

  // the green wave sweeps from the bottom corner behind the phones
  const wave = `<svg class="wave" viewBox="0 0 1290 2796" preserveAspectRatio="none" style="transform:scaleX(${side})">
    <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#00E676"/><stop offset="1" stop-color="#00A846"/></linearGradient></defs>
    <path d="M0 1500 C 380 1330 760 1680 1290 1180 L1290 2796 L0 2796 Z" fill="url(#g)"/>
    <path d="M0 1640 C 420 1470 820 1820 1290 1380 L1290 2796 L0 2796 Z" fill="#fff" opacity=".10"/>
  </svg>`;

  return `<!doctype html><html dir="${rtl ? 'rtl' : 'ltr'}"><head><meta charset="utf-8"><style>${FONT_CSS}${BASE_CSS}
  .stage{width:${W}px;height:${H}px;font-family:${ff};--dot:${34 * u}px}
  .top{position:absolute;top:${130 * u}px;left:${110 * u}px;right:${110 * u}px;z-index:5}
  .brand{display:flex;align-items:center;gap:${22 * u}px;font-weight:700;font-size:${50 * u}px;color:#101D2D;margin-bottom:${54 * u}px}
  .brand img{width:${92 * u}px;height:${92 * u}px;border-radius:50%;box-shadow:0 ${10 * u}px ${30 * u}px rgba(0,120,60,.3)}
  .hl{font-weight:700;color:#101D2D;font-size:${(rtl ? 128 : 118) * u}px;line-height:${rtl ? 1.22 : 1.08};letter-spacing:${rtl ? 0 : -1.5 * u}px;white-space:nowrap}
  .hl.acc{color:#00B44A}
  .sub{margin-top:${34 * u}px;font-weight:500;font-size:${(rtl ? 50 : 44) * u}px;line-height:1.45;color:#4B5563;max-width:${1000 * u}px}
  .chips{margin-top:${44 * u}px;display:flex;flex-wrap:wrap;gap:${16 * u}px}
  </style></head><body><div class="stage">
    <div class="dots"></div>${wave}
    <div class="top">
      <div class="brand"><img src="${url(ROOT + '/assets/images/Khetmti - App Logo.png')}">${c.brand}</div>
      <div class="hl"><span>${l1}</span></div><div class="hl acc"><span>${l2}</span></div>
      <div class="sub">${sub}</div>
      <div class="chips">${chipHtml}</div>
    </div>
    ${phones}
  </div>
  <script>
    // shrink a headline line until it fits the text column (called once the fonts are loaded)
    window.fit = () => {
    const max = ${1070 * u};
    // measure the text span itself: a block's scrollWidth is unreliable for right-to-left overflow
    for (const el of document.querySelectorAll('.hl')) { let s = parseFloat(getComputedStyle(el).fontSize); while (el.firstElementChild.getBoundingClientRect().width > max && s > 40) { s -= 2; el.style.fontSize = s + 'px'; } }
    const hs = [...document.querySelectorAll('.hl')].map(e => parseFloat(e.style.fontSize || getComputedStyle(e).fontSize));
    const m = Math.min(...hs); document.querySelectorAll('.hl').forEach(e => e.style.fontSize = m + 'px');
    };
  </script></body></html>`;
}

function feature(lang) {
  const W = 1024, H = 500, c = copy[lang], [l1, l2, sub, feats, badge] = c.feature;
  const rtl = lang === 'ar', ff = rtl ? 'Plex' : 'Pop';
  const raw = (n) => url(`${ROOT}/store/raw/${lang}/${n}.png`);
  const mx = (x, w) => (rtl ? W - x - w : x), side = rtl ? -1 : 1;
  const icons = ['group', 'book', 'star', 'globe'];
  const featHtml = feats.map((t, i) => `<div class="f"><span class="fi">${svg(icons[i], 17)}</span><span>${t}</span></div>`).join('');
  const wave = `<svg class="wave" viewBox="0 0 1024 500" preserveAspectRatio="none" style="transform:scaleX(${side})">
    <defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#00E676"/><stop offset="1" stop-color="#00A846"/></linearGradient></defs>
    <path d="M610 0 C 520 140 700 300 560 500 L1024 500 L1024 0 Z" fill="url(#g)"/>
    <path d="M680 0 C 600 160 760 300 640 500 L1024 500 L1024 0 Z" fill="#fff" opacity=".1"/></svg>`;
  return `<!doctype html><html dir="${rtl ? 'rtl' : 'ltr'}"><head><meta charset="utf-8"><style>${FONT_CSS}${BASE_CSS}
  .stage{width:${W}px;height:${H}px;font-family:${ff};--dot:16px}
  .txt{position:absolute;top:34px;${rtl ? 'right' : 'left'}:44px;width:500px;z-index:5}
  .logo{width:66px;height:66px;border-radius:50%;box-shadow:0 6px 18px rgba(0,120,60,.3)}
  .hl{font-weight:700;color:#101D2D;font-size:${rtl ? 50 : 46}px;line-height:${rtl ? 1.25 : 1.08};letter-spacing:${rtl ? 0 : -.5}px;white-space:nowrap}
  .hl.acc{color:#00B44A}
  .sub{margin-top:10px;font-weight:500;font-size:${rtl ? 17 : 15.5}px;line-height:1.45;color:#4B5563;max-width:440px}
  .feats{display:flex;flex-wrap:wrap;gap:10px 16px;margin-top:16px;max-width:430px}
  .f{display:flex;align-items:center;gap:7px;font-weight:600;font-size:${rtl ? 13.5 : 12.5}px;color:#0a7a3a;white-space:nowrap}
  .fi{width:32px;height:32px;border-radius:50%;background:#E8F5E9;display:inline-flex;align-items:center;justify-content:center;color:#00A846}
  .badge{display:inline-flex;align-items:center;gap:8px;margin-top:18px;background:#0a7a3a;color:#fff;border-radius:14px;padding:9px 16px;font-weight:600;font-size:${rtl ? 15 : 14}px}
  </style></head><body><div class="stage"><div class="dots"></div>${wave}
    <div class="txt"><img class="logo" src="${url(ROOT + '/assets/images/Khetmti - App Logo.png')}"><div style="height:12px"></div>
      <div class="hl"><span>${l1}</span></div><div class="hl acc"><span>${l2}</span></div><div class="sub">${sub}</div>
      <div class="feats">${featHtml}</div><div class="badge">${svg('shield', 18)}${badge}</div></div>
    ${phone(raw('02_khatma_juz'), 200, { x: mx(790, 200), y: 40, ry: -14 * side, rz: 4 * side, z: 1, shadow: 0.6 })}
    ${phone(raw('01_home'), 220, { x: mx(600, 220), y: 70, ry: 14 * side, rz: -3 * side, z: 2 })}
  </div><script>
    window.fit = () => { for (const el of document.querySelectorAll('.hl')) { let s = parseFloat(getComputedStyle(el).fontSize); while (el.firstElementChild.getBoundingClientRect().width > 500 && s > 20) { s -= 1; el.style.fontSize = s + 'px'; } } };
  </script></body></html>`;
}

const browser = await chromium.launch();
const tmp = path.join(DIR, '.tmp'); fs.mkdirSync(tmp, { recursive: true });
async function render(html, [w, h], out) {
  const f = path.join(tmp, 'page.html'); fs.writeFileSync(f, html);
  const page = await browser.newPage({ viewport: { width: w, height: h }, deviceScaleFactor: 1 });
  await page.goto(url(f)); await page.evaluate(async () => { await document.fonts.ready; window.fit && window.fit(); }); await page.waitForTimeout(150);
  fs.mkdirSync(path.dirname(out), { recursive: true });
  await page.screenshot({ path: out, clip: { x: 0, y: 0, width: w, height: h } });
  await page.close();
  console.log(path.relative(ROOT, out));
}
for (const lang of LANGS) {
  for (const [store, size] of Object.entries(SIZES)) {
    for (const s of slides) await render(portrait(lang, s, size), size, `${ROOT}/store/screenshots/${store}/${lang}/${s.id}.png`);
  }
  await render(feature(lang), [1024, 500], `${ROOT}/store/screenshots/play/${lang}/feature_graphic.png`);
}
await browser.close();
fs.rmSync(tmp, { recursive: true, force: true });
