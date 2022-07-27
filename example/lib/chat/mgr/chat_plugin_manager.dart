/*
* 主要是用来初始化clien
* */
import 'package:twilio_conversations/twilio_conversations.dart';

class ChatPluginManager {
  factory ChatPluginManager() {
    _instance ??= ChatPluginManager._();
    return _instance!;
  }

  static ChatPluginManager? _instance;

  ChatPluginManager._();

  final plugin = TwilioConversations();


  // ConversationClient? get client => TwilioConversations.conversationClient;

  /*
  * 初始化
  * */
  init() async {
    print("ChatPluginManager init");

    if(TwilioConversations.conversationClient != null) {
      return;
    }

    await plugin.create(jwtToken: getToken());
    print("ChatPluginManager end");
    //
    // Conversation? conversation = await TwilioConversations.conversationClient?.getConversation("test07abc");
    //
    // print("cc = ${conversation?.friendlyName}");

  }

  String getToken() {
    // String jwtToken = "eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU4OTkwOTgxLCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMSIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg5MDQ3MDQiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.ooT0oss9QTuz3SxXY-VtmXXFPSqywLmkyD3PWHmgFSU";

    //usr 00
    String jwtToken = 'eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU5MDIwMjEzLCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMCIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg5MzM4ODgiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.x_NDOxNfHYhLLpOVnTw0j-jcjgOFhyjLtAnPKqHoYgI';

    return jwtToken;
  }
}
