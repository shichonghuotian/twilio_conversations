import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twilio_conversations_linq/twilio_conversations.dart';
import 'package:twilio_conversations_example/chat/widget/chat_list.dart';
import 'package:twilio_conversations_example/conversations/conversations_notifier.dart';
import 'package:twilio_conversations_example/conversations/conversations_page.dart';

import 'chat/mgr/chat_plugin_service.dart';
import 'messages/messages_page.dart';
// import 'package:twilio_conversations_linq_example/services/backend_service.dart';

// import 'models/twilio_chat_token_request.dart';

final chatMgr = ChatPluginService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  print("start app");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Twilio Conversations Example'),
          ),
          body: Home()



          // Center(
          //   child: Column(
          //     children: [
          //       // _buildUserIdField(),
          //       // _buildButtons(),
          //
          //
          //
          //     ],
          //   ),
          // ),
          ),
    );
  }



  Widget _buildButtons() {
    return ChangeNotifierProvider<ConversationsNotifier>(
      create: (_) => ConversationsNotifier(),
      child: Consumer<ConversationsNotifier>(
        builder: (BuildContext context, conversationsNotifier, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: conversationsNotifier.identityController,
                onChanged: conversationsNotifier.updateIdentity,
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.identity.isNotEmpty &&
                        !conversationsNotifier.isClientInitialized
                    ? () async {
                        // <Set your JWT token here>
                        // usr00
                        //       String? jwtToken = "eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU4NDY3MzExLCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMCIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg0NjM3NDQiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.BFnVROU1qlZYV2TcgJJiiGvcL8i3RF6IdC3zseFQoFI";
                        //usr01
                        String? jwtToken =
                            "eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU4NzM1NzEzLCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMSIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg3MzIxNjAiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.rxo8o4kzRKP5u3Ib_87ueuewpgIn2hISIk8edw8L6qA";
                        // jwtToken = (await BackendService.createToken(
                        //         TwilioChatTokenRequest(
                        //             identity: conversationsNotifier.identity)))
                        //     ?.token;

                        if (jwtToken == null) {
                          return;
                        }

                        if (jwtToken.isEmpty) {
                          _showInvalidJWTDialog(context);
                          return;
                        }
                        await conversationsNotifier.create(jwtToken: jwtToken);
                      }
                    : null,
                child: Text('Start Client'),
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.isClientInitialized
                    ? () async {
                        String? jwtToken;
                        // jwtToken = (await BackendService.createToken(
                        //         TwilioChatTokenRequest(
                        //             identity: conversationsNotifier.identity)))
                        //     ?.token; // <Set your JWT token here>

                        if (jwtToken == null) {
                          return;
                        }

                        if (jwtToken.isEmpty) {
                          _showInvalidJWTDialog(context);
                          return;
                        }
                        await conversationsNotifier.updateToken(
                            jwtToken: jwtToken);
                      }
                    : null,
                child: Text('Update Token'),
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.isClientInitialized
                    ? () async {
                        await conversationsNotifier.shutdown();
                      }
                    : null,
                child: Text('Shutdown Client'),
              ),
              ElevatedButton(
                onPressed: conversationsNotifier.isClientInitialized
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationsPage(
                              conversationsNotifier: conversationsNotifier,
                            ),
                          ),
                        )
                    : null,
                child: Text('See My Conversations'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showMessagePage(context);
                },
                child: Text('go my conversation (test02)'),
              ),
            ],
          );
        },
      ),
    );
  }

  void showMessagePage(BuildContext context) async {
    String? jwtToken =
        "eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2IiwiZXhwIjoxNjU4ODIyODI2LCJncmFudHMiOnsiaWRlbnRpdHkiOiJ1c3IwMSIsImNoYXQiOnsic2VydmljZV9zaWQiOiJJU2M3Mzg5MTgyNDc4NjQzZDBhOGE2MjU5ODI5NDNjNjYzIn19LCJqdGkiOiJTSzI4YWM4ZTE5NWVmMjBlZTc5OGQzZDA1YmNlN2QwMWU2LTE2NTg3MzY1MTIiLCJzdWIiOiJBQzgyN2Q0ZWJiZjgzZjYzNTkwNzQzMWU5MDk0MmI1YjQ0In0.CXVDxTVkNgsSuY7s1npj5i9hD49HdjwDl5rJ12Sf_sc";

    final plugin = TwilioConversations();
    ConversationClient? client;

    // if(TwilioConversations.conversationClient == null) {
    // }
    client = await plugin.create(jwtToken: jwtToken);

    if (client != null) {
      // CHaad65d36404044ac928a265355c573e3 - test07abc
      Conversation? conversation = await client.getConversation("test07abc");

      if (conversation != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesPage(
              conversation,
              client!,
            ),
          ),
        );
      }
      //   MessagesPage(
      //       conversation, widget.conversationsNotifier.client!),
      // )
    }
  }

  void _showInvalidJWTDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error: No JWT provided'),
        content: Text(
            'To create the conversations client, a JWT must be supplied on line 44 of `main.dart`'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

//总共有几步， 1，
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }

}

class HomeState extends State<Home> {

  var isLoading = true;

  @override
  initState() {
    super.initState();

    initClient();
  }

  initClient() async {

    await chatMgr.connect();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Center(child: CircularProgressIndicator());

    }
    return  Column(
      children: [

        ElevatedButton(
          onPressed:  () async {
            await chatMgr.connect();
          },
          child: Text('init Client'),
        ),
        ElevatedButton(
          onPressed:  ()  {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: ChatList(
                    conversationSidOrUniqueName: 'CH7f43d738a0924713ad94d7fb3675818c',
                    header: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 50,
                          color: Colors.white,
                          child: Text('header'),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            );
          },
          child: Text('start chat'),
        ),
      ],
    );
  }

}