# Hololive Members Browser

A Flutter application that lets you browse Hololive VTuber members in a card-based scroll list,
view their recent streams and songs, and bookmark your favorite videos — built as a hands-on introduction
to the **flutter_bloc** state management library.

---

## Features

- **Card-Based Member Grid** — Browse all Hololive talents in a 2-column scrollable playing card layout
- **Profile Picture Backgrounds** — Each card features the member's official Hololive profile picture
- **Member Video Page** — Tap any card to navigate to a detail screen showing recent streams
- **In-App Video Player** — Watch videos inside the app using `youtube_player_iframe`
- **Live & Upcoming Streams** — The Streams and Songs tabs now include currently live and upcoming streams alongside past videos, with a red `LIVE` badge shown on active streams
- **Bookmark System** — Save your favorite videos per member; view all bookmarks in a dedicated screen
- **Persistent Bookmarks** — Bookmarks survive app restarts using `shared_preferences`
- **Member Search** — Tap the 🔍 icon in the header to slide in a search bar; the title and talent count animate out while you type to filter members by name in real time
- **Pull-to-Refresh** — Swipe down on the member grid to refresh the list, just like in mobile social apps
- **Secured API Key** — API key is encrypted at build time using `envied` with `obfuscate: true`
- **Immutable Models** — Data models generated with `freezed` for type-safe, boilerplate-free code
- **Dio HTTP Client** — Network requests powered by `dio` with interceptors, timeouts, and typed error handling
- **Skeleton Loading** — Smooth shimmer effects while fetching data for a polished UI
- **Member Detail Tabs** — Toggle seamlessly between a member's recent "Streams" and "Songs"

---

## Learning Goals

- Understand and implement the **flutter_bloc** pattern (State, Events, and Blocs)
- Learn how to **secure API keys** using `envied` instead of plain `.env` files
- Use **`freezed`** for immutable data models with auto-generated `fromJson`, `copyWith`, and `==`
- Practice **Flutter navigation** with named routes and `ModalRoute` arguments
- Consume a **real REST API** (Holodex) using `dio` with proper error handling and loading states
- Understand the difference between **networking** (`dio`) and **security** (`envied`) packages
- Implement **persistent local storage** using `shared_preferences`
- Use **`MultiBlocProvider`** and **`BlocBuilder`** to construct a highly reactive UI layer

---

## App Structure
```
lib/
├── blocs/                              # flutter_bloc implementations
│   ├── hololive/                       # Member, video, and song states
│   └── bookmark/                       # Bookmark state + SharedPreferences
├── core/
│   └── env/                            # Environment & API key management
│       ├── env.dart                    # Envied annotations (you write this)
│       └── env.g.dart                  # Generated encrypted key (git-ignored)
├── data/
│   ├── models/                         # Freezed data models
│   │   ├── member_model.dart
│   │   ├── member_model.freezed.dart   # Generated
│   │   ├── member_model.g.dart         # Generated
│   │   ├── video_model.dart
│   │   ├── video_model.freezed.dart    # Generated
│   │   └── video_model.g.dart          # Generated
│   └── repositories/                   # API & data logic
│       └── hololive_repository.dart    # Uses Dio for HTTP requests
└── ui/
    └── screens/                        # App screens
        ├── splash_screen.dart
        ├── hololive_dashboard.dart     # Member grid + search + pull-to-refresh + bookmark nav
        ├── member_detail_screen.dart   # Stream & Song tabs + Video list + Bookmark toggle
        ├── video_player_screen.dart    # In-app YouTube player
        └── bookmark_screen.dart       # All saved bookmarks
```

---

## Getting Started

### Prerequisites 

- Flutter SDK `>=3.11.0`
- Dart `>=3.11.0`
- A free **Holodex API key** from [holodex.net](https://holodex.net) → Settings → API Key

### Installation
```bash
# Clone the repository
git clone https://github.com/jestoniandales25/hololive_id_cards.git

# Navigate to the project directory
cd hololive_id_cards

# Install dependencies
flutter pub get
```

### Environment Setup

Create a `.env` file in the project root:
```env
HOLODEX_API_KEY=your_api_key_here
```

Generate the encrypted key and model files:
This project uses `build_runner` to generate encrypted keys and data models.
Run this **once after cloning** and **again after any model changes**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run the App
```bash
flutter run
```

---

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6             # Strict BLoC pattern state management
  equatable: ^2.0.5                # Value equality for Bloc states
  dio: ^5.7.0                      # HTTP client
  envied: ^1.3.3                   # Encrypted API key management
  freezed_annotation: ^3.1.0       # Immutable data models
  json_annotation: ^4.11.0         # JSON serialization
  url_launcher: ^6.3.2             # Open YouTube links
  youtube_player_iframe: ^5.1.1    # In-app YouTube player
  shared_preferences: ^2.3.2       # Persistent bookmark storage

dev_dependencies:
  envied_generator: ^1.3.3         # Envied code generator
  build_runner: ^2.12.2            # Code generation runner
  freezed: ^3.2.5                  # Freezed code generator
  json_serializable: ^6.13.0       # JSON code generator
```

---
## How Live & Upcoming Streams Work

The Holodex API is queried with `status: 'live,upcoming,past'` for both the Streams and Songs tabs in the member detail screen. The response includes:

- **Live streams** — displayed with a red `LIVE` badge on the video card thumbnail
- **Upcoming streams** — the Watch label changes to `Upcoming` on the card
- **Past streams** — shown as normal videos with their duration

No manual polling is required — results are always fresh when a member's detail page is opened.

---
## How Bookmarks Work
Bookmarks are managed by `BookmarkBloc` via strict `Events` + `SharedPreferences`:

- Tap the **🔖 icon** on any video card in the detail screen to save it
- The icon turns **teal** when bookmarked and **grey** when not
- Bookmarks are **stored per member** — the detail screen only shows that member's saves
- The **🔖 icon on the dashboard** navigates to the bookmark screen showing **all saved videos** sorted by most recently added
- Bookmarks **survive app restarts** — saved permanently on device via `SharedPreferences`
- Tap the bookmark icon again to **remove** it
```
Detail Screen (member)           Dashboard
  └── 🔖 per video                 └── 🔖 header icon
       saves under member.id              navigates to BookmarkScreen
                                               shows ALL bookmarks
                                               sorted by latest
```

## How `freezed` Models Work

`freezed` generates all boilerplate automatically — you only write the field declarations:
```dart
// You write this:
@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    required String id,
    required String name,
    // ...
  }) = _MemberModel;

  factory MemberModel.fromJson(Map json) =>
      _$MemberModelFromJson(json);
}

// You get these for free ✅
member.copyWith(name: 'New Name'); // immutable update
member1 == member2;                // value equality
print(member);                     // readable toString
member.toJson();                   // JSON serialization
```

Re-run whenever you change a model:
```bash
dart run build_runner build --delete-conflicting-outputs
```
---
## Screenshots

---
## Author

**Jestoni Andales**
GitHub: [@jestoniandales25](https://github.com/jestoniandales25)

Made with 💙 as part of a Flutter internship project.

---
## License

This project is for **educational purposes only.**
All Hololive character names, images, and related assets belong to **Cover Corp.**
This app is not affiliated with or endorsed by Cover Corp.
