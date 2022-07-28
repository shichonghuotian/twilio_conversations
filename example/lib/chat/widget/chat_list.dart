import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilio_conversations_example/chat/data/chat_list_viewmodel.dart';
import 'package:twilio_conversations_example/chat/data/message_item_data.dart';
import 'package:twilio_conversations_example/chat/widget/message_bubble.dart';

import 'message_input_bar.dart';

class ChatList extends StatefulWidget {
  final String conversationSidOrUniqueName;

  final List<Widget>? header;

  const ChatList({Key? key, required this.conversationSidOrUniqueName, this.header
  }) :
        super(key: key);
  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {


  late ScrollController _scrollController;

  late  ChatListViewModel _chatListViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController =  ScrollController();
    _chatListViewModel = ChatListViewModel(widget.conversationSidOrUniqueName);
     _chatListViewModel.init();
  }

  @override
  void didUpdateWidget(covariant ChatList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // _calculateDiffs(oldWidget.items);

  }


  @override
  dispose() {
    _chatListViewModel.cancelSubscriptions();
    _chatListViewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  _sendNewMessage(String text) {
    _chatListViewModel.sendMessage(text);

    _scrollToBottomIfNeeded();

  }

  _sendImageMessage(String url) {
    // var msg =  MessageData2("", MessageType.MEDIA, "author", true, url);
    // setState(() {
    //   final temp = List<MessageData2>.of(_chatMessages);
    //   temp.add(msg);
    //   _chatMessages = temp;
    // });
    _chatListViewModel.sendMediaMessage(url);
    _scrollToBottomIfNeeded();

  }


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: _chatListViewModel,
      child:
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration : Duration(milliseconds: 1000),
                            backgroundColor: Colors.blue,
                            content: Text( 'error')
                        )
                    );

                  },
                  child: Container(
                    color: Colors.white,
                    child: _buildList(),
                  ),
                )),
            MessageInputBar(
              onSendPressed: _sendNewMessage,
              onImageSendPressed: _sendImageMessage,
            ),
          ],
        ),
      )

    );

  }

  Widget _buildList() {
    return  Consumer<ChatListViewModel>(
      builder: ( c, chatvm, Widget? child) {

        if(chatvm.isLoading) {

          return Center(child: CircularProgressIndicator());
        }

        return  CustomScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          scrollDirection: Axis.vertical,
          slivers: [

            ...?widget.header,

            SliverToBoxAdapter(
              child: Container(
                height: 10,
                color: const Color(0xffFAFAFA),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(bottom: 20),
              sliver:  SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var message = chatvm.chatMessages[index];

                  return _buildMessage(message);
                }, childCount: chatvm.chatMessages.length),
              ),
            )


          ],
        );
      },
    );

    // return CustomScrollView(
    //   controller: _scrollController,
    //   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    //   scrollDirection: Axis.vertical,
    //   slivers: [
    //     SliverToBoxAdapter(
    //       child: Container(
    //         height: 0,
    //         color: Colors.red,
    //       ),
    //     ),
    //     SliverList(
    //
    //       delegate: SliverChildBuilderDelegate((context, index) {
    //         var message = _chatMessages[index];
    //
    //         return _buildMessage(message);
    //       }, childCount: _chatMessages.length),
    //     )
    //   ],
    // );
  }

  Widget _buildMessage(MessageItemData message) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 0),
      child: MessageBubble(
        message: message,
      ),
    );
  }

  void _scrollToBottomIfNeeded() {
    try {

      Future.delayed(const Duration(milliseconds: 1000), ()
      {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInQuad,
        );
      });


      // Take index 1 because there is always a spacer on index 0.
      // final oldItem = oldList[1];
      // final item = widget.items[1];
      //
      // if (oldItem is Map<String, Object> && item is Map<String, Object>) {
      //   final oldMessage = oldItem['message']! as types.Message;
      //   final message = item['message']! as types.Message;
      //
      //   // Compare items to fire only on newly added messages.
      //   if (oldMessage != message) {
      //     // Run only for sent message.
      //     if (message.author.id == InheritedUser.of(context).user.id) {
      //       // Delay to give some time for Flutter to calculate new
      //       // size after new message was added
      //       Future.delayed(const Duration(milliseconds: 100), () {
      //         if (_scrollController.hasClients) {
      //           _scrollController.animateTo(
      //             0,
      //             duration: const Duration(milliseconds: 200),
      //             curve: Curves.easeInQuad,
      //           );
      //         }
      //       });
      //     }
      //   }
      // }
    } catch (e) {
      // Do nothing if there are no items.
    }
  }
}
