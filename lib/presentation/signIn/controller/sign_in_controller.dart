import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
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

    if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe.value = true;
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
      print('Attempting login with email: $email');
      final response = await AuthApi.login(email, password);
      print('Login Response: $response');
      TokenStorage.saveToken(response.token);

      /// SAVE USER ROLE
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userRole,
        response.user.role,
      );

      /// SAVE AUTH TOKEN
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.authToken,
        response.token,
      );

      /// SAVE USER ID
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userId,
        response.user.id,
      );

      /// SAVE USER PROFILE
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userProfileImage,
        response.user.profileImage ?? '',
      );

      /// SAVE USER NAME
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userName,
        response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
      );

      if (rememberMe.value) {
        await SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedEmail,
          email,
        );

        await SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedPassword,
          password,
        );
      } else {
        await SharedPreferenceHelper.remove(SharedPrefKeys.savedEmail);
        await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      }

      ApiService.setToken(response.token);
      await FirebaseService.syncUserWithFirebase(
        apiUserId: response.user.id,
        email: response.user.email,
        password: password,
        name:
        response.user.role == 3
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
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
      errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;
      Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red);
      print(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
