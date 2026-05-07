# 🤘 Metal World Radio

A modern Flutter application for streaming **Metal radio stations** from around the world.  
Built with **Flutter**, **Riverpod**, and **MediaKit**, featuring live streaming, favorites persistence, and a clean dark UI.

---

## 📱 Features

- 🎸 Stream online Metal radio stations
- ❤️ Save and manage favorite stations
- ⏯️ Play / Pause / Stop controls
- 📻 Mini player always visible
- 🌐 Fetch stations dynamically from Radio Browser API
- 💾 Persistent favorites using SharedPreferences
- ⚡ State management with Riverpod
- 🌙 Dark theme UI

---

## 🚀 Technologies Used

- Flutter
- Dart
- Flutter Riverpod
- MediaKit
- HTTP
- Shared Preferences

---

## 📂 Project Structure

```bash
lib/
│
├── core/
│   └── player/
│       └── radio_player.dart
│
├── data/
│   ├── models/
│   │   └── radio_station.dart
│   └── services/
│       ├── favorites_service.dart
│       └── radio_api_service.dart
│
├── presentation/
│   ├── providers/
│   │   ├── favorites_provider.dart
│   │   └── radio_provider.dart
│   └── views/
│       ├── favorites_view.dart
│       ├── home_page.dart
│       └── radios_view.dart
│
└── main.dart

```
## ⚙️ Installation

### 1️⃣ Clone the repository

```bash
git clone https://github.com/yourusername/metal-world-radio.git
cd metal-world-radio
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the app

```bash
flutter run
```

---

## 🔥 API Used

This project uses the public:

- Radio Browser API

Example endpoint:

```bash
https://de1.api.radio-browser.info/json/stations/bytag/metal
```

---

## 📸 Screenshots

> Add screenshots here later

```md
![Home Screen](assets/screenshots/home.png)
```

---

## 🧠 Architecture

The project follows a simple layered architecture:

### Presentation Layer
- UI
- Providers

### Data Layer
- Services
- Models

### Core Layer
- Audio player logic

This separation improves:

- scalability
- maintainability
- readability

---

## ❤️ Favorites System

Favorite stations are stored locally using:

```dart
SharedPreferences
```

This allows users to keep their favorite stations saved between sessions.

---

## 🎵 Audio Streaming

Streaming is handled using:

```dart
media_kit
```

Features include:

- play
- pause
- stop
- reactive playback state

---

## 📦 Main Dependencies

```yaml
flutter_riverpod: ^2.5.1
media_kit: ^1.2.6
http: ^1.2.0
shared_preferences: ^2.2.2
cached_network_image: ^3.3.0
```

---

## 🛠 Future Improvements

- 🔍 Search radio stations
- 🎨 Custom themes
- 🌍 Genre filters
- 📡 Background playback
- 🔔 Media notifications
- 🎧 Bluetooth controls
- 📱 Responsive tablet layout
- 🌐 Multi-language support

---

## 👨‍💻 Author

### Franco Rodrigo Miranda

Junior Full Stack Developer from Argentina 🇦🇷

- GitHub: https://github.com/MirandaFrancoCBA
- LinkedIn: https://www.linkedin.com/in/franco-rodrigo-miranda-993710248

