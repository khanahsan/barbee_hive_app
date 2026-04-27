import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/authentication/auth_api.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/reset_password_otp_dialog.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController fEmailController = TextEditingController();
  final fPasswordIsLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  Future<void> forgotPassword(context) async {
    final email = fEmailController.text.trim();

    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }

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
      final response = await AuthApi.forgotPassword(email);
      final status = response['status'] as bool; // Status is a boolean
      final message = response['message'] as String;
      print('Forgot Password Response: status=$status, message=$message');
      print('Forgot Password Response: ${email}');
      fPasswordIsLoading.value = false;
      if (status) {
        print('Status is true, showing dialog');
        await showResetPasswordDialog(
          Get.context!,
          email,
          onDone: (otp) async {
            await verifyOtp(context, email, otp);
          },
        );
      } else {
        Utilities.showSnackBar(
          title: "Error",
          message: message,
          isSuccess: false,
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

      Utilities.showSnackBar(
        title: "Error",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      fPasswordIsLoading.value = false;
    }
  }

  Future<void> verifyOtp(
    BuildContext context,
    String email,
    String otp,
  ) async {
    fPasswordIsLoading.value = true;
    try {
      final response = await AuthApi.verifyOtp(email: email, otp: otp);
      final status = response['status'] as bool;
      final message = response['message'] as String;

      if (status) {
        Navigator.of(context, rootNavigator: true).pop();
        Utilities.showSnackBar(
          title: "Success",
          message: message,
          isSuccess: true,
        );
        Get.toNamed(Routes.resetPassScreen, arguments: {'email': email});
      } else {
        Utilities.showSnackBar(
          title: "Error",
          message: message,
          isSuccess: false,
        );
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
              ? errorMessage.replaceFirst('Exception: ', '')
              : errorMessage;

      Utilities.showSnackBar(
        title: "Error",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      fPasswordIsLoading.value = false;
    }
  }

  // Method to show the dialog
  Future<void> showResetPasswordDialog(
    BuildContext context,
    String email, {
    Future<void> Function(String otp)? onDone,
  }) async {
    print('Showing reset password dialog for email: $email'); // Debug log
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return ResetPasswordOtpDialog(email: email, onDone: onDone);
      },
    );
  }

  @override
  void onClose() {
    fEmailController.dispose();

    super.onClose();
  }
}
