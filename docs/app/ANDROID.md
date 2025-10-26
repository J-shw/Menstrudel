# Android App Guide

This guide covers the basic commands for building and running the Android version of the app.

## Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
-   [Android Studio](https://developer.android.com/studio) installed and up-to-date.
-   Android SDK and build tools (these are typically installed via Android Studio).

---

## 1. Install Dependencies

Android dependencies are managed by **Gradle**.

The `flutter pub get` command (which you run after editing `pubspec.yaml`) handles most of the work by telling Gradle which dependencies to fetch.

---

## 2. Open in Android Studio

To change native settings (like app icon, `build.gradle` versions, or `AndroidManifest.xml` permissions), you must open the project's Android module in Android Studio.

1.  Open Android Studio.
2.  Select **File > Open** (or "Open" from the welcome screen).
3.  Navigate to your project's `/app` folder.
4.  Select the **`android`** folder inside it and click "Open".

---

## 3. Run the App

This is the main command you will use for development. It builds, installs, and launches the app on your connected device or emulator with "hot reload" enabled.

Make sure an emulator is running or a physical device is connected.

From the `/app` terminal, run:

```sh
flutter run
```