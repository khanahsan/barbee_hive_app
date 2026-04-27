import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/authentication/auth_api.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  FocusNode passFocusNode = FocusNode();
  FocusNode newPassFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isPasswordObscured = false.obs;
  RxBool isNewPasswordObscured = false.obs;
  RxBool isConfirmPasswordObscured = false.obs;


  oldPasswordToggle(){
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  newPasswordToggle(){
    isNewPasswordObscured.value = !isNewPasswordObscured.value;
  }

  confirmPasswordToggle(){
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  removeFocus(){
    if(passFocusNode.hasFocus){
      passFocusNode.unfocus();
    }
    if(newPassFocusNode.hasFocus){
      newPassFocusNode.unfocus();
    }

    if(confirmPassFocusNode.hasFocus){
      confirmPassFocusNode.unfocus();
    }
  }




  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;
    removeFocus();

    isLoading.value = true;

    try {
      final currentPassword = currentPassController.text.trim();
      final newPassword = newPassController.text.trim();
      final confirmPassword = confirmPassController.text.trim();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null || user.email!.isEmpty) {
        Utilities.showSnackBar(
          title: "Firebase Error",
          message: "No Firebase user session found.",
          isSuccess: false,
        );
        return;
      }

      debugPrint('user.email!: ${user.email}');

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } catch (e) {
        debugPrint('error: $e');
        Utilities.showSnackBar(
          title: "Firebase Error",
          message: "$e Invalid current password for Firebase.",
          isSuccess: false,
        );
        return;
      }

      final result = await AuthApi.changePassword(
        currentPass: currentPassword,
        newPass: newPassword,
        confirmPass: confirmPassword,
      );

      if (result['status'] != true) {
        Utilities.showSnackBar(
          title: "Backend Error",
          message: result['message'] ?? 'Password change failed.',
          isSuccess: false,
        );
        return;
      }

      currentPassController.clear();
      newPassController.clear();
      confirmPassController.clear();

      Get.back<void>();

      Utilities.showSnackBar(
        title: "Success",
        message: result['message'],
        isSuccess: true,
      );
    } catch (e) {
      Utilities.showSnackBar(
        title: "Error",
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

/*  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await AuthApi.changePassword(
        currentPass: currentPassController.text.trim(),
        newPass: newPassController.text.trim(),
        confirmPass: confirmPassController.text.trim(),
      );

      if (result['status'] == true) {
        Get.back<void>();
        Utilities.showSnackBar(
          title: "Success",
          message: result['message'],
          isSuccess: true,
        );
      } else {
        Utilities.showSnackBar(
          title: "Failed",
          message: result['message'],
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: "Error",
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }*/

  @override
  void onClose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
