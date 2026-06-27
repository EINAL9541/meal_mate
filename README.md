# Meal Mate

Meal Mate is a modern Flutter application built with a clean and scalable architecture, using Riverpod for state management and Firebase as the backend. The app is organized using a feature-first structure to keep the codebase maintainable, modular, and easy to grow.

## Overview

Meal Mate is designed to provide a smooth and efficient experience for users interacting with meals, orders, authentication, and profile management. The project follows modern mobile development practices to ensure separation of concerns, testability, and faster delivery.

## Architecture

This project is structured around:

- Clean Architecture
  - Clear separation between presentation, domain, and data layers
  - Easier maintenance and future scaling
- Riverpod
  - Powerful and flexible state management
  - Simple dependency injection and reactive UI updates
- Feature-First Architecture
  - Related files are grouped by feature such as auth, home, cart, orders, profile, and admin
  - Improves readability and makes feature development more focused

## Tech Stack

- Flutter
- Dart
- Riverpod / Hooks Riverpod
- Firebase Authentication
- Cloud Firestore
- Go Router
- Dio
- Flutter ScreenUtil
- Toastification

## Project Structure

The project follows a feature-first structure with a shared core layer for reusable utilities and infrastructure.

```text
lib/
  main.dart

  core/
    routing/
    theme/
    widgets/
    network/
    error/

  features/
    auth/
      data/
      domain/
      presentation/
    home/
      data/
      domain/
      presentation/
    cart/
      data/
      domain/
      presentation/
    orders/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
    admin/
      data/
      domain/
      presentation/
```

### Structure Explanation

- core/: Shared app-wide components such as routing, theme, reusable widgets, networking, and error handling.
- features/: Each feature is organized independently with its own data, domain, and presentation layers.
- data/: Repositories, models, and remote/local data sources.
- domain/: Business logic, entities, and use cases.
- presentation/: Screens, controllers, providers, and UI components.

## Key Features

- User authentication with Firebase
- Feature-based screens and logic for home, cart, orders, profile, and admin
- Clean separation of UI, business logic, and data access
- Scalable structure for adding new features

## Why Firebase?

Firebase is used as the backend because it helps speed up development significantly.

Benefits of using Firebase in this project include:

- Fast setup for authentication
- Real-time and cloud-based data storage with Firestore
- Reduced backend development time
- Easy integration with Flutter apps
- Secure and scalable backend services
- Faster iteration during development and testing

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Dart SDK
- Android Studio or Xcode depending on your target platform
- Firebase account

### Installation

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd meal_mate
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

### Firebase Setup

1. Create a Firebase project
2. Add your Android and iOS apps to Firebase
3. Download and place the required configuration files:
   - google-services.json for Android
   - GoogleService-Info.plist for iOS
4. Enable Firebase Authentication and Firestore

## Notes

This project is built with maintainability and scalability in mind. The combination of clean architecture, Riverpod, and Firebase provides a strong foundation for building a modern mobile application efficiently.
