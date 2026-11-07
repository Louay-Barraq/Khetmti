# ختمتي — Khetmti

> A collaborative Quran Khatma management app built with Flutter & Firebase.

**Khetmti** (ختمتي, "My Khatma") lets users organize and participate in group Quran reading sessions (Khatma/ختمة). Each Khatma divides the 114 Surahs among participants so the entire Quran is recited collectively.

---

## ✨ Features

### Authentication
- Email/password sign-up & login via Firebase Auth
- User profile with display name stored in Firestore
- Change username, email, and password from settings
- Email verification flow for email changes

### Khatma (ختمة) Management
- **Create a Khatma** — name it, set a max participant count; a unique 5-digit code is generated
- **Browse & join** available Khatmas via search
- **Surah booking** — book/unbook individual Surahs within a Khatma
- **Real-time progress** — live completion percentage, finished/unfinished Surah counts, participant numbers
- **Firestore transactions** — atomic booking/unbooking ensures data consistency

### Social
- **Person search** — find users by name
- **Friend requests** — send, accept, decline, and cancel friendship requests
- **Friends list** — view your friends and their levels on the profile page

### Navigation & UX
- 4-tab bottom navigation: Home, Menu, Settings, Profile
- Swipeable `PageView` between tabs
- Onboarding flow (shown once, persisted via `SharedPreferences`)
- Splash screen with gradient background

---

## 🏛️ Architecture

```
lib/
├── main.dart                         # Entry point, Firebase init
├── firebase_options.dart             # Firebase config (auto-generated)
├── auth/
│   ├── auth_page.dart                # Auth state gate (StreamBuilder)
│   └── auth_service.dart             # Sign-up, sign-in, logout, user doc creation
├── themes/
│   └── main_theme.dart               # Color constants
├── components/
│   ├── bottom_nav_bar_with_draggable_sheet.dart
│   ├── custom_button.dart
│   ├── custom_textfield.dart
│   ├── friend_addition_component.dart
│   ├── friend_component.dart
│   ├── introductive_component.dart
│   ├── khetma_component.dart
│   ├── pages_logo.dart
│   ├── possible_action_component.dart
│   ├── profile_page_logo.dart
│   ├── profile_state_switch.dart
│   ├── profile_top_page_box.dart
│   ├── settings_component.dart
│   ├── state_switch.dart
│   └── top_page_box.dart
└── pages/
    ├── authentication/
    │   ├── login_page.dart
    │   └── register_page.dart
    ├── onboarding/
    │   ├── onboarding_items.dart
    │   ├── onboarding_page.dart
    │   └── splash_screen.dart
    ├── main/
    │   ├── index_page.dart           # Tab controller (PageView)
    │   ├── home_page.dart            # Khatma list (yours / others)
    │   ├── menu_page.dart            # Actions: create, join, search
    │   ├── settings_page.dart        # Change name/email/password, logout
    │   └── profile_page.dart         # Friends list, your Khatmas
    ├── Khetma/
    │   └── Khetma_page.dart          # Single Khatma detail + Surah list
    └── actions/
        ├── khetma_creation_page.dart
        ├── khatms_search_page.dart
        ├── person_search_page.dart
        ├── change_email_page.dart
        ├── change_password_page.dart
        └── change_username_page.dart
```

---

## 🗄️ Firestore Data Model

### `users` collection
| Field | Type | Description |
|-------|------|-------------|
| `uid` | `String` | Firebase Auth UID |
| `email` | `String` | User email |
| `username` | `String` | Display name |
| `photoURL` | `String?` | Profile photo URL (unused currently) |
| `level` | `int` | Gamification level (default 1) |
| `khatmsJoined` | `List<String>` | IDs of Khatmas user participates in |
| `friends` | `List<String>` | UIDs of friends |
| `createdAt` | `Timestamp` | Account creation time |
| `updatedAt` | `Timestamp` | Last profile update |

### `khatms` collection
| Field | Type | Description |
|-------|------|-------------|
| `khetmaId` | `String` | Document ID |
| `name` | `String` | Khatma name (beneficiary) |
| `code` | `String` | 5-digit unique join code |
| `creatorId` | `String` | UID of the creator |
| `participants` | `List<String>` | UIDs of all participants |
| `currentParticipantsNumber` | `int` | Live participant count |
| `maxParticipantsNumber` | `int` | Max allowed participants |
| `souras` | `Map<String, String?>` | 114 entries — Surah name → reader display name (null = unbooked) |
| `completionPercent` | `double` | 0.0 to 1.0 |
| `finishedSouras` | `int` | Count of booked Surahs |
| `unfinishedSouras` | `int` | Count of unbooked Surahs |
| `finishedAyahs` | `int` | Total Ayahs of booked Surahs |
| `createdAt` | `Timestamp` | Creation time |

### `friendships` collection
| Field | Type | Description |
|-------|------|-------------|
| `sender` | `String` | UID of request sender (pending) |
| `receiver` | `String` | UID of request receiver (pending) |
| `status` | `String` | `"pending"` |
| `users` | `List<String>` | Both UIDs (accepted friendships) |
| `timestamp` | `Timestamp` | Request/acceptance time |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Storage | Firebase Storage (imported, not yet active) |
| Local Storage | SharedPreferences |
| UI Libraries | percent_indicator, smooth_page_indicator |
| Toasts | fluttertoast |
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
VS Code picks the flag up from `.vscode/launch.json`. Pass the same flag to `flutter build`.

### Build
```bash
# Android APK
flutter build apk --debug --dart-define-from-file=config/env.json

# iOS (requires Mac + Xcode)
flutter build ios --no-codesign --debug --dart-define-from-file=config/env.json
```

---

## 📄 License

This project is private and not published to pub.dev.
