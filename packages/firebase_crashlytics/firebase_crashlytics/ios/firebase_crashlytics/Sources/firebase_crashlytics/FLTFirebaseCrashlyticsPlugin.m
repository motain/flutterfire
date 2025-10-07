// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// iOS No-Op Implementation
// This implementation does nothing to prevent conflicts with native iOS Firebase Crashlytics

#import "include/FLTFirebaseCrashlyticsPlugin.h"
#import "include/Crashlytics_Platform.h"
#import "include/ExceptionModel_Platform.h"

// NO Firebase Crashlytics imports - this is a no-op implementation for iOS

#if __has_include(<firebase_core/FLTFirebasePluginRegistry.h>)
#import <firebase_core/FLTFirebasePluginRegistry.h>
#else
#import <FLTFirebasePluginRegistry.h>
#endif

NSString *const kFLTFirebaseCrashlyticsChannelName = @"plugins.flutter.io/firebase_crashlytics";

// Argument Keys (kept for compatibility)
NSString *const kCrashlyticsArgumentException = @"exception";
NSString *const kCrashlyticsArgumentInformation = @"information";
NSString *const kCrashlyticsArgumentStackTraceElements = @"stackTraceElements";
NSString *const kCrashlyticsArgumentReason = @"reason";
NSString *const kCrashlyticsArgumentIdentifier = @"identifier";
NSString *const kCrashlyticsArgumentKey = @"key";
NSString *const kCrashlyticsArgumentValue = @"value";
NSString *const kCrashlyticsArgumentFatal = @"fatal";

NSString *const kCrashlyticsArgumentFile = @"file";
NSString *const kCrashlyticsArgumentLine = @"line";
NSString *const kCrashlyticsArgumentMethod = @"method";

NSString *const kCrashlyticsArgumentEnabled = @"enabled";
NSString *const kCrashlyticsArgumentUnsentReports = @"unsentReports";
NSString *const kCrashlyticsArgumentDidCrashOnPreviousExecution = @"didCrashOnPreviousExecution";

@implementation FLTFirebaseCrashlyticsPlugin

#pragma mark - FlutterPlugin

// Returns a singleton instance of the Firebase Crashlytics plugin.
+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static FLTFirebaseCrashlyticsPlugin *instance;

  dispatch_once(&onceToken, ^{
    instance = [[FLTFirebaseCrashlyticsPlugin alloc] init];
    // Register with the Flutter Firebase plugin registry.
    [[FLTFirebasePluginRegistry sharedInstance] registerFirebasePlugin:instance];

    // NO Firebase Crashlytics operations - this is a no-op implementation
    NSLog(@"Firebase Crashlytics Flutter plugin: iOS no-op implementation loaded. Use native iOS Crashlytics instead.");
  });

  return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:kFLTFirebaseCrashlyticsChannelName
                                  binaryMessenger:[registrar messenger]];
  FLTFirebaseCrashlyticsPlugin *instance = [FLTFirebaseCrashlyticsPlugin sharedInstance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)flutterResult {
  // All methods are no-op on iOS to prevent conflicts with native implementation

  if ([@"Crashlytics#recordError" isEqualToString:call.method]) {
    // No-op: iOS crashes should be handled by native iOS Crashlytics
    flutterResult(nil);
  } else if ([@"Crashlytics#setUserIdentifier" isEqualToString:call.method]) {
    // No-op: User identifier should be set via native iOS Crashlytics
    flutterResult(nil);
  } else if ([@"Crashlytics#setCustomKey" isEqualToString:call.method]) {
    // No-op: Custom keys should be set via native iOS Crashlytics
    flutterResult(nil);
  } else if ([@"Crashlytics#log" isEqualToString:call.method]) {
    // No-op: Logs should be sent via native iOS Crashlytics
    flutterResult(nil);
  } else if ([@"Crashlytics#crash" isEqualToString:call.method]) {
    // No-op: Test crashes should be triggered via native iOS Crashlytics
    NSLog(@"Firebase Crashlytics Flutter plugin: .crash() called but ignored on iOS (no-op implementation)");
    flutterResult(nil);
  } else if ([@"Crashlytics#setCrashlyticsCollectionEnabled" isEqualToString:call.method]) {
    // Return false to indicate collection is disabled on iOS Flutter side
    flutterResult(@{@"isCrashlyticsCollectionEnabled": @NO});
  } else if ([@"Crashlytics#checkForUnsentReports" isEqualToString:call.method]) {
    // Always return no unsent reports
    flutterResult(@{kCrashlyticsArgumentUnsentReports: @NO});
  } else if ([@"Crashlytics#sendUnsentReports" isEqualToString:call.method]) {
    // No-op: Reports should be sent via native iOS Crashlytics
    flutterResult(nil);
  } else if ([@"Crashlytics#deleteUnsentReports" isEqualToString:call.method]) {
    // No-op: Reports should be managed via native iOS Crashlytics
    flutterResult(nil);
  } else if ([@"Crashlytics#didCrashOnPreviousExecution" isEqualToString:call.method]) {
    // Always return false since we don't track crashes on Flutter iOS side
    flutterResult(@{kCrashlyticsArgumentDidCrashOnPreviousExecution: @NO});
  } else {
    flutterResult(FlutterMethodNotImplemented);
  }
}

#pragma mark - FLTFirebasePlugin

- (void)didReinitializeFirebaseCore:(void (^)(void))completion {
  // No-op: no reinitialization needed for no-op implementation
  completion();
}

- (NSDictionary *_Nonnull)pluginConstantsForFIRApp:(FIRApp *)firebaseApp {
  // Return empty constants
  return @{};
}

- (NSString *_Nonnull)firebaseLibraryName {
  return LIBRARY_NAME;
}

- (NSString *_Nonnull)firebaseLibraryVersion {
  return LIBRARY_VERSION;
}

- (NSString *_Nonnull)flutterChannelName {
  return kFLTFirebaseCrashlyticsChannelName;
}

@end