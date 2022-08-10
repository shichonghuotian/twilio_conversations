/*
* 主要是用来初始化clien
* */
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:http/http.dart' as http;


class ChatPluginService {
  factory ChatPluginService() {
    _instance ??= ChatPluginService._();
    return _instance!;
  }

  static ChatPluginService? _instance;

  ChatPluginService._();

  final plugin = TwilioConversations();


  // ConversationClient? get client => TwilioConversations.conversationClient;
  final subscriptions = <StreamSubscription>[];

  /*
  * 初始化, 要有个错误处理， 譬如token过期
  * */
  connect() async {
    print("ChatPluginManager init");

    if(TwilioConversations.conversationClient != null) {
      return;
    }

    try {
       plugin.create(jwtToken: getToken());

    } on PlatformException catch(e) {

      print("error code: ${e.code}" );
    }
    print("ChatPluginManager end");

    var client = TwilioConversations.conversationClient!;
    subscriptions.add(client.onTokenAboutToExpire.listen((message) {
      print("onTokenAboutToExpire ");

    }));
    subscriptions.add(client.onTokenExpired.listen((message) async {
      print("onTokenExpired ");

      // client.updateToken();
      var v = await getNewToken();

      print("newToken: $v");
      await client.updateToken(v);
      print("updateToken success");

    }));



    // TwilioConversations.conversationClient
    //
    // Conversation? conversation = await TwilioConversations.conversationClient?.getConversation("test07abc");
    //
    // print("cc = ${conversation?.friendlyName}");

  }

  Future<String> getNewToken() async {

    // var resp =  await http.get(Uri.parse('http://192.168.50'
    //     '.213:8080/api/login?identity=usr00&password=123'));

    return getToken();

  }

  String getToken() {
    // String jwtToken = "eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU4OTkwOTgxLCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMSIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg5MDQ3MDQiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.ooT0oss9QTuz3SxXY-VtmXXFPSqywLmkyD3PWHmgFSU";

    //usr 00
    // String jwtToken = 'eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU5MDIwMjEzLCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMCIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg5MzM4ODgiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.x_NDOxNfHYhLLpOVnTw0j-jcjgOFhyjLtAnPKqHoYgI';
    String jwtToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2I2NGUxZTJiNzE0NDViOWE3ZGRiMTlmY2ZmOTNiZDU2LTE2NjAxMjk0NjQiLCJncmFudHMiOnsiY2hhdCI6eyJzZXJ2aWNlX3NpZCI6IklTYWUzMDQzYjhmNTI0NGM3YmI0NmUxMGY4Y2U4ZDVkYWEifSwiaWRlbnRpdHkiOjl9LCJpc3MiOiJTS2I2NGUxZTJiNzE0NDViOWE3ZGRiMTlmY2ZmOTNiZDU2IiwiZXhwIjoxNjYwMjE1ODY0LCJuYmYiOjE2NjAxMjk0NjQsInN1YiI6IkFDOTk2MWYzMmVhODFmNWE2ZmZkNzA0YmFlODYyN2QzNzIifQ.gMkzCIdbHwaZ0-_nU9QfKkqvYk0tz9xUZTQHpH1I8d4';

    return jwtToken;
  }
}
