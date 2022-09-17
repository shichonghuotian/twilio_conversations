#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint twilio_conversations.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'twilio_conversations_linq'
  s.version          = '0.0.7'
  s.summary          = 'twilio conversations flutter sdk'
  s.description      = <<-DESC
twilio conversations flutter sdk
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TwilioConversationsClient', '~> 2.2'
  s.dependency 'SwiftyJSON', '~> 5.0.1'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
