import 'package:twilio_conversations_linq/twilio_conversations.dart';

class MessageUpdatedEvent {
  final Message message;

  final MessageUpdateReason reason;

  MessageUpdatedEvent(this.message, this.reason);
}
