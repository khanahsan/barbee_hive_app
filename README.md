# Project Title

Barbee Hive App

# Short Description

Flutter mobile app for connecting employers and employees through job posting, applications, messaging, profile management, and subscription workflows.

# Features

- Sign in and sign up for employer and employee roles
- Email/password, Google, and Apple authentication
- Create, manage, and update job postings
- Browse jobs and submit applications
- View applicants and applicant profiles
- Real-time chat and in-app messaging
- User profile management and resume support
- Push notifications with Firebase Cloud Messaging
- Subscription and pricing plan flows with in-app purchases
- Feedback/support and account settings screens

# Tech Stack

- Flutter
- Dart
- GetX (state management/navigation)
- HTTP API integration
- Firebase Core, Auth, Firestore, and Messaging
- Local storage with `shared_preferences`
- Stripe integration
- In-app purchases

# Folder Structure

```text
barbee_hive_app/
├── android/                 Native Android project files
├── ios/                     Native iOS project files
├── assets/                  Images, icons, fonts, gifs, and environment assets
├── lib/
│   ├── data/                API clients, Firebase services, and data models
│   ├── infrastructure/      App routing, bindings, constants, helpers, widgets, and utilities
│   ├── presentation/        UI screens, controllers, and feature modules
│   └── push_notifications/  Push notification setup and handling logic
├── test/                    Flutter test files
├── pubspec.yaml             Project dependencies and asset configuration
└── README.md                Project documentation
```

# Installation & Setup

```bash
git clone https://github.com/khanahsan/barbee_hive_app.git
cd barbee_hive_app
flutter pub get
flutter run
```

# Requirements

- Flutter SDK 3.35.6
- Dart SDK 3.7.2 or compatible with the Flutter SDK
