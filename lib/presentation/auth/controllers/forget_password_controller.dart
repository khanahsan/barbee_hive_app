import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/authentication/auth_api.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_dialog.dart';

class ForgetPasswordController extends GetxController{

  final TextEditingController fEmailController = TextEditingController();
  final fPasswordIsLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  Future<void> forgotPassword(context) async {
    final email = fEmailController.text.trim();

    if(focusNode.hasFocus){
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
      fPasswordIsLoading.value = false;
      if (status) {

        print('Status is true, showing dialog');
        await showResetPasswordDialog(
            Get.context!,
            email,
            onDone: (){
              Navigator.of(context, rootNavigator: true).pop();
              Get.back();

            }
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

  // Method to show the dialog
  Future<void> showResetPasswordDialog(
      BuildContext context,
      String email,
      {void Function()? onDone}
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
          onDone: onDone,
        );
      },
    );
  }


  @override
  void onClose() {
    fEmailController.dispose();

    super.onClose();
  }

}