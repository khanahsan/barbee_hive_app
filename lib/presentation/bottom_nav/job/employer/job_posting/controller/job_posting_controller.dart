import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../../../data/model/color_response.dart' as colorModel;


class JobPostingController extends GetxController {

  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController experienceLevelController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController recruiterController = TextEditingController();
  final TextEditingController jobDesController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final RxString selectedSkill = ''.obs;


  final RxString selectedJobType = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchSkills();
    super.onInit();
  }

  @override
  void onClose() {
    jobRoleController.dispose();
    experienceLevelController.dispose();
    salaryController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    recruiterController.dispose();
    jobDesController.dispose();
    super.onClose();
  }

  Future<void> showResetPasswordDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Congratulations",
          subTitle: "Your Job Application Has Been Submitted",
        );
      },
    );
  }
  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void updateJobType(String? value) {
    if (value != null) {
      selectedJobType.value = value;
    }
  }

  void updateSkill(String? value) {
    if (value != null) {
      selectedSkill.value = value;
    }
  }

  Future<void> fetchSkills() async {
    isLoading.value = true;

    try {
      print('Fetching skills');
      final response = await AuthProvider.getSkills();
      if (response.status) {
        skills.assignAll(response.data);
      } else {
        debugPrint(response.message);
        showErrorSnackbar('Error', 'Failed to fetch skills');
      }
    } catch (e) {
      print('Skills Error: $e');
      debugPrint('Failed to fetch skills');
      showErrorSnackbar('Error', 'Failed to fetch skills');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      print('Picking resume');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result != null && result.files.single.path != null) {
        selectedImage.value = File(result.files.single.path!);
        print('Selected resume: ${selectedImage.value!.path}');
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('File picker error: $e');
      Get.snackbar(
        'Error',
        'Failed to pick resume: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /*Future<void> postJob() async {
    if (jobRoleController.text.isEmpty ||
        experienceLevelController.text.isEmpty ||
        salaryController.text.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        cityController.text.isEmpty ||
        recruiterController.text.isEmpty ||
        jobDesController.text.isEmpty
    ) {
      Get.snackbar('Error', 'All fields are required', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await AuthProvider.postJob(
          title: jobRoleController.text,
          description: jobDesController.text,
          experienceLevel: experienceLevelController.text,
          minSalary: salaryController.text,
          maxSalary: salaryController.text,
          jobType: selectedJobType.value,
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          recruiterName: recruiterController.text,
          noOfDays: 2
      );

      if (response.status) {
        Get.snackbar('Success', response.message, backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/dashboard'); // Adjust route as needed
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Job Post Error: $e');
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }*/
  Future<void> postJob(BuildContext context) async {
    if (jobRoleController.text.isEmpty ||
        jobDesController.text.isEmpty ||
        experienceLevelController.text.isEmpty ||
        salaryController.text.isEmpty ||
        selectedJobType.value.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        cityController.text.isEmpty ||
        recruiterController.text.isEmpty||
        selectedSkill.value.isEmpty) {
      Get.snackbar('Error', 'All fields are required', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (selectedImage.value == null) {
      Get.snackbar('Error', 'Please select an image', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    final userSkill = skills.firstWhere(
          (skill) => skill.name == selectedSkill.value,
      orElse: () => throw Exception('Invalid eye color'),
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await AuthProvider.postJob(
        title: jobRoleController.text,
        description: jobDesController.text,
        experienceLevel: experienceLevelController.text,
        minSalary: salaryController.text,
        maxSalary: salaryController.text,
        jobType: selectedJobType.value, // Assuming selectedJobType.value was a typo
        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        recruiterName: recruiterController.text,
        //noOfDays: int.parse(noOfDaysController.text),
        noOfDays: 2,
        image: selectedImage.value, // Pass selected image
        skillId: userSkill.id
      );

      if (response.status) {
        /*Get.snackbar('Success', response.message, backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(Routes.CUSTOMDRAWER);*/

        print('Status is true, showing dialog');
        await showResetPasswordDialog(context); // Wait for dialog to close
        print('Dialog closed, navigating to SIGN_IN_VIEW');
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Job Post Error: $e');
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}