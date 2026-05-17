# AI Co-Founder

A structured startup execution app powered by AI. Not a chat app - a real tool to plan and execute your startup idea in 7 days.

## Core Flow

```
Idea Input → AI Plan → Start Execution → Daily Tasks → Complete Day → Next Day → Repeat
```

## Features

- **AI-Powered Planning**: Enter your startup idea, get a complete 7-day execution plan
- **Daily Task Execution**: Structured tasks for each day to keep you on track
- **Progress Tracking**: See your completion percentage, streak, and total tasks
- **Firebase Integration**: Anonymous auth, cloud storage for plans and progress
- **Clean Card UI**: Focused on execution, no distractions

## Tech Stack

- Flutter 3.x
- State Management: GetX
- Firebase: Auth (anonymous) + Firestore
- OpenAI API: GPT-4o-mini for plan generation

## Project Structure

```
lib/
├── main.dart                    # App entry point, routing, Firebase init
├── models/
│   └── plan_model.dart          # Plan data model
├── controllers/
│   └── plan_controller.dart     # GetX controller (state management)
├── services/
│   ├── ai_service.dart          # OpenAI API integration
│   └── firebase_service.dart    # Firebase auth + Firestore
└── screens/
    ├── splash_screen.dart       # Splash with auto-navigation
    ├── onboarding_screen.dart   # Name input
    ├── idea_input_screen.dart   # Startup idea input
    ├── plan_screen.dart         # Generated plan display
    ├── task_screen.dart         # Daily task execution (core screen)
    └── progress_screen.dart     # 7-day completion summary
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK 3.0+ ([Install Guide](https://docs.flutter.dev/get-started/install))
- Firebase account
- OpenAI API key ([Get one here](https://platform.openai.com/api-keys))

### 2. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (e.g., "ai-cofounder")
3. Enable **Authentication** → Sign-in method → **Anonymous** → Enable
4. Enable **Firestore Database** → Create database → Start in **test mode**
5. Add an Android app:
   - Package name: `com.aicofounder.app`
   - Download `google-services.json`
   - Replace the placeholder file at `android/app/google-services.json`
6. (Optional) Add an iOS app:
   - Bundle ID: `com.aicofounder.app`
   - Download `GoogleService-Info.plist`
   - Replace the placeholder file at `ios/Runner/GoogleService-Info.plist`

### 3. Firestore Security Rules

Replace the default rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /plans/{planId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. Configure OpenAI API Key

Run the app with your API key:

```bash
flutter run --dart-define=OPENAI_API_KEY=sk-your-key-here
```

Or edit the default in `lib/main.dart`:

```dart
const openaiApiKey = String.fromEnvironment(
  'OPENAI_API_KEY',
  defaultValue: 'sk-your-key-here',
);
```

### 5. Install Dependencies

```bash
cd ai_cofounder
flutter pub get
```

### 6. Run the App

```bash
# Android
flutter run --dart-define=OPENAI_API_KEY=sk-your-key-here

# iOS
flutter run --dart-define=OPENAI_API_KEY=sk-your-key-here -d <device-id>
```

### 7. Build for Release

```bash
# Android APK
flutter build apk --dart-define=OPENAI_API_KEY=sk-your-key-here

# Android App Bundle
flutter build appbundle --dart-define=OPENAI_API_KEY=sk-your-key-here

# iOS
flutter build ios --dart-define=OPENAI_API_KEY=sk-your-key-here
```

## Firebase Data Structure

```
users/{userId}
  - name: string
  - createdAt: timestamp

plans/{planId}
  - userId: string
  - idea: string
  - problem: string
  - audience: string
  - solution: string
  - features: array<string>
  - execution_steps: array<string>
  - daily_tasks: map { day1: [], day2: [], ..., day7: [] }
  - current_day: number
  - completed_tasks_count: number
  - completed_task_ids: array<string>
  - createdAt: string
```

## Screen Flow

```
Splash (2s) → Onboarding (name) → Idea Input → AI generates plan
    ↓
Plan Screen (review) → Task Screen (Day 1) → Mark Complete → Day 2 → ... → Day 7
    ↓
Progress Screen → Start New Idea
```

## Key Design Decisions

- **No chat UI**: This is an execution tool, not a conversation app
- **Anonymous auth**: Zero friction onboarding
- **7-day fixed plan**: Structured enough to complete, flexible enough for any idea
- **Card-based UI**: Clean, scannable, mobile-friendly
- **GetX state management**: Lightweight, no boilerplate, reactive UI

## License

MIT
