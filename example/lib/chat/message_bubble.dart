import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilio_conversations_example/chat/message_direction.dart';

class MessageBubble extends StatelessWidget {
  final MessageData2 message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMyMessage = this.message.isMyMessage;

    if (isMyMessage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameAndMessageContent(this.message, isMyMessage),
          SizedBox(
            width: 10,
          ),
          _buildAvatar(message.avatar),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(message.avatar),
          SizedBox(
            width: 10,
          ),
          _buildNameAndMessageContent(this.message, isMyMessage),
        ],
      );
    }
  }

  //创建头像
  Widget _buildAvatar(String? url) {
    return ClipOval(
      child: Image.network(
        url ?? '',
        width: 28,
        height: 28,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildNameAndMessageContent(MessageData2 message, bool isMyMessage) {
    String usrName = message.author ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: isMyMessage ? 0 : 8,
        ),
        //如果不是自己发的消息， 显示name
        if (!isMyMessage)
          Text(!isMyMessage ? usrName : '',
              style: const TextStyle(fontSize: 12, color: Color(0xff666666))),
        SizedBox(height: isMyMessage ? 0 : 8),

        //显示各种消息类型
        _buildMessageContent(message)
      ],
    );
  }

  Widget _buildMessageContent(MessageData2 message) {
    switch (message.type) {
      case MessageType.TEXT:
        return _buildTextMessage(message);
      case MessageType.MEDIA:
        return _buildImageMessage(message);
    }
  }

  Widget _buildTextMessage(MessageData2 message) {
    final color = message.isMyMessage ? Color(0xFF29A0F2) : Color(0xffEFF5FA);
    var radius = Radius.circular(8.0);
    final bRadius = message.isMyMessage
        ? BorderRadius.only(
            topLeft: radius, bottomLeft: radius, bottomRight: radius)
        : BorderRadius.only(
            topRight: radius, bottomLeft: radius, bottomRight: radius);

    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
      constraints: BoxConstraints(maxWidth: 250, minHeight: 35),
      child: Text(message.body ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black)),
      decoration: BoxDecoration(
          //背景
          color: color,
          //设置四周圆角 角度
          borderRadius: bRadius
          //设置四周边框
          // border: Border.all(width: 0.5, color: borderColor ?? const Color(0xFFECECEC)),
          ),
    );
  }

  Widget _buildImageMessage(MessageData2 message) {
    final color = message.isMyMessage ? Color(0xFF29A0F2) : Color(0xffEFF5FA);

    var isHttp = message.imagePath?.startsWith('http') ?? true;

    return Container(
      constraints: BoxConstraints(maxWidth: 150, minHeight: 35, minWidth: 100),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        //背景
        color: color,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //设置四周边框
        // border: Border.all(width: 0.5, color: borderColor ?? const Color(0xFFECECEC)),
      ),
      child: isHttp
          ? Image.network(message.imagePath!)
          : Image.file(File(message.imagePath!)),
    );
  }
}

class MessageData2 {
  final String? body;

  final MessageType type;
  final String? author;

  final bool isMyMessage;

  final String? imagePath;
  final String? avatar;


  MessageData2(
      this.body, this.type, this.author, this.isMyMessage, this.imagePath,
  this.avatar);
}
