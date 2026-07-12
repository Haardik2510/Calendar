# Cozy Planner - Build Instructions

## Requirements
* Flutter SDK (Target: `^3.12.2`, recommended to use latest 3.x)
* Android SDK & NDK for Android build
* Visual Studio with C++ desktop workload and **Windows Developer Mode** enabled for Windows build

## Android Build (APK)
To build the release APK for Android, open PowerShell or Terminal in the project root and run:
```powershell
flutter build apk --release --no-tree-shake-icons
```
You can find the generated APK output at `build/app/outputs/flutter-apk/app-release.apk`. 

*Note: The `--no-tree-shake-icons` flag is required because the app dynamically creates icons using runtime `IconData` constructors for the habits and events modules.*

## Windows Desktop Build (.exe)
To build the Windows executable:
1. Ensure **Developer Mode** is enabled in your Windows Settings (Search for "Developer Mode" in start menu). This is required because building Flutter Windows plugins requires creating symlinks during the build process, which non-admin users can only do if Developer Mode is enabled.
2. Run the build command:
```powershell
flutter build windows --release --no-tree-shake-icons
```
You can find the final `.exe` and associated files inside `build/windows/x64/runner/Release/`.

## Static Analysis
To ensure no code errors or warnings appear at compile time, run:
```powershell
flutter analyze --no-pub
```
