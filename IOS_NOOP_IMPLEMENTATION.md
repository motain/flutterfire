# iOS No-Op Implementation for FlutterFire

This fork of FlutterFire has been modified to provide no-op (no operation) implementations for iOS while maintaining full functionality for Android. This allows the Flutter app to avoid conflicts with native iOS Firebase SDK implementations.

## What has been changed

### 1. Firebase Core iOS Changes

#### Podspec (`packages/firebase_core/firebase_core/ios/firebase_core.podspec`)
- Removed Firebase/CoreOnly SDK dependency
- Kept Flutter dependency for plugin registration

#### Implementation (`FLTFirebaseCorePlugin.m`)
- Removed all Firebase SDK imports
- Created mock responses for all Firebase initialization calls
- Maintains plugin registration to prevent runtime errors
- Returns empty/mock data for all Firebase Core operations

### 2. Firebase Crashlytics iOS Changes

#### Podspec (`packages/firebase_crashlytics/firebase_crashlytics/ios/firebase_crashlytics.podspec`)
- Removed Firebase/Crashlytics SDK dependency
- Removed upload-symbols script execution
- Kept Flutter and firebase_core dependencies

#### Implementation (`FLTFirebaseCrashlyticsPlugin.m`)
- Removed all Firebase Crashlytics SDK imports
- All methods return success without performing any operations
- Status queries return false/empty responses
- Crash reports are only sent from Android

### 3. Dependency Updates

All pubspec.yaml files have been updated to use path references to this fork:
- `firebase_core/firebase_core/pubspec.yaml` - Uses local path references
- `firebase_core/firebase_core_web/pubspec.yaml` - Uses local path references
- `firebase_crashlytics/firebase_crashlytics/pubspec.yaml` - Uses local path references
- `firebase_crashlytics/firebase_crashlytics_platform_interface/pubspec.yaml` - Uses local path references
- `_flutterfire_internals/pubspec.yaml` - Uses local path references
- Example apps use path references to their parent packages

This ensures all transitive dependencies are resolved from the fork rather than pub.dev, preventing version conflicts.

## How it works

1. **Flutter Side**: The Flutter app continues to call Firebase methods normally
2. **iOS Side**: All calls are handled by no-op implementations that:
   - Return success responses without doing anything
   - Prevent crashes by maintaining proper method signatures
   - Log that the no-op implementation is being used
3. **Android Side**: Works normally with full Firebase functionality
4. **Native iOS**: Can use its own Firebase SDK without conflicts

## Important Notes

- **iOS Crashes**: Will NOT be tracked through Flutter - use native iOS Crashlytics
- **Android Crashes**: ARE tracked normally through Flutter Crashlytics
- **Plugin Registration**: iOS plugins remain registered to prevent runtime errors
- **Compatibility**: This fork maintains API compatibility with regular FlutterFire

## Usage

1. Clone this fork to your local machine
2. In your Flutter app's pubspec.yaml, reference the local fork:

```yaml
dependencies:
  firebase_core:
    path: /path/to/flutterfire/packages/firebase_core/firebase_core
  firebase_crashlytics:
    path: /path/to/flutterfire/packages/firebase_crashlytics/firebase_crashlytics
```

3. Run `flutter pub get`
4. For iOS, ensure your native iOS app has its own Firebase configuration
5. For Android, Flutter Firebase will work normally

## Verification

You can verify the no-op implementation is working by:
1. Building and running on iOS
2. Checking Xcode console for log messages: "Firebase [Core/Crashlytics] Flutter plugin: iOS no-op implementation loaded"
3. Confirming no duplicate symbol errors or Firebase conflicts
4. Testing that Android still reports crashes correctly