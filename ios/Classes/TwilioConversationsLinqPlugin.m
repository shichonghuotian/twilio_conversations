#import "TwilioConversationsLinqPlugin.h"
#if __has_include(<twilio_conversations_linq/twilio_conversations_linq-Swift.h>)
#import <twilio_conversations_linq/twilio_conversations_linq-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "twilio_conversations_linq-Swift.h"
//#import "twilio_conversations-Swift.h"
#endif

@implementation TwilioConversationsLinqPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftTwilioConversationsLinqPlugin registerWithRegistrar:registrar];
}
@end
