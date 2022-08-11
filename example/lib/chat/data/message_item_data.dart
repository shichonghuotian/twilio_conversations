import 'package:twilio_conversations_linq/twilio_conversations.dart';

class MessageItemData {
  final Message? message;
  final String? body;

  final MessageType type;
  final String? author;

  final bool isMyMessage;

  final String? imagePath;
  final String? avatar;

  MessageItemData(this.message, this.body, this.type, this.author,
      this.isMyMessage, this.imagePath, this.avatar);

  static Future<MessageItemData> messageToData(Message message) async {
    // print("message: ${message.participant?.attributes.data}");
    final isMyMessage =
        message.author == TwilioConversations.conversationClient?.myIdentity;
    if (message.type == MessageType.TEXT) {
      return MessageItemData(
          message,
          message.body ?? '',
          message.type,
          message.participant?.userName ?? message.author,
          isMyMessage,
          null,
          message.participant?.avatarUrl);
    } else {
      var media = await getMedia(message);

      print("media: $media");
      return MessageItemData(
          message,
          message.body ?? '',
          message.type,
          message.participant?.userName ?? message.author,
          isMyMessage,
          media ?? '',
          message.participant?.avatarUrl);
    }
  }

  static Future<String?> getMedia(Message message) async {
    print('_getMedia => message: ${message.sid}');
    final url = await message.getMediaUrl();
    return url;
  }
}
