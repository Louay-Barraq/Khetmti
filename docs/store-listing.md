# Store listing (Google Play + App Store)

Arabic is the main language; the listing ships in **ar, en, fr, es**.

## Text (ASO)

Ready-to-upload text lives in `fastlane/metadata/` (fastlane `supply` / `deliver` layout):

| Field | Google Play | App Store | Limit |
|---|---|---|---|
| Title / name | `android/<lang>/title.txt` | `ios/<locale>/name.txt` | 30 |
| Short description / subtitle | `short_description.txt` | `subtitle.txt` | 80 / 30 |
| Promotional text | — | `promotional_text.txt` | 170 |
| Keywords | — | `keywords.txt` (comma-separated, no spaces) | 100 |
| Full description | `full_description.txt` | `description.txt` | 4000 |
| Release notes | `changelogs/1.txt` | `release_notes.txt` | 500 / 4000 |

Locales: Play `ar`, `en-US`, `fr-FR`, `es-ES`; App Store `ar-SA`, `en-US`, `fr-FR`, `es-ES`.

ASO choices:
- **Names carry the main search terms**: «ختمة القرآن الجماعية», "Quran Khatma Groups", "Khatma du Coran", "Khatma del Corán".
- **App Store keywords never repeat words already in the name or subtitle** (Apple indexes those separately), and use alternative spellings people search for: khatam, khatm, koran, juz/yuz, tilawah, wird, mushaf, ramadan.
- **Descriptions** open with the benefit in one sentence, then scannable sections (who it's for, create, join, reserve, live progress, XP and leaderboard, friends, mushaf, languages, privacy).
- Suggested categories: App Store **Lifestyle** (secondary: Books); Google Play **Lifestyle** or **Books & Reference**.

Still needed before submitting: a **privacy policy URL**, a support email/URL, the content rating questionnaire, and Play's Data safety form (account email, username, reading activity; deletion available in-app).

## Images

| Store | Size | Path |
|---|---|---|
| App Store (6.9") | 1290 × 2796 | `store/screenshots/appstore/<lang>/01–08.png` |
| Google Play phone | 1080 × 2160 | `store/screenshots/play/<lang>/01–08.png` |
| Google Play feature graphic | 1024 × 500 | `store/screenshots/play/<lang>/feature_graphic.png` |

The 8 screens: 01 finish the Quran together · 02 create a khatma · 03 reserve and finish · 04 share the code / members · 05 live progress and activity · 06 read in the mushaf and save your place · 07 points, levels and stats (profile khatmas + stats tabs) · 08 compete: leaderboard by XP.

### Regenerating

1. Capture the raw screens (real app, demo data, no account, nothing written to the database):
   ```
   flutter build ios --simulator -t lib/main_screenshots.dart --dart-define-from-file=config/env.json --dart-define=SHOT_LANG=en
   xcrun simctl install booted build/ios/iphonesimulator/Runner.app && xcrun simctl launch booted com.example.khetmti
   xcrun simctl openurl booted "khetmti://shot/khetma/k2"     # any route; tabs are tapped by hand
   xcrun simctl io booted screenshot store/raw/en/03_khatma_sura.png
   ```
   Demo data: `lib/demo/demo_data.dart`. Raw file names are listed in `store/design/copy.mjs`.
2. Render the designs: `node store/design/build.mjs [lang ...]` (needs Playwright; set `PLAYWRIGHT_PATH` to its `index.mjs` if it isn't installed in the project). Copy per language is in `store/design/copy.mjs`.
