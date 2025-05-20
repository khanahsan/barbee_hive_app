import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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

  final RxString selectedJobType = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

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

  void updateJobType(String? value) {
    if (value != null) {
      selectedJobType.value = value;
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

 /* Future<void> postJob() async {
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
        title: titleController.text,
        description: descriptionController.text,
        experienceLevel: experienceLevelController.text,
        minSalary: minSalaryController.text,
        maxSalary: maxSalaryController.text,
        jobType: jobTypeController.text,
        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        recruiterName: recruiterNameController.text,
        noOfDays: int.parse(noOfDaysController.text),
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
}