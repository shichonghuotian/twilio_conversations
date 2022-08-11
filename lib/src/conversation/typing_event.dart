import 'package:twilio_conversations_linq/twilio_conversations.dart';

class TypingEvent {
  final Conversation conversation;

  final Participant participant;

  TypingEvent(this.conversation, this.participant);
}
