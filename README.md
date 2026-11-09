# ختمتي — Khetmti

> A collaborative Quran Khatma management app built with Flutter & Supabase.

**Khetmti** (ختمتي, "My Khatma") lets users organize and take part in group Quran readings (Khatma/ختمة). Each Khatma splits the Quran into its 114 Surahs or 30 Juz', participants reserve and finish parts, and the whole Quran is recited together.

---

## ✨ Features

- **Accounts:** email/password sign-up and login with Supabase Auth; change username, email (confirmed by email link) and password (the current one is checked first). "Forgot password" emails a link that opens the app on a "new password" page. Users can delete their account from Settings.
- **Khatmas:** create one split by Surah or Juz' with a member limit and a 5-digit join code; join by code or by searching its name.
- **Reading parts:** reserve, release, finish or undo a part. Each part shows its state in words and color (free, reserved for you, reserved by someone else, finished), and filter chips show how many are in each state. Progress, member counts and the activity log update live for everyone.
- **XP and levels:** reserving and finishing parts earns XP (finishing a Surah gives 50 + 2 per ayah, a Juz' 500); levels follow from XP.
- **Friends and rankings:** search users, send, accept or decline requests, and compare XP with friends.
- **Quran reader:** bundled Quran text (`assets/data/quran.json`) with saved stopping points.

---

## 🏛️ Architecture

Feature-first, with Riverpod for state and go_router for navigation:

```
lib/
├── main.dart              # Supabase init, reads config from --dart-define-from-file
├── app.dart               # MaterialApp.router, global SnackBar messenger
├── core/                  # config (env.dart), providers, theme, helpers
├── router/app_router.dart # routes, auth redirect, bottom-nav shell
├── shared/widgets/        # reusable widgets
└── features/
    ├── auth/              # login, register, AppUser + level formula
    ├── khetma/            # create, join, detail, home list
    ├── social/            # friends, requests, person search
    ├── profile/           # profile, rankings
    ├── quran/             # Quran reader
    ├── settings/          # account settings, help, about
    ├── onboarding/        # splash and onboarding
    └── notifications/
```

Each feature has `data/` (repositories talking to Supabase), `models/`, `providers/` and `presentation/`.

**Live data and caching.** The app keeps few realtime subscriptions and shares them:

- one stream of the user's khatmas feeds the home page, the profile page and every khatma page (opening a khatma you are in costs no new request);
- one stream of the user's friendship rows feeds the friends list, friend requests and the buttons in friend search;
- friends' profiles are fetched again only when the set of friends changes (or on pull-to-refresh);
- streams depend on the user id, not on the auth session, so the hourly token refresh does not reopen them.

The last rows of each stream are kept on the device (`core/cache/local_cache.dart`), so screens fill at once on the next launch and stay readable offline. The cache is cleared on sign-out.

---

## 🗄️ Database (Supabase)

Schema changes live in `supabase/migrations/`; `supabase/tests/` holds SQL checks that roll back after running.

| Table | What it holds |
|-------|---------------|
| `users` | Public profile: `doc_id` (= auth user id), `username`, `totalXP`, `readingStats`, `lastSeen`. Created by the `on_auth_user_created` trigger. Email stays in Supabase Auth. |
| `khatms` | One Khatma: `name`, `code`, `creatorId`, `splitType` (`sura`/`juzu`), `parts` (part → status, reader), progress counters, `logs` (latest 50 actions). |
| `khatm_participants` | Who is in which Khatma (`khatm_id`, `user_id`). |
| `friendships` | `sender`, `receiver`, `status` (`pending`/`accepted`); one row per pair of users. |
| `xp_history` | Every XP change, used for history and rankings. |

Row-level security allows logged-in users only, and each user changes only their own data. Writes that touch several rows go through database functions so they are atomic: `update_part_status` (reserve/finish a part and give XP), `join_khatm` and `delete_my_account` (releases the user's reservations, hands their khatmas to the next member, then deletes the profile and the login).

### Email links

Password-reset and email-change links open the app through the `khetmti://` scheme. Add `khetmti://**` under **Authentication → URL Configuration → Redirect URLs** in the Supabase dashboard; without it Supabase sends users to the Site URL instead.

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| Backend | Supabase (Auth, Postgres, Realtime) |
| State / navigation | flutter_riverpod, go_router |
| Local storage | SharedPreferences |
| UI | percent_indicator, smooth_page_indicator |
| Fonts | Amiri (Arabic), Roboto (Latin) |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.4.3
- A Supabase project
- Android SDK / Xcode for iOS

### Setup
```bash
# Clone the repo
git clone <repo-url>
cd Khetmti

# Install dependencies
flutter pub get

# Add your Supabase URL + anon key (config/env.json is gitignored)
cp config/env.example.json config/env.json

# Run on a connected device
flutter run --dart-define-from-file=config/env.json
```
VS Code picks the flag up from `.vscode/launch.json`; in Zed, use the `Flutter: run` / `Flutter: build …` tasks (`task: spawn`) from `.zed/tasks.json`. Pass the same flag to any manual `flutter build`.

### Build
```bash
# Android APK
flutter build apk --debug --dart-define-from-file=config/env.json

# iOS (requires Mac + Xcode)
flutter build ios --no-codesign --debug --dart-define-from-file=config/env.json
```

### Tests
```bash
flutter test
```
Unit and widget tests cover the level formula, part states, friendship rules, the auth redirect, the local cache, model parsing and the main widgets (part tile, password field, segmented switch).
Run `supabase/tests/*.sql` in the Supabase SQL editor after applying the migrations; each file rolls back what it creates.

---

## 📄 License

This project is private and not published to pub.dev.
