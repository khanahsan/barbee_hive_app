import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        debugPrint("Google Sign-In cancelled by user");
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Create or update user document in Firestore
      final uid = userCredential.user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': userCredential.user?.displayName ?? '',
          'email': userCredential.user?.email ?? '',
          'profileImage': userCredential.user?.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'authProvider': 'google',
        });
        debugPrint("✅ Google user created in Firestore");
      } else {
        debugPrint("✅ Google user already exists in Firestore");
      }

      debugPrint("✅ Google Sign-In successful: ${userCredential.user?.email}");
      return userCredential;
    } catch (e) {
      debugPrint("❌ Google Sign-In error: $e");
      rethrow;
    }
  }
}
