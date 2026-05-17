# AI Co-Founder

A Flutter mobile app that validates startup ideas using AI (ChatGPT) and generates a structured 30-day execution roadmap — like having a co-founder in your pocket.

## ✨ Features

- **Idea Validation** — Enter any startup idea and get an AI-powered analysis including score, market demand, target audience, competitor presence, problems, and actionable suggestions.
- **30-Day Roadmap Generator** — Generate a day-by-day and week-by-week execution plan tailored to your idea.
- **Google Sign-In** — Authenticate with your Google account (Firebase Auth).
- **Cloud Sync** — Save ideas and roadmaps to Firestore for later access.
- **Modern UI** — Material 3 design with Inter font, clean cards, and timeline layout.

## 📸 Screenshots

| Home | Validation Result | Roadmap |
|------|------------------|---------|
| Enter your idea & analyze | View AI validation in structured cards | 30-day timeline plan |

## ⚙️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | GetX |
| AI | OpenAI ChatGPT API (`gpt-4o-mini`) |
| Backend / Auth | Firebase (Auth + Firestore) |
| UI | Material 3, Google Fonts (Inter) |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- A Firebase project with Firestore enabled (Test Mode)
- An OpenAI API key

### Setup

1. **Clone the repo**

```bash
git clone https://github.com/MahalaxmiDhanai/Ai_Cofounder.git
cd Ai_Cofounder
```

2. **Firebase configuration**

   - Go to [Firebase Console](https://console.firebase.google.com), create a project
   - Add Android & iOS apps, download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in `android/app/` and `ios/Runner/` respectively
   - Enable **Google Sign-In** under Authentication → Sign-in method
   - Set Firestore database to Test Mode

3. **Add your OpenAI API key**

   Open `lib/app/constants/api_constants.dart` and replace:

```dart
static const String openAiApiKey = "YOUR_API_KEY";
```

4. **Run the app**

```bash
flutter pub get
flutter run
```

## 📁 Project Structure

```
lib/
├── app/
│   ├── constants/    # API keys & endpoints
│   ├── routes/       # GetX routing (3 screens)
│   └── theme/        # Material 3 theme
├── controllers/      # Business logic (IdeaController)
├── modules/
│   ├── home/         # Idea input screen
│   ├── result/       # Validation result screen
│   └── roadmap/      # 30-day plan screen
├── services/
│   ├── ai_service.dart       # OpenAI API calls
│   ├── auth_service.dart     # Firebase Auth (Google)
│   └── firestore_service.dart# Firestore CRUD
├── widgets/          # Shared widgets (WIP)
└── main.dart         # App entry point
```

## 🗺️ Roadmap — Coming Soon

Planned features in priority order:

| Feature | Status |
|---------|--------|
| **Idea History & Dashboard** — Browse all analyzed ideas with search & filter | 📅 Planned |
| **Pitch Deck Generator** — Auto-generate investor-ready pitch decks | 📅 Planned |
| **Business Model Canvas** — Generate BMC from idea validation data | 📅 Planned |
| **SWOT Analysis** — Deep-dive strengths, weaknesses, opportunities, threats | 📅 Planned |
| **Revenue Model Suggestions** — Monetization strategies based on industry | 📅 Planned |
| **MVP Feature Prioritizer** — Rank features by effort vs. impact | 📅 Planned |
| **Export to PDF** — Download validation results and roadmaps | 📅 Planned |
| **Dark Mode** — Theme toggle support | 📅 Planned |
| **Push Notifications** — Roadmap task reminders | 📅 Planned |
| **Co-founder Matching** — Find potential co-founders with complementary skills | 🔮 Future |
| **Multi-language Support** — i18n for global users | 🔮 Future |
| **CI/CD Pipeline** — Automated builds & testing via GitHub Actions | 🔮 Future |
| **Unit & Widget Tests** — Comprehensive test coverage | 🔮 Future |

## 🤝 Contributing

Contributions are welcome! Open an issue or submit a PR.

## 📄 License

MIT
