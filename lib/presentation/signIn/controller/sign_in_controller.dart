import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/api_service.dart';
import '../../../data/api/firebase/firebase_service.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';

class SignInController extends GetxController {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form & state
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxBool isGoogleSignInLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isObscured = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    String savedEmail =
        SharedPreferenceHelper.getString(SharedPrefKeys.savedEmail) ?? '';
    String savedPassword =
        SharedPreferenceHelper.getString(SharedPrefKeys.savedPassword) ?? '';

    emailController.text = savedEmail;

    if (savedPassword.isNotEmpty) {
      passwordController.text = savedPassword;
      rememberMe.value = true;
    } else {
      passwordController.clear();
      rememberMe.value = false;
    }
  }

  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoading.value = true;

    try {


      print("Device token 1 : ${await FirebaseMessaging.instance.getToken() ?? ""}");

      // LOGIN API
      final response = await AuthApi.login(email, password, await FirebaseMessaging.instance.getToken() ?? "");

    //  return;

      // Save most values in parallel
      await Future.wait([
        TokenStorage.saveToken(response.token),
        SharedPreferenceHelper.saveInt(
          SharedPrefKeys.userRole,
          response.user.role,
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.authToken,
          response.token,
        ),
        SharedPreferenceHelper.saveInt(
          SharedPrefKeys.userId,
          response.user.id,
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userProfileImage,
          response.user.profileImage ?? '',
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userName,
          response.user.role == 3
              ? response.user.employee?.name ?? ""
              : response.user.employer?.businessName ?? "",
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userEmail,
          response.user.email,
        ),
      ]);

      // Handle remember me
      if (rememberMe.value) {
        SharedPreferenceHelper.saveString(SharedPrefKeys.savedEmail, email);
        SharedPreferenceHelper.saveString(SharedPrefKeys.savedPassword, password);
        SharedPreferenceHelper.saveBool(SharedPrefKeys.isRememberMe, true);
      }
      // else {
      //   SharedPreferenceHelper.remove(SharedPrefKeys.savedEmail);
      //   SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      // }

      // Set token
      ApiService.setToken(response.token);

      // Sync Firebase → Run in background (DO NOT AWAIT)
      FirebaseService.syncUserWithFirebase(
        apiUserId: response.user.id,
        email: response.user.email,
        password: password,
        name: response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
        role: response.user.role == 3 ? "employee" : "employer",
        profileImage: response.user.profileImage,
      );

      Utilities.showSnackBar(
        title: "Success",
        message: response.message,
        isSuccess: true,
      );

      Get.offAllNamed(Routes.CUSTOMDRAWER);

    } catch (e) {
      final cleaned =
      e.toString()
          .replaceFirst('Exception: POST request error: Exception: ', '')
          .replaceFirst('Exception: ', '');

      Utilities.showSnackBar(
        title: "Login Failed",
        message: cleaned,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isGoogleSignInLoading.value = true;

    try {
      // Step 1: Sign in with Google via Firebase
      final userCredential = await FirebaseService.signInWithGoogle();

      if (userCredential == null) {
        // User cancelled the sign-in
        Utilities.showSnackBar(
          title: "Cancelled",
          message: "Google Sign-In was cancelled",
          isSuccess: false,
        );
        return;
      }

      // Step 2: Get user data from Google
      final email = userCredential.user?.email;
      final uid = userCredential.user?.uid;

      if (email == null || uid == null) {
        Utilities.showSnackBar(
          title: "Error",
          message: "Unable to retrieve Google account information",
          isSuccess: false,
        );
        return;
      }

      // Step 3: Check if user exists in Firestore and is registered in backend
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists || !userDoc.data()!.containsKey('apiUserId')) {
        // User is not registered in the backend
        Utilities.showSnackBar(
          title: "Not Registered",
          message: "Please register your account first before using Google Sign-In",
          isSuccess: false,
        );

        // Sign out from Firebase since they're not registered
        await FirebaseAuth.instance.signOut();
        return;
      }

      // Step 4: User exists in backend, retrieve their data
      final apiUserId = userDoc.data()!['apiUserId'];
      final role = userDoc.data()!['role'];
      final name = userDoc.data()!['name'] ?? '';
      final profileImage = userDoc.data()!['profileImage'] ?? '';

      // Step 5: Save user data locally
      await Future.wait([
        SharedPreferenceHelper.saveInt(
          SharedPrefKeys.userId,
          apiUserId,
        ),
        SharedPreferenceHelper.saveInt(
          SharedPrefKeys.userRole,
          role == 'employee' ? 3 : 2,
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userName,
          name,
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userProfileImage,
          profileImage,
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userEmail,
          email,
        ),
      ]);

      // Successfully signed in
      Utilities.showSnackBar(
        title: "Success",
        message: "Successfully signed in with Google",
        isSuccess: true,
      );

      // Navigate to main screen
      Get.offAllNamed(Routes.CUSTOMDRAWER);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(
        title: "Google Sign-In Failed",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isGoogleSignInLoading.value = false;
    }
  }


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
