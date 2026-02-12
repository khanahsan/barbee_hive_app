import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/authentication/auth_api.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/utilities.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  FocusNode newPassFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isNewPasswordObscured = true.obs;
  RxBool isConfirmPasswordObscured = true.obs;

  String email = '';

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
  }

  void toggleNewPassword() {
    isNewPasswordObscured.value = !isNewPasswordObscured.value;
  }

  void toggleConfirmPassword() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  void removeFocus() {
    if (newPassFocusNode.hasFocus) {
      newPassFocusNode.unfocus();
    }
    if (confirmPassFocusNode.hasFocus) {
      confirmPassFocusNode.unfocus();
    }
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;
    removeFocus();

    isLoading.value = true;

    try {
      final result = await AuthApi.resetPassword(
        email: email,
        password: newPassController.text.trim(),
        passwordConfirmation: confirmPassController.text.trim(),
      );

      if (result['status'] == true) {
        newPassController.clear();
        confirmPassController.clear();

        Utilities.showSnackBar(
          title: "Success",
          message: result['message'],
          isSuccess: true,
        );
        Get.offAllNamed(Routes.SIGN_IN_VIEW);
      } else {
        Utilities.showSnackBar(
          title: "Failed",
          message: result['message'],
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
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPassController.dispose();
    confirmPassController.dispose();
    newPassFocusNode.dispose();
    confirmPassFocusNode.dispose();
    super.onClose();
  }
}
