import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/color_response.dart';



class SignUpEmployerController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();


  //final RxString selectedPositionSeeking = ''.obs;
  final RxString selectedSkill = ''.obs;

  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxList<Skill> skills = <Skill>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchSkills();
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
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
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
    update();
  }

  void updateSkill(String? value) {
    if (value != null) {
      selectedSkill.value = value;
    }
  }

  Future<void> fetchSkills() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching skills');
      final response = await AuthProvider.getSkills();
      if (response.status) {
        skills.assignAll(response.data);
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Skills Error: $e');
      errorMessage.value = 'Failed to fetch skills';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!isChecked.value) {
      Get.snackbar(
        'Error',
        'Please agree to the Terms of Service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Validate inputs
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          countryController.text.isEmpty ||
          stateController.text.isEmpty || // Use selectedDate
          cityController.text.isEmpty ||
          selectedSkill.value.isEmpty
      /*||
        selectedSkill.value.isEmpty*/
      ) {
        throw Exception('All fields are required');
      }

      if (passwordController.text != confirmPasswordController.text) {
        throw Exception('Passwords do not match');
      }

      final userSkill = skills.firstWhere(
            (skill) => skill.name == selectedSkill.value,
        orElse: () => throw Exception('Invalid eye color'),
      );

      final response = await AuthProvider.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: 2,

        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        skillId:  userSkill.id,
      );

      if (response.status) {
        ApiService.setToken(response.data.token);
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Registration Error: $e');
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


}