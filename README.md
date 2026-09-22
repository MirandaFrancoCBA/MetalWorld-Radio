# 🤘 Metal World Radio

Metal World Radio is a Flutter app for discovering and streaming Metal radio stations from around the world.

## V1 status

The repository is being hardened for a stable V1 release. The app already includes the core product flow: station discovery, search and filters, favorites, foreground/background audio playback, Android media controls and a dark Metal-focused UI.

## Features

- Stream Metal radio stations from the public Radio Browser API
- Search stations by name
- Filter by Metal subgenre and country
- Save favorites locally with SharedPreferences
- Persistent mini player with play, pause and stop controls
- Background audio playback with Android media notification controls
- Cached station artwork with graceful fallbacks
- Dark responsive UI built with Flutter

## Tech stack

- Flutter / Dart
- Riverpod
- just_audio
- audio_service
- HTTP
- SharedPreferences
- cached_network_image

## Architecture

```text
lib/
├── core/
│   └── player/          # audio handler + player state
├── data/
│   ├── models/          # RadioStation
│   └── services/        # Radio Browser + favorites persistence
├── presentation/
│   ├── providers/       # Riverpod state
│   └── views/           # splash, stations, favorites, shell
└── main.dart
```

The project uses a small layered structure so API/persistence, playback logic and UI state remain separated.

## Run locally

Requirements: Flutter compatible with Dart SDK `^3.11.5` and an Android/iOS/desktop target supported by your local Flutter setup.

```bash
git clone https://github.com/MirandaFrancoCBA/MetalWorld-Radio.git
cd MetalWorld-Radio
flutter pub get
flutter run
```

## Quality checks

```bash
flutter analyze
flutter test
```

GitHub Actions will run these checks on pushes and pull requests after the V1 hardening workflow is merged.

## Data source

Stations are loaded from the public [Radio Browser](https://www.radio-browser.info/) API using the Metal tag. Availability and stream quality depend on third-party stations and the public API.

## V1 release checklist

- [x] Core station list and streaming flow
- [x] Search and filters
- [x] Favorites persistence
- [x] Background playback and media controls
- [ ] Automated CI and tests
- [ ] Android application identity cleanup
- [ ] Release build/device smoke test
- [ ] GitHub V1.0.0 release

## Author

**Franco Rodrigo Miranda**  
Backend Developer | Python & Django — also building cross-platform applications with Flutter.

- GitHub: https://github.com/MirandaFrancoCBA
- LinkedIn: https://www.linkedin.com/in/franco-rodrigo-miranda-993710248
- Portfolio: https://mirandafrancocba.github.io/Portfolio/
