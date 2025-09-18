# Firebase Crashlytics iOS No-Op Implementation

This fork of Firebase Crashlytics has been modified to prevent conflicts with native iOS Firebase Crashlytics implementations.

## Changes Made

### 1. Removed iOS Platform Support
- Removed iOS and macOS from `pubspec.yaml` plugin platforms
- Only Android platform is supported by this fork

### 2. Modified iOS CocoaPods Specification
- Removed all Firebase dependencies from `firebase_crashlytics.podspec`
- Removed native Firebase SDK dependencies to prevent conflicts
- Added compile-time flag `IOS_NOOP=1` for identification

### 3. iOS Native Implementation Made No-Op
- All iOS native methods now return immediately without performing any Firebase operations
- Added logging to indicate when the no-op implementation is being used
- Maintained method signatures for compatibility

### 4. Dart-Level Platform Checks
- Added platform checks in main Dart methods (`recordError`, `log`, `setUserIdentifier`, `setCustomKey`)
- iOS calls return immediately without delegating to native implementation
- Added developer warnings in debug mode when iOS methods are called

## Usage

### In Flutter pubspec.yaml:
```yaml
dependencies:
  firebase_crashlytics:
    git:
      url: https://github.com/motain/flutterfire.git
      path: packages/firebase_crashlytics/firebase_crashlytics
      ref: main  # or your specific branch
```

### Behavior by Platform:

#### Android
- Full Firebase Crashlytics functionality
- All methods work as expected
- Reports crashes and errors to Firebase Console

#### iOS
- **All methods are no-op**
- No Firebase dependencies included
- No conflicts with native iOS Firebase Crashlytics
- Developer warnings in debug builds

## Recommended Architecture

1. **Android**: Use this Flutter plugin for crash reporting
2. **iOS**: Use native iOS Firebase Crashlytics implementation in your native iOS code
3. **Cross-platform**: Handle platform-specific crash reporting logic in your app

## Why This Approach?

This approach solves the common issue where having both Flutter Firebase Crashlytics and native iOS Firebase Crashlytics causes duplicate symbols and build conflicts. By making the Flutter version a no-op on iOS, you can:

- Use Flutter Crashlytics on Android without issues
- Use native iOS Crashlytics on iOS without conflicts
- Avoid duplicate Firebase dependencies
- Maintain a single codebase with platform-specific behavior

## Testing

The plugin will compile and run on both platforms, but iOS functionality is intentionally disabled. Monitor your Firebase Console to ensure crash reports are being received from the appropriate platform-specific implementations.