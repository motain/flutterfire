// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// iOS No-Op Implementation
// This implementation does nothing to prevent conflicts with native iOS Firebase

#if __has_include("include/firebase_core/FLTFirebaseCorePlugin.h")
#import "include/firebase_core/FLTFirebaseCorePlugin.h"
#else
#import "include/FLTFirebaseCorePlugin.h"
#endif

#if __has_include("include/firebase_core/FLTFirebasePluginRegistry.h")
#import "include/firebase_core/FLTFirebasePluginRegistry.h"
#else
#import "include/FLTFirebasePluginRegistry.h"
#endif

#if __has_include("include/firebase_core/messages.g.h")
#import "include/firebase_core/messages.g.h"
#else
#import "include/messages.g.h"
#endif

// NO Firebase imports - this is a no-op implementation for iOS

@implementation FLTFirebaseCorePlugin {
  BOOL _coreInitialized;
}

#pragma mark - FlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FLTFirebaseCorePlugin *sharedInstance = [self sharedInstance];
#if TARGET_OS_OSX
#else
  [registrar publish:sharedInstance];
#endif
  SetUpFirebaseCoreHostApi(registrar.messenger, sharedInstance);
  SetUpFirebaseAppHostApi(registrar.messenger, sharedInstance);
}

// Returns a singleton instance of the Firebase Core plugin.
+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static FLTFirebaseCorePlugin *instance;

  dispatch_once(&onceToken, ^{
    instance = [[FLTFirebaseCorePlugin alloc] init];
    // Register with the Flutter Firebase plugin registry.
    [[FLTFirebasePluginRegistry sharedInstance] registerFirebasePlugin:instance];

    // NO Firebase initialization - this is a no-op implementation
    NSLog(@"Firebase Core Flutter plugin: iOS no-op implementation loaded. Use native iOS Firebase Core instead.");
  });

  return instance;
}

static NSMutableDictionary<NSString *, NSString *> *customAuthDomains;

// Initialize static properties

+ (void)initialize {
  if (self == [FLTFirebaseCorePlugin self]) {
    customAuthDomains = [[NSMutableDictionary alloc] init];
  }
}

+ (NSString *)getCustomDomain:(NSString *)appName {
  return customAuthDomains[appName];
}

#pragma mark - Helpers

- (CoreFirebaseOptions *)createMockFirebaseOptions {
  // Create mock options for no-op implementation using factory method
  // Using empty strings for required fields and nil for optional fields
  return [CoreFirebaseOptions makeWithApiKey:@""
                                       appId:@""
                           messagingSenderId:@""
                                   projectId:@""
                                  authDomain:nil
                                 databaseURL:nil
                               storageBucket:nil
                               measurementId:nil
                                  trackingId:nil
                           deepLinkURLScheme:nil
                             androidClientId:nil
                                 iosClientId:nil
                                 iosBundleId:[[NSBundle mainBundle] bundleIdentifier]
                                  appGroupId:nil];
}

- (CoreInitializeResponse *)createMockInitializeResponseForAppName:(NSString *)appName {
  // Create mock response for no-op implementation using factory method
  CoreFirebaseOptions *mockOptions = [self createMockFirebaseOptions];
  return [CoreInitializeResponse makeWithName:(appName ?: @"[DEFAULT]")
                                      options:mockOptions
             isAutomaticDataCollectionEnabled:@(NO)
                              pluginConstants:@{}];
}

#pragma mark - Firebase Core Host API

// No-op implementation - returns array with mock initialized state
- (void)initializeCoreWithCompletion:(void (^)(NSArray<CoreInitializeResponse *> *_Nullable,
                                                FlutterError *_Nullable))completion {
  // Create a mock response indicating the core is initialized
  // Note: Returns an array as per the protocol definition
  CoreInitializeResponse *response = [self createMockInitializeResponseForAppName:@"[DEFAULT]"];
  completion(@[response], nil);
}

// No-op implementation - returns mock app information
- (void)initializeAppAppName:(NSString *)appName
        initializeAppRequest:(CoreFirebaseOptions *)initializeAppRequest
                  completion:(void (^)(CoreInitializeResponse *_Nullable,
                                       FlutterError *_Nullable))completion {
  // Create a mock response for the app (no-op: ignores initializeAppRequest)
  CoreInitializeResponse *response = [self createMockInitializeResponseForAppName:appName];
  completion(response, nil);
}

// No-op implementation - returns mock options response
- (void)optionsFromResourceWithCompletion:
    (void (^)(CoreFirebaseOptions *_Nullable, FlutterError *_Nullable))completion {
  // Return mock options
  CoreFirebaseOptions *options = [self createMockFirebaseOptions];
  completion(options, nil);
}

#pragma mark - Firebase App Host API

// No-op implementation - does nothing
- (void)deleteAppName:(NSString *)appName
           completion:(void (^)(FlutterError *_Nullable))completion {
  // Just return success (nil error)
  completion(nil);
}

// No-op implementation - does nothing
- (void)setAutomaticDataCollectionEnabledAppName:(NSString *)appName
                                          enabled:(BOOL)enabled
                                       completion:(void (^)(FlutterError *_Nullable))completion {
  // Just return success (nil error)
  completion(nil);
}

// No-op implementation - does nothing
- (void)setAutomaticResourceManagementEnabledAppName:(NSString *)appName
                                              enabled:(BOOL)enabled
                                           completion:(void (^)(FlutterError *_Nullable))completion {
  // Just return success (nil error)
  completion(nil);
}

#pragma mark - FLTFirebasePlugin

- (void)didReinitializeFirebaseCore:(void (^)(void))completion {
  // No-op: no reinitialization needed
  completion();
}

- (NSDictionary *_Nonnull)pluginConstantsForFIRApp:(FIRApp *)firebaseApp {
  // Return empty constants
  return @{};
}

- (NSString *_Nonnull)firebaseLibraryName {
  return @LIBRARY_NAME;
}

- (NSString *_Nonnull)firebaseLibraryVersion {
  return @LIBRARY_VERSION;
}

- (NSString *_Nonnull)flutterChannelName {
  return @"plugins.flutter.io/firebase_core";
}

@end