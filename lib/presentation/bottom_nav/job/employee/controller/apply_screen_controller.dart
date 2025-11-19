import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/api/job/job_api.dart';

class ApplyScreenController extends GetxController {
  final experienceLevel = TextEditingController();
  final yearsOfExperience = TextEditingController();
  final expectedSalary = TextEditingController();
  final selectedJobType = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    experienceLevel.dispose();
    yearsOfExperience.dispose();
    expectedSalary.dispose();
    super.onClose();
  }

  void updateJobType(String? value) {
    if (value != null) {
      selectedJobType.value = value;
      print('Selected Job Type: $value');
    }
  }

  Future<void> applyForJob(int jobId) async {
    LogUtil.logError(experienceLevel.text);
    LogUtil.logError(yearsOfExperience.text);
    LogUtil.logError(expectedSalary.text);
    LogUtil.logError(selectedJobType.value);
    if (experienceLevel.text.isEmpty ||
        yearsOfExperience.text.isEmpty ||
        expectedSalary.text.isEmpty ||
        selectedJobType.value.isEmpty) {
      errorMessage.value = 'All fields are required';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final years = int.tryParse(yearsOfExperience.text);
    final salary = double.tryParse(expectedSalary.text);
    if (years == null || years <= 0) {
      errorMessage.value = 'Invalid years of experience';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (salary == null || salary <= 0) {
      errorMessage.value = 'Invalid expected salary';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Applying for jobId: $jobId');
      final response = await JobApi.applyJob(
        jobId: jobId,
        experienceLevel: experienceLevel.text,
        yearsOfExperience: years,
        jobType: selectedJobType.value,
        expectedSalary: salary.toStringAsFixed(2),
      );

      log("Apply job Response; ${response.message}");

      if (response.status) {
        Get.back(); // Close screen
        Get.dialog(
          CustomDialog(title: "Congratulations", subTitle: response.message),
          barrierDismissible: false,
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Apply Job Error: $e');
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
