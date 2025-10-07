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

- (CoreFirebaseOptions *)optionsFromFIROptions:(NSDictionary *)options {
  // Create mock options for no-op implementation
  CoreFirebaseOptions *pigeonOptions = [CoreFirebaseOptions alloc];
  pigeonOptions.apiKey = [NSNull null];
  pigeonOptions.appId = [NSNull null];
  pigeonOptions.messagingSenderId = [NSNull null];
  pigeonOptions.projectId = [NSNull null];
  pigeonOptions.databaseURL = [NSNull null];
  pigeonOptions.storageBucket = [NSNull null];
  pigeonOptions.deepLinkURLScheme = [NSNull null];
  pigeonOptions.iosBundleId = [[NSBundle mainBundle] bundleIdentifier] ?: [NSNull null];
  pigeonOptions.iosClientId = [NSNull null];
  pigeonOptions.appGroupId = [NSNull null];
  return pigeonOptions;
}

- (CoreInitializeResponse *)initializeResponseFromAppName:(NSString *)appName {
  CoreInitializeResponse *response = [CoreInitializeResponse alloc];
  response.name = appName ?: @"[DEFAULT]";
  response.isAutomaticDataCollectionEnabled = @(NO);
  response.options = [self optionsFromFIROptions:@{}];
  response.pluginConstants = @{};
  return response;
}

#pragma mark - Firebase Core Host API

// No-op implementation - returns mock initialized state
- (void)initializeCoreWithCompletion:(void (^)(CoreInitializeResponse *_Nullable,
                                                FlutterError *_Nullable))completion {
  // Create a mock response indicating the core is initialized
  CoreInitializeResponse *response = [self initializeResponseFromAppName:@"[DEFAULT]"];
  completion(response, nil);
}

// No-op implementation - returns mock app information
- (void)initializeAppAppName:(NSString *)appName
           initializeAppRequest:(CoreInitializeRequest *)request
                      completion:(void (^)(CoreInitializeResponse *_Nullable,
                                           FlutterError *_Nullable))completion {
  // Create a mock response for the app
  CoreInitializeResponse *response = [self initializeResponseFromAppName:appName];
  if (request.options) {
    response.options = request.options;
  }
  completion(response, nil);
}

// No-op implementation - returns empty options response
- (void)optionsFromResourceWithCompletion:
    (void (^)(CoreFirebaseOptions *_Nullable, FlutterError *_Nullable))completion {
  // Return mock options
  CoreFirebaseOptions *options = [self optionsFromFIROptions:@{}];
  completion(options, nil);
}

#pragma mark - Firebase App Host API

// No-op implementation - does nothing
- (void)deleteAppApp:(NSString *)appName
          completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion {
  // Just return success
  completion(@(YES), nil);
}

// No-op implementation - does nothing
- (void)setAutomaticDataCollectionEnabledAppName:(NSString *)appName
                                          enabled:(NSNumber *)enabled
                                       completion:(void (^)(NSNumber *_Nullable,
                                                             FlutterError *_Nullable))completion {
  // Just return success
  completion(@(YES), nil);
}

// No-op implementation - does nothing
- (void)setAutomaticResourceManagementEnabledAppName:(NSString *)appName
                                              enabled:(NSNumber *)enabled
                                           completion:
                                               (void (^)(NSNumber *_Nullable,
                                                         FlutterError *_Nullable))completion {
  // Just return success
  completion(@(YES), nil);
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
  return LIBRARY_NAME;
}

- (NSString *_Nonnull)firebaseLibraryVersion {
  return LIBRARY_VERSION;
}

- (NSString *_Nonnull)flutterChannelName {
  return @"plugins.flutter.io/firebase_core";
}

@end