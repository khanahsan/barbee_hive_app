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
  var currentUserRole = "".obs;
  var chats = <QueryDocumentSnapshot>[].obs;
  var isLoading = true.obs;
  RxString userProfileImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userProfileImage.value =
        SharedPreferenceHelper.getString(SharedPrefKeys.userProfileImage) ?? '';
  }

  /// Load current user details from Firebase + SharedPrefs
  Future<void> loadCurrentUser() async {
    try {
      isLoading.value = true;
      final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
      final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      currentUserId.value = uid;
      isEmployer.value = role == 2;

      if (uid.isNotEmpty) {
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          currentUserName.value = userDoc['name'] ?? '';
          currentUserImage.value = userDoc['profileImage'] ?? '';
          currentUserRole.value = userDoc['role'] ?? '';
        }
        print("✅ Current User ID: ${currentUserId.value}");
        print("✅ Role: ${isEmployer.value ? 'Employer' : 'Employee'}");
        print("✅ Name: ${currentUserName.value}");
        print("✅ Image: ${currentUserImage.value}");

        // ✅ Start listening to chats after user is loaded
        listenToChats();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void listenToChats() {
    final uid = currentUserId.value;
    if (uid.isEmpty) return;

    FirebaseFirestore.instance
        .collection('chats')
        .where('userIds', arrayContains: uid) // ✅ use arrayContains
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          chats.value = snapshot.docs;
        });
  }

  /// Helper: generate consistent chat ID for any user pair
  String generateChatId(String uid1, String uid2, String chatType) {
    if (chatType == 'employer_employee') {
      // keep order as employer-employee
      return "$uid1-$uid2";
    } else {
      // sort alphabetically for same-role chats
      final ids = [uid1, uid2]..sort();
      return ids.join('-');
    }
  }

  /// Stream all chats for this user
  Stream<QuerySnapshot>? getChatsStream() {
    final uid = currentUserId.value;
    if (uid.isEmpty) return null;

    // ✅ Only fetch chats where the current user is one of the participants
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants.$uid', isNotEqualTo: null)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  /// Stream of messages for a chat
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Chat document stream (metadata)
  Stream<DocumentSnapshot> getChatStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots();
  }

  /// Start a chat (only creates if it doesn't exist)
  Future<String> startChat(
    Map<String, dynamic> otherUser, {
    String chatType = 'employer_employee',
  }) async {
    if (currentUserName.value.isEmpty || currentUserImage.value.isEmpty) {
      await loadCurrentUser();
    }

    final generatedChatId = generateChatId(
      currentUserId.value,
      otherUser['uid'],
      chatType,
    );

    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(generatedChatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      final participants = {
        currentUserId.value: {
          'name': currentUserName.value,
          'image': currentUserImage.value,
        },
        otherUser['uid']: {
          'name': otherUser['name'],
          'image': otherUser['profileImage'] ?? '',
        },
      };

      await chatRef.set({
        'chatId': generatedChatId,
        'participants': participants,
        'userIds': [currentUserId.value, otherUser['uid']],
        'lastMessage': '',
        'blockedBy': null,
        'updatedAt': FieldValue.serverTimestamp(),
        'chatType': chatType,
      });
    }

    return generatedChatId;
  }

  /// Send a message (create chat if missing)
  Future<void> sendMessage(
    String chatId,
    String text,
    Map<String, dynamic>? otherUserData,
    String chatType,
  ) async {
    if (text.trim().isEmpty) return;

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    // ✅ Only create chat if it doesn't exist
    if (!chatDoc.exists && otherUserData != null) {
      await startChat(otherUserData, chatType: chatType);
    }

    // 🟢 Add message
    await chatRef.collection('messages').add({
      'senderId': currentUserId.value,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 🟢 Update chat metadata
    await chatRef.update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Block employee (only if employer)
  Future<void> blockEmployee(String chatId) async {
    if (!isEmployer.value) return;
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'blockedBy': currentUserId.value,
    });
  }

  /// Unblock employee (only if employer)
  Future<void> unblockEmployee(String chatId) async {
    if (!isEmployer.value) return;
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'blockedBy': null,
    });
  }
}

//  class ChatController extends GetxController {
// var isEmployer = false.obs;
// var currentUserId = "".obs;
// var currentUserName = "".obs;
// var currentUserImage = "".obs;

// @override
// void onInit() {
//   loadCurrentUser();
// }

// Future<void> loadCurrentUser() async {
//   final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
//   final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

//   currentUserId.value = uid;
//   isEmployer.value = role == 2; // 2 = employer

//   final userDoc =
//       await FirebaseFirestore.instance.collection('users').doc(uid).get();

//   print(userDoc.data());

//   if (userDoc.exists) {
//     currentUserName.value = userDoc['name'] ?? '';
//     currentUserImage.value = userDoc['profileImage'] ?? '';
//   }

//   print(
//     "Current User ID: $currentUserId, Role: ${isEmployer.value ? 'Employer' : 'Employee'}",
//   );
//   print("Current User Name: $currentUserName");
//   print("Current User Image: $currentUserImage");
// }

// /// Load all employees (for employer)
// Stream<QuerySnapshot> getAllEmployees() {
//   return FirebaseFirestore.instance
//       .collection('users')
//       .where('role', isEqualTo: 'employee')
//       .snapshots();
// }

// /// Get chats for employer or employee
// Stream<QuerySnapshot> getChatsStream() {
//   if (isEmployer.value) {
//     return FirebaseFirestore.instance
//         .collection('chats')
//         .where('employerId', isEqualTo: currentUserId.value)
//         .orderBy('updatedAt', descending: true)
//         .snapshots();
//   } else {
//     return FirebaseFirestore.instance
//         .collection('chats')
//         .where('employeeId', isEqualTo: currentUserId.value)
//         .orderBy('updatedAt', descending: true)
//         .snapshots();
//   }
// }

// /// Start chat (Employer → Employee)
// Future<String> startChatWithEmployee(
//   String chatId,
//   Map<String, dynamic> employee,
// ) async {
//   if (currentUserName.value.isEmpty || currentUserImage.value.isEmpty) {
//     await loadCurrentUser();
//   }

//   final generatedChatId = "${currentUserId.value}-${employee['uid']}";
//   final chatRef = FirebaseFirestore.instance
//       .collection('chats')
//       .doc(generatedChatId);

//   final chatDoc = await chatRef.get();
//   if (!chatDoc.exists) {
//     await chatRef.set({
//       'chatId': generatedChatId,
//       'employerId': currentUserId.value,
//       'employeeId': employee['uid'],
//       'employerName': currentUserName.value,
//       'employerImage': currentUserImage.value,
//       'employeeName': employee['name'],
//       'employeeImage': employee['profileImage'] ?? '',
//       'lastMessage': '',
//       'blockedBy': null,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }
//   return generatedChatId;
// }

// /// Messages stream for a chat
// Stream<QuerySnapshot> getMessagesStream(String chatId) {
//   return FirebaseFirestore.instance
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();
// }

// /// Chat stream (to check block status + metadata)
// Stream<DocumentSnapshot> getChatStream(String chatId) {
//   return FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots();
// }

// /// Send message (blocked check handled in UI)
// Future<void> sendMessage(
//   String chatId,
//   String text,
//   Map<String, dynamic>? employeeData,
// ) async {
//   if (text.trim().isEmpty) return;

//   // If employer and employeeData is provided, check/create chat
//   if (isEmployer.value && employeeData != null) {
//     await startChatWithEmployee(chatId, employeeData);
//   }

//   final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
//   await chatRef.collection('messages').add({
//     'senderId': currentUserId.value,
//     'text': text,
//     'timestamp': FieldValue.serverTimestamp(),
//   });
//   await chatRef.update({
//     'lastMessage': text,
//     'updatedAt': FieldValue.serverTimestamp(),
//   });
// }

// /// Block employee (only employer)
// Future<void> blockEmployee(String chatId) async {
//   if (!isEmployer.value) return;
//   await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
//     'blockedBy': currentUserId.value,
//   });
// }

// /// Unblock employee
// Future<void> unblockEmployee(String chatId) async {
//   if (!isEmployer.value) return;
//   await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
//     'blockedBy': null,
//   });
// }
