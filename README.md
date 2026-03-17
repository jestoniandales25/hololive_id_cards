# Hololive Members Browser

A Flutter application that lets you browse Hololive members in a card-based scroll list, view their full profiles, and bookmark your favorites — built as a hands-on introduction to **Flutter Provider**.

---

## Features

- **Scroll List with Card Format** — Browse all Hololive members in a scrollable card list
- **Profile Picture Backgrounds** — Each card features the members's Hololive profile picture as the background
- **Hololive Member's Detail Page** — Tap any card to navigate to a full information page about the selected member
- **Bookmark System** — Save your favorite member using the bookmark icon, powered by Flutter Provider

---
## Learning Goals

---
## App Structure
lib/
- blocs/ (Bloc Provider Management)
- core/
  - env/ (Envireonment Management (e.g. .env))
- data/
  - models/ (Handles Data Models (e.g. Member Model))
  - repositories/ (Handles Data Logic e.g Member Repository)
- ui/
  - screens/ (App Screens e.g. home, details)
---

## Getting Started

### Prerequisites 
#### Dependencies
- Flutter SDK `>=3.11.0`
- Dart `>=3.11.0`
- provider `>=6.1.5+1`
- http `>=1.6.0` 
- envied `>=1.3.3`
- freezed_annotation `>=3.1.0`
- json_annotation `>=4.11.0`
- url_launcher `>=6.3.2`

#### Dev_Dependencies
- envied_generator `>=1.3.3`
- build_runner `>=2.12.2`
- freezed `>=3.2.5`
- json_serializable `>=6.13.0`

### Installation

```bash
# Clone the repository
git clone https://github.com/jestoniandales25/hololive_id_cards.git

# Navigate to the project directory
cd hololive_id_cards

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
```

---
## How Bookmarks Work

---
## Screenshots

---
## Author

Made with 💙 as part of a Flutter internship project.

---
## License

This project is for educational purposes only. All Hololive character names, images, and related assets belong to **Cover Corp**.
