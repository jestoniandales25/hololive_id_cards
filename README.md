# Hololive Members Browser

A Flutter application that lets you browse Hololive VTuber members in a card-based scroll list, view their recent streams and songs, and securely bookmark your favorite videos. Built as a hands-on introduction to **Enterprise-level Flutter Architecture** integrating **Firebase Authentication**, **Dependency Injection**, **Secure Local Storage**, and the **flutter_bloc** state management library.

---

## Features

- **Google Firebase Authentication** — Secure login system! The root router acts as an Auth Wrapper, securely protecting the app unauthenticated users.
- **Card-Based Member Grid** — Browse all Hololive talents in a 2-column scrollable playing card layout.
- **Dependency Injection (get_it)** — Decoupled repositories utilizing Service Locators for scalable performance and testability.
- **Persistent Secure Bookmarks** — Save your favorite videos per member! Using `flutter_secure_storage`, bookmarks are securely encrypted locally via Android EncryptedSharedPreferences and iOS Keychain, natively isolated to your unique Authentication user ID (`uid`).
- **Profile Picture Backgrounds** — Each card features the member's official Hololive profile picture.
- **Member Video Page** — Tap any card to navigate to a detail screen showing recent streams.
- **In-App Video Player** — Watch videos inside the app using `youtube_player_iframe`.
- **Live & Upcoming Streams** — Past streams, active streams with `LIVE` badges, and anticipated `Upcoming` statuses natively shown.
- **Member Search** — Tap the 🔍 icon to filter members by name in real-time.
- **Pull-to-Refresh** — Swipe down on the member grid to securely refresh the list via BLoC fetches.
- **Secured API Key** — API key is securely encrypted at build time using `envied` with `obfuscate: true`.
- **Centralized Theming** — `AppTheme` abstracts structural styling elements perfectly for clean widget layers.
- **Immutable Models** — Data models generated heavily with `freezed` for type-safe, boilerplate-free modeling.
- **Dio HTTP Client** — Network requests powered by `dio` with interceptors, timeouts, and typed error handling.
- **Skeleton Loading** — Smooth shimmer effects while fetching data for a polished UI.

---

## 🏗️ App Structure
```
lib/
├── blocs/                              # flutter_bloc architectures
│   ├── auth/                           # Firebase authentication state handling
│   ├── hololive/                       # Member, video, and song states
│   └── bookmark/                       # Secure bookmark caching per user
├── core/
│   ├── di/                             # get_it Dependency Injection 
│   │   └── injection.dart
│   ├── env/                            # Environment & API key management
│   ├── navigation/                     # Protected Global Routing
│   └── theme/                          # AppTheme and Semantic colors
├── data/
│   ├── models/                         # Freezed data models
│   └── repositories/                   # Interfaces strictly decoupled from UI
│       ├── auth_repository.dart        # Firebase logic wrapped cleanly
│       └── hololive_repository.dart    # Dio HTTP APIs
└── ui/
    └── screens/                        # App screens
        ├── splash_screen.dart
        ├── login_screen.dart           # UI handling Google Sign-In 
        ├── hololive_dashboard.dart     
        ├── member_detail_screen.dart   
        ├── video_player_screen.dart    
        └── bookmark_screen.dart        
```

---

## 🚀 Getting Started

### Prerequisites 

- Flutter SDK `>=3.11.0`
- Dart `>=3.11.0`
- A free **Holodex API key** from [holodex.net](https://holodex.net) → Settings → API Key
- Android/iOS **Firebase Projects Configuration** (place the generated `google-services.json` inside the `android/app` directory).

### Installation
```bash
# Clone the repository
git clone https://github.com/jestoniandales25/hololive_id_cards.git
cd hololive_id_cards

# Install dependencies
flutter pub get
```

### Environment Setup

Create a `.env` file in the project root:
```env
HOLODEX_API_KEY=your_api_key_here
```

Generate the encrypted key and model files natively:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run the App
```bash
flutter run
```

---

## 📦 Core Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6             # Strict BLoC pattern state management
  firebase_auth: ^6.3.0            # Google Firebase integrations
  google_sign_in: 6.2.1            # Stable Google Sign-In singleton
  get_it: ^9.2.1                   # Dependency Injection Locator
  flutter_secure_storage: ^10.0.0  # Keystore-based local encryption
  dio: ^5.7.0                      # Robust HTTP requests
  envied: ^1.3.3                   # Compile-time secret obfuscation
  freezed_annotation: ^3.1.0       # Immutable data templates
  youtube_player_iframe: ^5.1.1    # In-app YouTube player
```

---

## 🔐 How Bookmarks Scale Securely
Bookmarks are managed uniquely per user session using an interplay between `flutter_secure_storage` and `flutter_bloc`:

- Tap the **🔖 icon** on any video card in the detail screen to securely save it to your Account.
- Every save uses keys concatenated specifically to your Firebase `uid`. If another user signs in on your device, your sensitive history is never leaked over into their dashboard.
- The `AuthWrapper` actively watches session state—whenever you **Log Out**, the `BookmarkBloc` executes a hard wipe of its UI state to prevent lingering phantom data!

---

## 🧑‍💻 Author

**Jestoni Andales**
GitHub: [@jestoniandales25](https://github.com/jestoniandales25)

Made with 💙 as part of a Flutter internship project aiming toward achieving enterprise standards.

---
## 📝 License

This project is for **educational purposes only.**
All Hololive character names, images, and related assets belong to **Cover Corp.**
This app is not affiliated with or endorsed by Cover Corp.
