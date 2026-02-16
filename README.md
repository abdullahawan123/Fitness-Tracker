# FitTrack Pro - Production-Ready Fitness Tracker

FitTrack Pro is a premium, highly animated, and fully functional fitness tracking application built with Flutter using Clean Architecture principles.

## 🚀 Features

- **Live Activity Tracking**: Real-time step counting and GPS-based jogging/walking distance tracking.
- **Premium UI/UX**: Modern Glassmorphism design system with smooth micro-animations.
- **AI-Powered Insights**: Dynamic goal suggestions and fatigue detection based on user performance.
- **Health Integration**: Ready for Google Fit (Android) and Apple HealthKit (iOS).
- **Gamification**: Unlockable achievement badges and progress milestones.
- **Offline First**: Local data persistence using Hive.

## 🛠 Architecture

The project follows **Clean Architecture**:

- **Domain Layer**: Entities, Repository Interfaces, and Use Cases (AI logic).
- **Data Layer**: Models (Hive adapters), Repository Implementations, and Local Data Sources.
- **Presentation Layer**: BLoC for state management, Pages, and reusable Widgets.
- **Core**: Theme constants, DI setup, and global error handling.

## 📦 Tech Stack

- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it`
- **Local Storage**: `hive`
- **Sensors**: `pedometer`, `geolocator`, `health`
- **UI**: `google_fonts`, `fl_chart`, `glassmorphism`, `lottie`

## 🛠 Setup Instructions

1. **Get Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate Hive Adapters**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Android Configuration**:
   - Ensure `minSdkVersion` is 21 or higher in `android/app/build.gradle`.
   - Add required permissions to `AndroidManifest.xml` (Activity Recognition, Location, Sensors).

4. **iOS Configuration**:
   - Add HealthKit and Location descriptors to `ios/Runner/Info.plist`.

## 📈 Roadmap

- [ ] Firebase synchronization
- [ ] Social challenges with real friends
- [ ] Workout voice guidance
- [ ] Heart rate monitor integration (BLE)

---
Built with ❤️ by Antigravity
