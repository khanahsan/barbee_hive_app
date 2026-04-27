import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/authentication/auth_api.dart';
import '../../../infrastructure/constants/app_colors.dart';

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
      // 1) Update password in your backend API
      final result = await AuthApi.changePassword(
        currentPass: currentPassController.text.trim(),
        newPass: newPassController.text.trim(),
        confirmPass: confirmPassController.text.trim(),
      );

      if (result['status'] == true) {
        final user = FirebaseAuth.instance.currentUser;


        debugPrint('user.email!: ${user!.email}');
        if (user != null) {
          final cred = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassController.text.trim(), // user's current password
            // password: '1122334455', // user's current password
          );

          try {
            // 2) Re-authenticate first
            await user.reauthenticateWithCredential(cred);

            // 3) Now Firebase allows changing password
            await user.updatePassword(newPassController.text.trim());
          } catch (e) {
            debugPrint('error: $e');
            Utilities.showSnackBar(
              title: "Firebase Error",
              message: "$e Invalid current password for Firebase.",
              isSuccess: false,
            );
            return;
          }
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
