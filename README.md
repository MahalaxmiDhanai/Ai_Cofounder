# AI Co-Founder

A Flutter mobile app that acts as your AI-powered startup co-founder — validate ideas, generate business plans, analyze competitors, create pitch decks, chat with an AI mentor, and more.

## ✨ Features

### Core Tools
| Feature | Description |
|---------|-------------|
| **Idea Validation** | AI analyzes your startup idea and returns a score, market demand, target audience, competitors, risks, revenue potential, and suggestions |
| **Business Plan Generator** | Generates startup name suggestions, elevator pitch, mission & vision, business model canvas, revenue model, and go-to-market strategy |
| **AI Task Planner** | 30-day execution roadmap broken into days and weeks (Day 1-3, Week 1-4) |
| **Competitor Analysis** | Enter competitor names and get strengths, weaknesses, pricing, feature comparison, and opportunities |
| **Pitch Deck Generator** | Auto-create investor-ready pitch deck outline (Problem, Solution, Market, Business Model, Team, Financials) |
| **Market Research Assistant** | Industry trends, customer pain points, keywords, and market opportunities |
| **Funding Readiness Checker** | Assess startup readiness with MVP, revenue, pitch quality checks — get an investor readiness score |
| **Smart Goal Tracking** | Add, track, and complete startup goals with milestones. Progress dashboard with Firestore sync |

### AI Mentor Chat
- Conversational AI mentor you can ask anything: *"How do I get first users?"*, *"Should I bootstrap or raise funds?"*, *"What features should I build first?"*
- **Voice Co-Founder** — Use the mic button to speak your questions instead of typing (speech-to-text)

### Platform
- **Bottom Navigation** — 4 tabs: Home Dashboard, AI Chat, Tools, Profile
- **Dark Mode** — Toggle in Profile or from the home screen
- **Google Sign-In** — Firebase Authentication
- **Cloud Sync** — All ideas and goals saved to Firestore
- **Material 3** — Modern UI with Inter font

## 📸 Screenshots

| Dashboard | Chat | Tools |
|-----------|------|-------|
| All tools at a glance | AI Mentor with voice | Grid of all features |

## ⚙️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | GetX |
| AI | OpenAI ChatGPT API (`gpt-4o-mini`) |
| Backend / Auth | Firebase (Auth + Firestore) |
| Voice | `speech_to_text` package |
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
│   └── theme/        # Material 3 light & dark themes
├── controllers/
│   ├── main_controller.dart   # Navigation, theme toggle
│   ├── idea_controller.dart   # All AI tool logic
│   └── chat_controller.dart   # Mentor chat + voice
├── modules/
│   ├── dashboard/     # Home screen with tool cards
│   ├── chat/          # AI Mentor Chat with voice input
│   ├── profile/       # Settings, auth, dark mode
│   ├── tools/         # All tool screens
│   │   ├── business_plan_view.dart
│   │   ├── competitor_analysis_view.dart
│   │   ├── pitch_deck_view.dart
│   │   ├── market_research_view.dart
│   │   ├── funding_check_view.dart
│   │   ├── goal_tracking_view.dart
│   │   ├── roadmap_view.dart
│   │   └── tools_list_view.dart
│   └── validate/      # Idea input & validation result
├── services/
│   ├── ai_service.dart         # All OpenAI prompts
│   ├── auth_service.dart       # Firebase Auth (Google)
│   └── firestore_service.dart  # Firestore CRUD
└── main.dart          # App shell with bottom nav
```

## 🗺️ Roadmap — Coming Soon

| Feature | Status |
|---------|--------|
| **Idea History & Dashboard** — Browse all past analyzed ideas with search & filter | 📅 Planned |
| **Pitch Deck Export (PDF)** — Download pitch deck as PDF | 📅 Planned |
| **Push Notifications** — Daily goal reminders & task alerts | 📅 Planned |
| **Multi-language Support** — i18n for global users | 🔮 Future |
| **CI/CD Pipeline** — Automated builds & testing via GitHub Actions | 🔮 Future |
| **Unit & Widget Tests** — Comprehensive test coverage | 🔮 Future |

## 🤝 Contributing

Contributions are welcome! Open an issue or submit a PR.

## 📄 License

MIT
