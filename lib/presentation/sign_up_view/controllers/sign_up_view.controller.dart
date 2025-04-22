import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SignUpViewController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedHeight = ''.obs;
  final RxString selectedEyeColor = ''.obs;
  final RxString selectedHairColor = ''.obs;

  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    experienceController.dispose();
    dateController.dispose();
    super.onClose();
  }


  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update(); // Notify GetBuilder to rebuild
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update(); // Notify GetBuilder to rebuild
  }

  void updateGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
    }
  }

  void updateHeight(String? value) {
    if (value != null) {
      selectedHeight.value = value;
    }
  }

  void updateEyeColor(String? value) {
    if (value != null) {
      selectedEyeColor.value = value;
    }
  }

  void updateHairColor(String? value) {
    if (value != null) {
      selectedHairColor.value = value;
    }
  }
}
