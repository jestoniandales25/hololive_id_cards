# Hololive Members Browser

A Flutter application that lets you browse Hololive VTuber members in a card-based scroll list,
view their recent streams, and bookmark your favorite videos — built as a hands-on introduction
to **Flutter Provider (Bloc Pattern)**.

---

## Features

- **Card-Based Member Grid** — Browse all Hololive talents in a 2-column scrollable playing card layout
- **Profile Picture Backgrounds** — Each card features the member's official Hololive profile picture
- **Member Video Page** — Tap any card to navigate to a detail screen showing recent streams
- **Bookmark System** — *(🚧 In Progress)* Save your favorite member videos using the bookmark icon
- **Secured API Key** — API key is encrypted at build time using `envied` with `obfuscate: true`
- **Immutable Models** — Data models generated with `freezed` for type-safe, boilerplate-free code
- **Dio HTTP Client** — Network requests powered by `dio` with interceptors, timeouts, and typed error handling

---

## Learning Goals

- Understand and implement the **Provider Bloc Pattern** (`ChangeNotifier`)
- Learn how to **secure API keys** using `envied` instead of plain `.env` files
- Use **`freezed`** for immutable data models with auto-generated `fromJson`, `copyWith`, and `==`
- Practice **Flutter navigation** with named routes and `ModalRoute` arguments
- Consume a **real REST API** (Holodex) using `dio` with proper error handling and loading states
- Understand the difference between **networking** (`dio`) and **security** (`envied`) packages

---

## App Structure
```
lib/
├── blocs/                             # Bloc Provider (ChangeNotifier)
│   └── hololive_bloc_provider.dart
├── core/
│   └── env/                           # Environment & API key management
│       ├── env.dart                   # Envied annotations 
│       └── env.g.dart                 # Generated encrypted key 
├── data/
│   ├── models/                        # Freezed data models
│   │   ├── member_model.dart
│   │   ├── member_model.freezed.dart  # Generated
│   │   ├── member_model.g.dart        # Generated
│   │   ├── video_model.dart
│   │   ├── video_model.freezed.dart   # Generated
│   │   └── video_model.g.dart         # Generated
│   └── repositories/                  # API & data logic
│       └── hololive_repository.dart   # Uses Dio for HTTP requests
└── ui/
    └── screens/                       # App screens
        ├── splash_screen.dart
        ├── hololive_dashboard.dart
        └── member_detail_screen.dart
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
  provider: ^6.1.5+1         # State management (Bloc pattern)
  dio: ^5.7.0                 # HTTP client 
  envied: ^1.3.3              # Encrypted API key management
  freezed_annotation: ^3.1.0  # Immutable data models
  json_annotation: ^4.11.0    # JSON serialization
  url_launcher: ^6.3.2        # Open YouTube links

dev_dependencies:
  envied_generator: ^1.3.3    # Envied code generator
  build_runner: ^2.12.2       # Code generation runner
  freezed: ^3.2.5             # Freezed code generator
  json_serializable: ^6.13.0  # JSON code generator
```

---
## How Bookmarks Work

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
