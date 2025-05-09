import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create a chat room between two users
  Future<String> getChatRoomID(String userID1, String userID2) async {
    String chatID = userID1.compareTo(userID2) < 0
        ? '${userID1}_$userID2'
        : '${userID2}_$userID1';

    DocumentSnapshot chatDoc = await _firestore.collection('chats').doc(chatID).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatID).set({
        'participants': [userID1, userID2],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': '',
      });
    }
    return chatID;
  }

  // Send a message
  Future<void> sendMessage(String chatID, String senderID, String message) async {
    try {
      await _firestore.collection('chats').doc(chatID).collection('messages').add({
        'senderID': senderID,
        'message': message,
        'timestamp': Offstage(),
        'type': 'text',
      });

      await _firestore.collection('chats').doc(chatID).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': senderID,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e', backgroundColor: Colors.red);
    }
  }

  // Stream of messages for a chat
  Stream<QuerySnapshot> getMessages(String chatID) {
    return _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Stream of chat rooms for a user
  Stream<QuerySnapshot> getChatRooms(String userID) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userID)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}