import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var isEmployer = false.obs;
  var currentUserId = "".obs;
  var currentUserName = "".obs;
  var currentUserImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    currentUserId.value = uid;
    isEmployer.value = role == 2; // 2 = employer

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      currentUserName.value = userDoc['name'] ?? '';
      currentUserImage.value = userDoc['profileImage'] ?? '';
    }
  }

  /// Load all employees (for employer)
  Stream<QuerySnapshot> getAllEmployees() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .snapshots();
  }

  /// Get chats for employer or employee
  Stream<QuerySnapshot> getChatsStream() {
    if (isEmployer.value) {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('employerId', isEqualTo: currentUserId.value)
          .orderBy('updatedAt', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('employeeId', isEqualTo: currentUserId.value)
          .orderBy('updatedAt', descending: true)
          .snapshots();
    }
  }

  /// Start chat (Employer → Employee)
  Future<String> startChatWithEmployee(
    String chatId,
    Map<String, dynamic> employee,
  ) async {
    final chatId = "${currentUserId.value}-${employee['uid']}";
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();
    if (!chatDoc.exists) {
      await chatRef.set({
        'chatId': chatId,
        'employerId': currentUserId.value,
        'employeeId': employee['uid'],
        'employerName': currentUserName.value,
        'employerImage': currentUserImage.value,
        'employeeName': employee['name'],
        'employeeImage': employee['profileImage'] ?? '',
        'lastMessage': '',
        'blockedBy': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    return chatId;
  }

  /// Messages stream for a chat
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Chat stream (to check block status + metadata)
  Stream<DocumentSnapshot> getChatStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots();
  }

  /// Send message (blocked check handled in UI)
  Future<void> sendMessage(
    String chatId,
    String text,
    Map<String, dynamic>? employeeData,
  ) async {
    if (text.trim().isEmpty) return;

    // If employer and employeeData is provided, check/create chat
    if (isEmployer.value && employeeData != null) {
      await startChatWithEmployee(chatId, employeeData);
    }

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    await chatRef.collection('messages').add({
      'senderId': currentUserId.value,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await chatRef.update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Block employee (only employer)
  Future<void> blockEmployee(String chatId) async {
    if (!isEmployer.value) return;
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'blockedBy': currentUserId.value,
    });
  }

  /// Unblock employee
  Future<void> unblockEmployee(String chatId) async {
    if (!isEmployer.value) return;
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'blockedBy': null,
    });
  }
}

 

/* class ChatController extends GetxController {
  var isEmployer = false.obs;
  var currentUserId = "".obs;
  var currentUserName = "".obs;
  var currentUserImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    currentUserId.value = uid;
    isEmployer.value = role == 2; // 2 = employer

    // fetch user info
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      currentUserName.value = userDoc['name'] ?? '';
      currentUserImage.value = userDoc['profileImage'] ?? '';
    }
  }

  /// Load all employees (only for employer)
  Stream<QuerySnapshot> getAllEmployees() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .snapshots();
  }

  /// Get chats for employer or employee
  Stream<QuerySnapshot> getChatsStream() {
    if (isEmployer.value) {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('employerId', isEqualTo: currentUserId.value)
          .orderBy('updatedAt', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('chats')
          .where('employeeId', isEqualTo: currentUserId.value)
          .orderBy('updatedAt', descending: true)
          .snapshots();
    }
  }

  /// Start a chat (Employer → Employee)
  Future<String> startChatWithEmployee(Map<String, dynamic> employee) async {
    final chatId = "${currentUserId.value}-${employee['uid']}";

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();
    if (!chatDoc.exists) {
      await chatRef.set({
        'chatId': chatId,
        'employerId': currentUserId.value,
        'employeeId': employee['uid'],
        'employerName': currentUserName.value,
        'employerImage': currentUserImage.value,
        'employeeName': employee['name'],
        'employeeImage': employee['profileImage'] ?? '',
        'lastMessage': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  /// Messages stream for a chat
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Send message
  Future<void> sendMessage(String chatId, String text) async {
    if (text.trim().isEmpty) return;

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    await chatRef.collection('messages').add({
      'senderId': currentUserId.value,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
 */