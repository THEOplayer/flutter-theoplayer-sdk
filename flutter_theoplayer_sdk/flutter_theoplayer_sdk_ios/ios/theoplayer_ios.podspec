#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint theoplayer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'theoplayer_ios'
  s.version          = '1.0.3'
  s.summary          = 'THEOplayer Flutter iOS SDK'
  s.description      = <<-DESC
THEOplayer Flutter iOS SDK
                       DESC
  s.homepage         = 'https://theoplayer.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'THEO Technologies' => 'support@theoplayer.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'

  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'THEOplayerSDK-core', '10.3.0'
  s.dependency 'THEOplayer-Integration-THEOlive', '10.3.0'

end
