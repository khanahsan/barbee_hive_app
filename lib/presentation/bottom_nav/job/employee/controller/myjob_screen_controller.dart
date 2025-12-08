import 'package:barbee_hive_app/data/model/applied_job_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/api/job/job_api.dart';

class MyjobsController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  String? userProfileImage = '';
  final appliedJobs = <AppliedJobData>[].obs;

  @override
  void onInit() {
    super.onInit();
    userProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );
    fetchEmployeeAppliedJobs();
  }

  Future<void> fetchEmployeeAppliedJobs() async {
    final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);

    if (userId == null) {
      errorMessage.value = 'User ID not found';
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
      final response = await JobApi.getAppliedJobs(userId);
      if (response.status) {
        appliedJobs.assignAll(response.data);
        print('response $response');
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
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
