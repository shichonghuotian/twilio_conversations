import Flutter
import UIKit
import TwilioConversationsClient

public class SwiftTwilioConversationsLinqPlugin: NSObject, FlutterPlugin {
    let TAG = "SwiftTwilioConversationsLinqPlugin"

    public static var instance: SwiftTwilioConversationsLinqPlugin?

    // Flutter > Host APIs
    static let pluginApi: PluginMethods = PluginMethods()
    static let conversationClientApi: ConversationClientMethods = ConversationClientMethods()
    static let conversationApi: ConversationMethods = ConversationMethods()
    static let participantApi: ParticipantMethods = ParticipantMethods()
    static let messageApi: MessageMethods = MessageMethods()
    static let userApi: UserMethods = UserMethods()

    // Host > Flutter APIs
    static var flutterClientApi: TWCONFlutterConversationClientApi?
    static var flutterLoggingApi: TWCONFlutterLoggingApi?

    public var client: TwilioConversationsClient?

    public static var clientListener: ClientListener?
    public static var conversationListeners: [String: ConversationListener] = [:]

    public static var messenger: FlutterBinaryMessenger?

    public static var reasonForTokenRetrieval: String?

    public static var nativeDebug = false

    public static func debug(_ msg: String) {
        if SwiftTwilioConversationsLinqPlugin.nativeDebug {
            NSLog(msg)
            guard let loggingApi = SwiftTwilioConversationsLinqPlugin.flutterLoggingApi else {
                return
            }
            loggingApi.log(fromHostMsg: msg) { (error: Error?) in
                if let error = error {
                    NSLog("Exception when using FlutterLoggingApi: \(String(describing: error))")
                }
            }
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance = SwiftTwilioConversationsLinqPlugin()
        instance?.onRegister(registrar)
    }

    public func onRegister(_ registrar: FlutterPluginRegistrar) {
        SwiftTwilioConversationsLinqPlugin.messenger = registrar.messenger()

        SwiftTwilioConversationsLinqPlugin.flutterClientApi =
            TWCONFlutterConversationClientApi(binaryMessenger: registrar.messenger())
        SwiftTwilioConversationsLinqPlugin.flutterLoggingApi =
            TWCONFlutterLoggingApi(binaryMessenger: registrar.messenger())

        TWCONPluginApiSetup(registrar.messenger(), SwiftTwilioConversationsLinqPlugin.pluginApi)
        TWCONConversationClientApiSetup(registrar.messenger(), SwiftTwilioConversationsLinqPlugin.conversationClientApi)
        TWCONConversationApiSetup(registrar.messenger(), SwiftTwilioConversationsLinqPlugin.conversationApi)
        TWCONParticipantApiSetup(registrar.messenger(), SwiftTwilioConversationsLinqPlugin.participantApi)
        TWCONMessageApiSetup(registrar.messenger(), SwiftTwilioConversationsLinqPlugin.messageApi)
        TWCONUserApiSetup(registrar.messenger(), SwiftTwilioConversationsLinqPlugin.userApi)

        registrar.addApplicationDelegate(self)
    }

    // swiftlint:disable function_body_length cyclomatic_complexity
    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debug("didRegisterForRemoteNotificationsWithDeviceToken => onSuccess: \((deviceToken as NSData).description)")
        if let reason = SwiftTwilioConversationsLinqPlugin.reasonForTokenRetrieval {
            if reason == "register" {
                client?.register(withNotificationToken: deviceToken, completion: { (result: TCHResult) in
                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                               + "registered for notifications: \(result.isSuccessful)")
                    if result.isSuccessful {
                        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.registered(
                            completion: { (error: Error?) in
                                if let errorMessage = error {
                                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                                            + "Error calling FlutterClientApi: \(errorMessage)")
                                }
                        })
                    } else if let error = result.error {
                        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.registrationFailedErrorInfoData(
                            Mapper.errorToPigeon(error), completion: { (error: Error?) in
                                if let errorMessage = error {
                                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                                            + "Error calling FlutterClientApi: \(errorMessage)")
                                }
                        })
                    } else {
                        let error = TWCONErrorInfoData()
                        error.code = 0
                        error.message = "Unknown error during registration."
                        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.registrationFailedErrorInfoData(
                            error, completion: { (error: Error?) in
                                if let errorMessage = error {
                                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                                            + "Error calling FlutterClientApi: \(errorMessage)")
                                }
                        })
                    }
                })
            } else {
                client?.deregister(withNotificationToken: deviceToken, completion: { (result: TCHResult) in
                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                          + "deregistered for notifications: \(result.isSuccessful)")
                    if result.isSuccessful {
                        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.deregistered(completion: { (error: Error?) in
                            if let errorMessage = error {
                                self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                                        + "Error calling FlutterClientApi: \(errorMessage)")
                            }
                        })
                    } else if let error = result.error {
                        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.deregistrationFailedErrorInfoData(
                            Mapper.errorToPigeon(error), completion: { (error: Error?) in
                                if let errorMessage = error {
                                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                                            + "Error calling FlutterClientApi: \(errorMessage)")
                                }
                        })
                    } else {
                        let error = TWCONErrorInfoData()
                        error.code = 0
                        error.message = "Unknown error during deregistration."
                        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.deregistrationFailedErrorInfoData(
                            error, completion: { (error: Error?) in
                                if let errorMessage = error {
                                    self.debug("didRegisterForRemoteNotificationsWithDeviceToken => "
                                            + "Error calling FlutterClientApi: \(errorMessage)")
                                }
                        })
                    }
                })
            }
        }
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError
        error: Error) {
        debug("didFailToRegisterForRemoteNotificationsWithError => onError: \(error)")
        let error = error as NSError
        let exception = TWCONErrorInfoData()
        exception.code = NSNumber(value: error.code)
        exception.message = error.localizedDescription
        SwiftTwilioConversationsLinqPlugin.flutterClientApi?.registrationFailedErrorInfoData(
            exception, completion: { (error: Error?) in
                if let errorMessage = error {
                    self.debug("didFailToRegisterForRemoteNotificationsWithError => "
                        + "Error calling FlutterClientApi: \(errorMessage)")
                }
        })
    }

    private func debug(_ msg: String) {
        SwiftTwilioConversationsLinqPlugin.debug("\(TAG)::\(msg)")
    }
}
