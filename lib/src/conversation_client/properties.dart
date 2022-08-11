import 'package:twilio_conversations_linq/api.dart';
import 'package:twilio_conversations_linq/src/conversation_client/conversation_client.dart';

/// Represents options when connecting to a [ConversationClient].
class Properties {
  //#region Private API properties
  final String _region;
  //#endregion

  //#region Public API properties
  /// Twilio server region to connect to.
  ///
  /// Instances exist in specific regions, so this should only be changed if needed.
  String get region {
    return _region;
  }
  //#endregion

  const Properties({
    String? region,
  }) : _region = region ?? 'us1';

  PropertiesData toPigeon() {
    final result = PropertiesData();
    result.region = region;
    return result;
  }
}
