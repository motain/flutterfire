require 'yaml'

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

# iOS No-Op Implementation - No Firebase SDK version needed
# All Firebase SDK version logic removed for no-op implementation
Pod::UI.puts "#{pubspec['name']}: iOS no-op implementation (no Firebase SDK dependencies)"

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = library_version
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.authors          = 'The Chromium Authors'
  s.source           = { :path => '.' }
  s.source_files     = 'firebase_core/Sources/firebase_core/**/*.{h,m}'
  s.public_header_files = 'firebase_core/Sources/firebase_core/include/**/*.h'

  s.ios.deployment_target = '15.0'

  # Flutter dependencies
  s.dependency 'Flutter'

  # NO Firebase dependencies - this is a no-op version to prevent conflicts with native iOS Firebase
  # s.dependency 'Firebase/CoreOnly', firebase_sdk_version  # Commented out to avoid conflicts

  s.static_framework = true
  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => "LIBRARY_VERSION=\\\"#{library_version}\\\" LIBRARY_NAME=\\\"flutter-fire-core\\\"",
    'DEFINES_MODULE' => 'YES'
  }
end
