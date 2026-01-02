import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Model to hold Google Sign-In result with access token
class GoogleSignInResult {
  final UserCredential userCredential;
  final String? accessToken;
  final String? idToken;

  GoogleSignInResult({
    required this.userCredential,
    this.accessToken,
    this.idToken,
  });
}

// Lightweight model when we only need Google tokens, not Firebase sign-in
class GoogleAuthTokens {
  final GoogleSignInAccount account;
  final GoogleSignInAuthentication authentication;

  GoogleAuthTokens({
    required this.account,
    required this.authentication,
  });
}

class FirebaseService {
  /// Lightweight helper to pick a Google account without creating a Firebase user.
  /// Returns basic profile info for pre-filling forms.
  static Future<GoogleSignInAccount?> pickGoogleAccount() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("Google account selection cancelled");
        return null;
      }
      return googleUser;
    } catch (e) {
      debugPrint("❌ Google account pick error: $e");
      rethrow;
    }
  }

  /// Sign in with Google just to fetch tokens (no Firebase Auth user creation).
  static Future<GoogleAuthTokens?> signInWithGoogleTokensOnly() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        debugPrint("Google token-only sign-in cancelled by user");
        return null;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      return GoogleAuthTokens(account: account, authentication: auth);
    } catch (e) {
      debugPrint("❌ Google token-only sign-in error: $e");
      rethrow;
    }
  }

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

  /// Create or update Firestore document for Google Sign-In user
  /// Only call this after backend API verification succeeds
  static Future<void> createGoogleUserInFirestore({
    required String uid,
    required int apiUserId,
    required String email,
    required String name,
    required String role,
    String? profileImage,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'apiUserId': apiUserId,
          'name': name,
          'email': email,
          'role': role,
          'profileImage': profileImage ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'authProvider': 'google',
        });
        debugPrint("✅ Google user created in Firestore after backend verification");
      } else {
        // Update existing document with latest data
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'apiUserId': apiUserId,
          'name': name,
          'role': role,
          'profileImage': profileImage ?? '',
        });
        debugPrint("✅ Google user updated in Firestore");
      }
    } catch (e) {
      debugPrint("❌ Failed to create/update Firestore document: $e");
    }
  }

  static Future<GoogleSignInResult?> signInWithGoogle() async {
    try {
      // Configure GoogleSignIn with proper scopes for both iOS and Android
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        debugPrint("Google Sign-In cancelled by user");
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Print the access token
      debugPrint("🔑 Google Access Token: ${googleAuth.accessToken}");
      debugPrint("🔑 Google ID Token: ${googleAuth.idToken}");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint("✅ Google Sign-In successful: ${userCredential.user?.email}");
      debugPrint("⚠️ Firestore document will be created only after backend verification");

      // Return result with access token
      return GoogleSignInResult(
        userCredential: userCredential,
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } catch (e) {
      debugPrint("❌ Google Sign-In error: $e");
      rethrow;
    }
  }
}
