import 'dart:developer';

import '../api_service.dart';
import '../endpoint_constants.dart';

/// Asks the backend to push a chat notification to the receiver.
///
/// Messages themselves are written to Firebase by the app; the backend only
/// stores an in-app notification row and sends the FCM push.
class ChatNotifyApi {
  /// Call this right after a message is written to Firebase.
  ///
  /// [receiverUid] is the receiver's Firebase Auth UID, [chatId] the Firebase
  /// chat document id, and [messageId] the message document id when known.
  ///
  /// Never throws: a failed push must not make a sent message look failed, as
  /// the message is already in Firebase by this point.
  static Future<void> notify({
    required String receiverUid,
    required String message,
    String? chatId,
    String? messageId,
    String messageType = 'text',
  }) async {
    if (receiverUid.isEmpty || message.trim().isEmpty) return;

    try {
      final response = await ApiService.post(ApiEndPoints.chatNotify, {
        'receiver_uid': receiverUid,
        'message': message,
        'message_type': messageType,
        if (chatId != null && chatId.isNotEmpty) 'chat_id': chatId,
        if (messageId != null && messageId.isNotEmpty) 'message_id': messageId,
      }, auth: true);

      // push_sent is false when the receiver has no logged-in device or turned
      // messages off. The backend treats both as success, and so do we.
      log('chat/notify -> ${response is Map ? response['data'] : response}');
    } catch (e) {
      log('chat/notify failed (message was still sent): $e');
    }
  }
}
