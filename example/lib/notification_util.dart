
import '../../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';





initFirebase() async {

  print("init firebase");
  await Firebase.initializeApp(
    name: 'linq-pros',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("init firebase end");
  listenFcmForegroundMessaging();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  setupFcmToken();
  // initFlutterNP();
}

uploadFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("fcmtoken upload: $fcmToken");

  // await RequestRepository.getInstance().updateFcmToken(fcmToken);

}

setupFcmToken() async{

  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {

        print("fcmtoken update: $fcmToken");
  })
      .onError((err) {
    // Error getting token.
  });

  //这里不应该再次上传fcmtoken， 只有登陆的时候上传， 暂时注释
  // if(LoginUtil.isSignIn()) {
  //   uploadFcmToken();
  //
  // }


}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  print('Got a message whilst in the background!');
  print('background Message data: ${message.data}');

  if (message.notification != null) {
    print(' background Message also contained a notification: ${message
        .notification}, ${message.data}');

    // showNotification(message.data['conversation_title'],message.data['twi_body']);

  }

  if(message.data != null) {

  if(message.data['conversation_title'] != null) {
    // {conversation_sid: CH6a196d7055444b77910001e71197c28c,
// twi_message_id: RU7f6a3e3ca6eb51f6f21d5c29e8afb00c,
// message_index: 6, conversation_title: 191, author: 8,
// twi_body: 191;8: Ccc, message_sid: IMe587b0f6aebe4a57a7d191f2723402e0,
// twi_message_type: twilio.conversations.new_message}
      String? title = message.data['conversation_title'];
      String? sid = message.data['conversation_sid'];
      if(title == sid) {
        title = null;
      }


      // showNotification(title,message.data['twi_body']);
    }
  }


}


listenFcmForegroundMessaging() {

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {

      try{

      }catch(e) {

      }



    }

    //前台收到通知， 可以进行一些请求
  });

}