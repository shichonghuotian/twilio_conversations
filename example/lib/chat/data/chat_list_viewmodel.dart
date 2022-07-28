
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilio_conversations_example/chat/data/message_item_data.dart';

class ChatListViewModel extends ChangeNotifier {

  final String conversationSidOrUniqueName;
  late Conversation conversation;

  bool isLoading = true;
  bool isSendingMessage = false;
  bool isError = false;

  final limit = 20;
  List<Message> messages = [];
  List<MessageItemData> chatMessages = [];

  final subscriptions = <StreamSubscription>[];



  ChatListViewModel(this.conversationSidOrUniqueName);

  /*
  * 初始化
  * */
  init() async {
    // Conversation is not yet initialized， 有个bug需要解决
    Conversation? conversation = await TwilioConversations
        .conversationClient?.getConversation(conversationSidOrUniqueName);

    if(conversation != null ) {

      this.conversation = conversation;
      loadSubscriptions();

      loadConversation();
    }
  }

  loadSubscriptions() {
    print(conversation.onMessageAdded);
    subscriptions.add(conversation.onMessageAdded.listen((message) async {
      // messages.insert(0, message);

      //
      // if (message.type == MessageType.MEDIA) {
      //   // _getMedia(message);
      // }
      // print("onMessageAdded }}");


      chatMessages.add(await MessageItemData.messageToData(message));
      final messageIndex = message.messageIndex;
      if (messageIndex != null) {
        conversation.advanceLastReadMessageIndex(messageIndex);
      }
      notifyListeners();
    }));
    subscriptions.add(conversation.onMessageDeleted.listen((message) {
      print("onMessageDeleted }}");

      loadConversation();
    }));
    subscriptions.add(conversation.onMessageUpdated.listen((message) {
      print("onMessageUpdated }}");

      loadConversation();
    }));
  }

  void loadConversation() {
    // reset();
    loadMessages();
  }

  void loadMessages() async {
    print("load messageing");
    isLoading = true;
    notifyListeners();

    final numberOfMessages = await conversation.getMessagesCount();
    if (numberOfMessages != null) {

      final nextMessages = await conversation.getLastMessages(numberOfMessages);

      print("load message count ${nextMessages.length}}");

      messages.addAll(nextMessages);
    }


    var v = Stream.fromIterable(messages)
      .asyncMap((message) async {

        return MessageItemData.messageToData(message);

    }).toList();


    chatMessages.addAll(await v);

    print("load message count ${chatMessages.length}}");
    int? a =  await conversation.setAllMessagesRead();

    print("load end $a");

    isLoading = false;
    notifyListeners();
  }




  sendMessage(String text) async {
    print('send message: $text');
    Message? message;
    try {
      // set arbitrary attributes

      final messageOptions = MessageOptions()
        ..withBody(text);
        // ..withAttributes(attributes);
      message = await conversation.sendMessage(messageOptions);
    } catch (e) {
      print('Failed to send message Error: $e');
    }

    isSendingMessage = false;

    print('send message end: ${message?.body}');

    notifyListeners();
  }

  sendMediaMessage(String path) async {
    final mimeType = mime(path);
    print('sendMediaMessagePressed: ${mimeType}, $path');

    if ( mimeType != null) {
      final messageOptions = MessageOptions()
        ..withMedia(File(path), mimeType);
      await conversation.sendMessage(messageOptions);
    }
  }

  void cancelSubscriptions() {

    for (var sub in subscriptions) {
      sub.cancel();
    }
  }
}