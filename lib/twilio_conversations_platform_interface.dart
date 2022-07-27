// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// import 'twilio_conversations_method_channel.dart';
//
// abstract class TwilioConversationsPlatform extends PlatformInterface {
//   /// Constructs a TwilioConversationsPlatform.
//   TwilioConversationsPlatform() : super(token: _token);
//
//   static final Object _token = Object();
//
//   static TwilioConversationsPlatform _instance = MethodChannelTwilioConversations();
//
//   /// The default instance of [TwilioConversationsPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelTwilioConversations].
//   static TwilioConversationsPlatform get instance => _instance;
//
//   /// Platform-specific implementations should set this with their own
//   /// platform-specific class that extends [TwilioConversationsPlatform] when
//   /// they register themselves.
//   static set instance(TwilioConversationsPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }
//
//   Future<String?> getPlatformVersion() {
//     throw UnimplementedError('platformVersion() has not been implemented.');
//   }
// }
