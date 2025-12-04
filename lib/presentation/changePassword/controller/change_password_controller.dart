import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/api/authentication/auth_api.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  Future<void> changePassword() async {
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
  }

  @override
  void onClose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
