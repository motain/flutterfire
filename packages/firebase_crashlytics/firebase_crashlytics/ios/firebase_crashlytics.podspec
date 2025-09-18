# iOS Crashlytics plugin has been disabled to avoid conflicts with native iOS Firebase Crashlytics
# This package only supports Android - iOS crashlytics should be handled natively in the iOS app

require 'yaml'

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = library_version
  s.summary          = pubspec['description'] + " (iOS No-Op version)"
  s.description      = pubspec['description'] + " - iOS functionality disabled to prevent conflicts"
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.authors          = 'The Chromium Authors'
  s.source           = { :path => '.' }

  # Minimal source files - just headers for compilation
  s.source_files     = 'firebase_crashlytics/Sources/firebase_crashlytics/include/*.h'
  s.public_header_files = 'firebase_crashlytics/Sources/firebase_crashlytics/include/*.h'

  s.ios.deployment_target = '15.0'

  s.dependency 'Flutter'
  # NO Firebase dependencies - this prevents conflicts with native iOS implementation

  s.static_framework = true
  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => "LIBRARY_VERSION=\\\"#{library_version}\\\" LIBRARY_NAME=\\\"flutter-fire-cls\\\" IOS_NOOP=1",
    'DEFINES_MODULE' => 'YES'
  }
end
