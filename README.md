# 📚 LingoBreeze

A cross-platform vocabulary learning app built with **Flutter** (frontend) and **Node.js/Express** (backend). LingoBreeze lets users browse a curated word list, save vocabulary words to the cloud, and manage their personal word collection — all with offline support via local caching.

---
# demo video
<video controls src="demo_video (1).mp4" title="Title"></video>

## ✨ Features

- **Browse & Search Words** — Fetch a vocabulary list from a Node.js REST API and search through it in real time.
- **Save to Cloud** — Save words to Firebase Firestore; duplicate saves are gracefully prevented.
- **Offline-First** — Saved words are cached locally using `shared_preferences` so the app works without internet.
- **Sync on Startup** — On every app launch, the saved word list is refreshed from Firestore.
- **Delete Words** — Remove words from both Firestore and the local cache with a confirmation dialog.
- **Pull-to-Refresh** — Swipe down on the vocabulary screen to sync the latest saved words.
- **Cross-Platform** — Runs on Android, iOS, Web, macOS, Windows, and Linux via Flutter.

---

## 🗂️ Project Structure

```
lingobreeze/
├── backend/                  # Node.js + Express REST API
│   ├── src/
│   │   ├── server.js         # Express app entry point (port 3001)
│   │   ├── routes/
│   │   │   └── words.routes.js   # GET /words endpoint
│   │   └── data/
│   │       └── words.js      # Static vocabulary data (English → Spanish)
│   └── package.json
│
└── frontend/                 # Flutter app
    ├── lib/
    │   ├── main.dart                        # App entry point, Firebase init, Provider setup
    │   ├── models/
    │   │   └── word_model.dart              # WordModel data class
    │   ├── controllers/
    │   │   └── vocabulary_controller.dart   # State management (ChangeNotifier)
    │   ├── services/
    │   │   ├── api_service.dart             # HTTP client for Node.js API
    │   │   ├── firebase_service.dart        # Firestore CRUD operations
    │   │   └── local_storage_service.dart   # SharedPreferences caching
    │   └── views/
    │       ├── vocabulary_screen.dart       # Main screen + word selection sheet
    │       └── widgets/
    │           ├── word_card.dart           # Individual word card UI
    │           ├── empty_state.dart         # Empty list placeholder
    │           └── loading_widget.dart      # Loading indicator
    └── pubspec.yaml
```

---

## 🛠️ Tech Stack

| Layer       | Technology                                                                 |
|-------------|----------------------------------------------------------------------------|
| Frontend    | Flutter (Dart), Provider, Firebase Core, Cloud Firestore, SharedPreferences, HTTP, flutter_spinkit |
| Backend     | Node.js, Express 5, CORS, Nodemon                                          |
| Database    | Firebase Firestore (cloud), SharedPreferences (local cache)                |
| Platforms   | Android, iOS, Web, macOS, Windows, Linux                                   |

---

## ⚙️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.11.5`
- [Node.js](https://nodejs.org/) `>=18`
- A Firebase project with Firestore enabled

---

### 1. Clone the Repository

```bash
git clone https://github.com/Shamimkhan1406/lingobreeze.git
cd lingobreeze
```

---

### 2. Backend Setup

```bash
cd backend
npm install
```

**Start the development server (with auto-reload):**
```bash
npm run dev
```

**Start in production mode:**
```bash
npm start
```

The API will be available at `http://localhost:3001`.

**Available Endpoints:**

| Method | Endpoint | Description              |
|--------|----------|--------------------------|
| GET    | `/`      | Health check             |
| GET    | `/words` | Returns all vocabulary words |

**Example response from `GET /words`:**
```json
{
  "success": true,
  "data": [
    { "id": 1, "word": "Apple", "meaning": "A fruit", "translation": "Manzana" },
    { "id": 2, "word": "Beautiful", "meaning": "Pleasing to look at", "translation": "Hermosa" }
  ]
}
```

---

### 3. Firebase Setup

1. Create a project at [Firebase Console](https://console.firebase.google.com/).
2. Enable **Cloud Firestore** in your project.
3. Register your app (Android/iOS/Web) and download the config files.
4. Replace `frontend/lib/firebase_options.dart` with your generated options using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli):

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

---

### 4. Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

> **Note for Android Emulator:** The backend API URL in `api_service.dart` is set to `http://10.0.2.2:3001`, which maps to `localhost` on an Android emulator. If you run on a physical device, replace this with your machine's local IP address (e.g., `http://192.168.x.x:3001`).

---

## 📱 App Flow

```
App Launch
    ↓
Load words from SharedPreferences (instant display)
    ↓
Sync saved words from Firestore (background)
    ↓
VocabularyScreen (displays saved words)
    ↓
[+ Add Word] → Fetch word list from Node.js API
    ↓
Search & select a word → Save to Firestore + local cache
    ↓
[Delete] → Remove from Firestore + local cache
```

---

## 🔌 Data Model

**WordModel**

| Field         | Type   | Description                        |
|---------------|--------|------------------------------------|
| `id`          | int    | Unique identifier                  |
| `word`        | String | The English vocabulary word        |
| `meaning`     | String | Definition in English              |
| `translation` | String | Spanish translation of the word    |

---

## 🏗️ Architecture

LingoBreeze follows an **MVC + Service Layer** pattern:

- **Model** — `WordModel` is a plain Dart class with `fromJson` / `toJson` serialization.
- **Controller** — `VocabularyController` extends `ChangeNotifier` (Provider) and orchestrates all app state and data flows.
- **Services** — Three dedicated services handle distinct data sources: REST API (`ApiService`), Firestore (`FirebaseService`), and local cache (`LocalStorageService`).
- **Views** — Stateless and stateful Flutter widgets consume the controller via `Consumer<VocabularyController>`.

---

## 🧪 Running Tests

```bash
cd frontend
flutter test
```

---

## 📦 Dependencies

### Backend (`package.json`)

| Package    | Version   | Purpose                          |
|------------|-----------|----------------------------------|
| `express`  | `^5.2.1`  | Web framework                    |
| `cors`     | `^2.8.6`  | Cross-Origin Resource Sharing    |
| `nodemon`  | `^3.1.14` | Dev server with auto-reload      |

### Frontend (`pubspec.yaml`)

| Package               | Version    | Purpose                             |
|-----------------------|------------|-------------------------------------|
| `firebase_core`       | `^4.0.0`   | Firebase initialization             |
| `cloud_firestore`     | `^6.0.0`   | Cloud database                      |
| `provider`            | `^6.1.5`   | State management                    |
| `http`                | `^1.5.0`   | HTTP requests to the backend API    |
| `shared_preferences`  | `^2.5.3`   | Local data persistence              |
| `flutter_spinkit`     | `^5.2.1`   | Loading animations                  |

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to your branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [ISC License](LICENSE).
