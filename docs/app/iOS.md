# iOS App Guide

This guide covers the basic commands for building and running the iOS version of the app.

All commands assume you are running them from within the `/app` directory.

## Prerequisites

-   A macOS computer.
-   [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
-   [Xcode](https://apps.apple.com/us/app/xcode/id497799835) installed and up-to-date.
-   [CocoaPods](https://cocoapods.org/) installed. Run `sudo gem install cocoapods` if you don't have it.

---

## 1. Install iOS Dependencies

Before building, or after any native plugin is added/updated, you must install the iOS dependencies using CocoaPods.

1. Get the flutter packages
    ```sh
    flutter pub get
    ```

1.  Navigate to the `ios` directory:
    ```sh
    cd ios
    ```

2.  Run the pod installer:
    ```sh
    pod install
    ```

---

## 2. Open in Xcode

To change native settings (like app icon, bundle ID, or signing certificates), you must open the project in Xcode.

**Important:** Always open the `.xcworkspace` file, not the `.xcodeproj` file.

From the `/app` directory, run:
```sh
open ios/Runner.xcworkspace
```

## 3. Build the App (IPA)

To create a release build (`.ipa` file) for uploading to TestFlight or the App Store, run the following command from the `/app` directory:

```sh
flutter build ipa
```

The output file will be located in the `app/build/ios/archive/` folder.