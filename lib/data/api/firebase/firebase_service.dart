import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static Future<void> syncUserWithFirebase({
    required int apiUserId,
    required String email,
    required String password,
    required String name,
    required String role,
    String? profileImage,
  }) async {
    debugPrint('Syncing Firebase user: $email');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("✅ Firebase user already exists");
    } catch (_) {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': apiUserId,
        'name': name,
        'email': email,
        'role': role,
        'profileImage': profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint("✅ Firebase user created and synced");
    }
  }
}
