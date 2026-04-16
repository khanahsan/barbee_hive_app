import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/firebase/firebase_service.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';

class SignInController extends GetxController {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  // Form & state
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxBool isGoogleSignInLoading = false.obs;
  final RxBool isAppleSignInLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isObscured = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  /// Re-apply saved credentials (used after logout when controller is permanent).
  void refreshSavedCredentials() {
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final savedEmail = SharedPreferenceHelper.getString(SharedPrefKeys.savedEmail) ?? '';
    final savedPassword = SharedPreferenceHelper.getString(SharedPrefKeys.savedPassword) ?? '';

    emailController.text = savedEmail;
    passwordController.text = savedPassword;
    rememberMe.value = false;
  }

  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  String _resolveUserName(dynamic user) {
    return user.role == 3 ? user.employee?.name ?? '' : user.employer?.businessName ?? '';
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (emailFocusNode.hasFocus) {
      emailFocusNode.unfocus();
    }

    if (passFocusNode.hasFocus) {
      passFocusNode.unfocus();
    }

    isLoading.value = true;

    try {
      String fcmToken = '';
      try {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
        debugPrint("🔔 FCM Token: $fcmToken");
      } catch (e) {
        debugPrint("⚠️ Failed to get FCM token: $e");
        // Continue without FCM token if it fails
      }
      final response = await AuthApi.login(
        ///emai check wrt to running environment
        FirebaseService.firestoreEmailForEmailPasswordFlow(email),
        password,
        fcmToken,
      );

      final shouldRemember = rememberMe.value;
      // Save most values in parallel
      SharedPreferenceHelper.saveInfo(response, shouldRemember, email, password);

      SharedPreferenceHelper.saveString(SharedPrefKeys.fcmToken, fcmToken);

      SharedPreferenceHelper.saveString(SharedPrefKeys.authToken, response.token);

      final firebaseCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: FirebaseService.firestoreEmailForEmailPasswordFlow(email),
        password: password,
      );
      final uid = firebaseCredential.user?.uid;
      if (uid != null && uid.isNotEmpty) {
        await FirebaseService.upsertUserInFirestore(
          uid: uid,
          apiUserId: response.user.id,
          email: response.user.email,
          name: _resolveUserName(response.user),
          role: response.user.role == 3 ? 'employee' : 'employer',
          profileImage: response.user.profileImage,
        );
      }

      Utilities.showSnackBar(title: "Success", message: response.message, isSuccess: true);

      if (shouldRemember) {
        rememberMe.value = false; // reset checkbox after saving credentials
      }

      Get.offAllNamed(Routes.CUSTOMDRAWER);
    } catch (e) {
      final cleaned = e
          .toString()
          .replaceFirst('Exception: POST request error: Exception: ', '')
          .replaceFirst('Exception: ', '');

      Utilities.showSnackBar(title: "Login Failed", message: cleaned, isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isGoogleSignInLoading.value = true;

    try {
      // Step 1: Sign in with Google for tokens only (no Firebase user creation)
      final tokenResult = await FirebaseService.signInWithGoogleTokensOnly();

      if (tokenResult == null) {
        Utilities.showSnackBar(title: "Cancelled", message: "Google Sign-In was cancelled", isSuccess: false);
        return;
      }

      final accessToken = tokenResult.authentication.accessToken;
      final idToken = tokenResult.authentication.idToken;

      debugPrint("🔑 Google Access Token: $accessToken");
      debugPrint("🔑 Google ID Token: $idToken");

      // Step 2: Validate access token
      if (accessToken == null || accessToken.isEmpty) {
        Utilities.showSnackBar(title: "Error", message: "Unable to retrieve Google access token", isSuccess: false);
        return;
      }

      // Step 3: Get FCM token
      String fcmToken = '';
      try {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
        debugPrint("🔔 FCM Token: $fcmToken");
      } catch (e) {
        debugPrint("⚠️ Failed to get FCM token: $e");
        // Continue without FCM token if it fails
      }

      // Step 4: Call backend Google login API
      try {
        final response = await AuthApi.googleLogin(accessToken, fcmToken);

        // Step 6: Save user data locally
        SharedPreferenceHelper.saveInfo(
          response,
          false, // rememberMe not applicable for Google Sign-In
          tokenResult.account.email,
          '', // no password for Google Sign-In
        );
        SharedPreferenceHelper.saveString(SharedPrefKeys.authToken, response.token);

        final credential = GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);
        final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final uid = firebaseCredential.user?.uid;
        if (uid != null && uid.isNotEmpty) {
          await FirebaseService.upsertUserInFirestore(
            uid: uid,
            apiUserId: response.user.id,
            email: response.user.email,
            name: _resolveUserName(response.user),
            role: response.user.role == 3 ? 'employee' : 'employer',
            profileImage: response.user.profileImage,
            authProvider: 'google',
          );
        }

        // Successfully signed in
        Utilities.showSnackBar(title: "Success", message: response.message, isSuccess: true);

        // Navigate to main screen
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } catch (backendError) {
        // Backend rejected the user
        // Clean error message
        final errorMessage = backendError
            .toString()
            .replaceFirst('Exception: POST request error: Exception: ', '')
            .replaceFirst('Exception: ', '');

        Utilities.showSnackBar(title: "Not Registered", message: errorMessage, isSuccess: false);
        return;
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(title: "Google Sign-In Failed", message: errorMessage, isSuccess: false);
    } finally {
      isGoogleSignInLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    isAppleSignInLoading.value = true;

    try {
      // Step 1: Sign in with Apple for tokens only (no Firebase user creation)
      final appleResult = await FirebaseService.signInWithAppleTokensOnly();

      if (appleResult == null) {
        Utilities.showSnackBar(title: "Cancelled", message: "Apple Sign-In was cancelled", isSuccess: false);
        return;
      }

      final identityToken = appleResult.identityToken;
      debugPrint("🔑 Apple Identity Token: $identityToken");

      // Step 2: Validate identity token
      if (identityToken.isEmpty) {
        Utilities.showSnackBar(title: "Error", message: "Unable to retrieve Apple identity token", isSuccess: false);
        return;
      }

      // Step 3: Get FCM token
      String fcmToken = '';
      try {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
        debugPrint("🔔 FCM Token: $fcmToken");
      } catch (e) {
        debugPrint("⚠️ Failed to get FCM token: $e");
        // Continue without FCM token if it fails
      }

      // Step 4: Call backend Apple login API (using same endpoint as Google)
      try {
        final response = await AuthApi.googleLogin(identityToken, fcmToken);

        // Step 5: Save user data locally
        SharedPreferenceHelper.saveInfo(
          response,
          false, // rememberMe not applicable for Apple Sign-In
          appleResult.email ?? '',
          '', // no password for Apple Sign-In
        );
        SharedPreferenceHelper.saveString(SharedPrefKeys.authToken, response.token);

        final credential = OAuthProvider(
          'apple.com',
        ).credential(idToken: appleResult.identityToken, accessToken: appleResult.authorizationCode);
        final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final uid = firebaseCredential.user?.uid;
        if (uid != null && uid.isNotEmpty) {
          await FirebaseService.upsertUserInFirestore(
            uid: uid,
            apiUserId: response.user.id,
            email: response.user.email,
            name: _resolveUserName(response.user),
            role: response.user.role == 3 ? 'employee' : 'employer',
            profileImage: response.user.profileImage,
            authProvider: 'apple',
          );
        }

        // Successfully signed in
        Utilities.showSnackBar(title: "Success", message: response.message, isSuccess: true);

        // Navigate to main screen
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } catch (backendError) {
        // Backend rejected the user
        // Clean error message
        final errorMessage = backendError
            .toString()
            .replaceFirst('Exception: POST request error: Exception: ', '')
            .replaceFirst('Exception: ', '');

        Utilities.showSnackBar(title: "Not Registered", message: errorMessage, isSuccess: false);
        return;
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(title: "Apple Sign-In Failed", message: errorMessage, isSuccess: false);
    } finally {
      isAppleSignInLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
