import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/location_service.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/helpers/shared_preference_helper.dart';

class AuthController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fEmailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final fPasswordIsLoading = false.obs;
  final RxBool isObscured = true.obs;

  @override
  void onInit() async {
    super.onInit();
    // fetchDashboardUsers();
    await LocationService.determinePosition();
  }

  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }

  // Method to show the dialog
  Future<void> showResetPasswordDialog(
    BuildContext context,
    String email,
  ) async {
    print('Showing reset password dialog for email: $email'); // Debug log
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          email: email,
          title: "Reset Password",
          subTitle: "A link to reset your password has been sent to",
        );
      },
    );
  }

  Future<void> login() async {
    final email = nameController.text.trim();
    final password = passwordController.text.trim();

    isLoading.value = true;

    try {
      print('Attempting login with email: $email');
      final response = await AuthProvider.login(email, password);
      print('Login Response: $response');
      TokenStorage.saveToken(response.token);

      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userRole,
        response.user.role,
      );
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userId,
        response.user.id,
      );

      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userProfileImage,
        response.user.profileImage ?? '',
      );

      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userName,
        response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
      );

      ApiService.setToken(response.token);
      await AuthProvider.syncUserWithFirebase(
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

      Get.snackbar("Success", response.message);
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

  Future<void> logout() async {
    isLoading.value = true;

    try {
      await AuthProvider.logout();
      await TokenStorage.clearToken();
      ApiService.clearToken();
      Get.snackbar("Success", "Logged out successfully");
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
              ? errorMessage.replaceFirst('Exception: ', '')
              : errorMessage;
      Get.snackbar("Logout Failed", errorMessage, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /*
  Future<void> forgotPassword(BuildContext context) async {
    final email = fEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email required", backgroundColor: Colors.red);
      return; // Keep return to prevent API call
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.red,
      );
      return;
    }

    fPasswordIsLoading.value = true;

    try {
      print('Attempting forgot password for email: $email');
      final response = await AuthProvider.forgotPassword(email);
      final status = response['status'] as bool;
      final message = response['message'] as String;
      print('Forgot Password Response: status=$status, message=$message');


      showResetPasswordDialog(context, email);

      if (status) {
        Get.offNamed(
          Routes.SIGN_IN_VIEW,
        ); // Navigate to SIGN_IN_VIEW on success
      }
    } catch (e) {
      print('Forgot Password Error: $e');
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
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
*/

  Future<void> forgotPassword(BuildContext context) async {
    final email = fEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email required", backgroundColor: Colors.red);
      return; // Keep return to prevent API call
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.red,
      );
      return;
    }

    fPasswordIsLoading.value = true;

    try {
      print('Attempting forgot password for email: $email');
      final response = await AuthProvider.forgotPassword(email);
      final status = response['status'] as bool; // Status is a boolean
      final message = response['message'] as String;
      print('Forgot Password Response: status=$status, message=$message');

      if (status) {
        print('Status is true, showing dialog');
        await showResetPasswordDialog(
          context,
          email,
        ); // Wait for dialog to close
        print('Dialog closed, navigating to SIGN_IN_VIEW');
        Get.offNamed(Routes.SIGN_IN_VIEW); // Navigate after dialog is closed
      } else {
        Get.snackbar(
          "Forgot Password Failed",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Forgot Password Error: $e');
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
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
