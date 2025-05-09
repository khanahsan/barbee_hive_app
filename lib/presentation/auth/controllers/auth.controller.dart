import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/helpers/shared_preference_helper.dart';


class AuthController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController fEmailController = TextEditingController();



  final isLoading = false.obs;
  final fPasswordIsLoading = false.obs;

  final RxBool isObscured = true.obs;

  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }

  Future<void> login() async {
    final email = nameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password required", backgroundColor: Colors.red);
      return;
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar("Error", "Please enter a valid email address", backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;

    try {
      print('Attempting login with email: $email');
      final response = await AuthProvider.login(email, password);
      print('Login Response: $response');
      TokenStorage.saveToken(response.token);

      await SharedPreferenceHelper.saveInt(SharedPrefKeys.userRole, response.user.role);

      ApiService.setToken(response.token);

      Get.snackbar("Success", response.message);
      Get.offAllNamed(Routes.CUSTOMDRAWER);
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: POST request error: Exception: ', '');
      errorMessage = errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;
      Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;

    try {
      await AuthProvider.logout();
      await TokenStorage.clearToken();
      ApiService.clearToken();
      Get.snackbar("Success", "Logged out successfully");
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: POST request error: Exception: ', '');
      errorMessage = errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;
      Get.snackbar("Logout Failed", errorMessage, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    final email = fEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email required", backgroundColor: Colors.red);
      return; // Keep return to prevent API call
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar("Error", "Please enter a valid email address", backgroundColor: Colors.red);
      return;
    }

    fPasswordIsLoading.value = true;

    try {
      print('Attempting forgot password for email: $email');
      final response = await AuthProvider.forgotPassword(email);
      final status = response['status'] as bool;
      final message = response['message'] as String;
      print('Forgot Password Response: status=$status, message=$message');

      Get.snackbar(
        "Forgot Password",
        message,
        backgroundColor: status ? Colors.green : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );

      if (status) {
        Get.offNamed(Routes.SIGN_IN_VIEW); // Navigate to SIGN_IN_VIEW on success
      }
    } catch (e) {
      print('Forgot Password Error: $e');
      String errorMessage = e.toString().replaceFirst('Exception: POST request error: Exception: ', '');
      errorMessage = errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;
      Get.snackbar(
        "Forgot Password Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      fPasswordIsLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    fEmailController.dispose();
    super.onClose();
  }
}
