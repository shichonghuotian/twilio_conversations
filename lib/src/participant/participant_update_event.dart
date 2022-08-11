import 'package:twilio_conversations_linq/twilio_conversations.dart';

class ParticipantUpdatedEvent {
  final Participant participant;

  final ParticipantUpdateReason reason;

  ParticipantUpdatedEvent(this.participant, this.reason);
}
