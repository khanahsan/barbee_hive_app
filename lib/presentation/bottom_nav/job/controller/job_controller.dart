import 'dart:developer';

import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/api/job/job_api.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class JobController extends GetxController {
  /// Controllers
  final searchController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();

  /// Save Role Value
  Rx<bool> isEmployer = false.obs;

  /// Save User Profile
  Rx<String?> userProfileImage = ''.obs;

  /// Employer Jobs List
  final employerJobs = <JobData>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Employee Jobs List
  final employeeJobs = <JobData>[].obs;

  final RxString selectedJobType = ''.obs;
  final filteredJobs = <JobData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRoleAsync();
  }

  /// Fetch Role Value From Local Storage
  Future<void> loadRoleAsync() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    isEmployer.value = role == 2;

    userProfileImage.value = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );

    if (isEmployer.value) {
      fetchEmployerJobs();
    } else {
      fetchEmployeeJobs();
    }
  }

  /// Function to get Employer Jobs
  Future<void> fetchEmployerJobs() async {
    log('fetchEmployerJobs Function Called');

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
      employerJobs.clear();
      final response = await JobApi.getJobs(userId);
      if (response.status) {
        employerJobs.assignAll(response.data);
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

  /// Function to get Employee Jobs
  Future<void> fetchEmployeeJobs() async {
    log('fetchEmployeeJobs Function Called');

    isLoading.value = true;
    errorMessage.value = '';

    try {
      employeeJobs.clear();
      final response = await JobApi.getEmployeeJobs();
      if (response.status) {
        employeeJobs.assignAll(response.data);
        filteredJobs.assignAll(response.data);
        print('response.data ${response.data.length}');
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

  /// Filter Jobs (Show Only For Employee)
  void filterApplicationsByText(String query) {
    var filtered = employeeJobs.toList();

    if (query.isNotEmpty) {
      filtered =
          filtered.where((app) {
            final titleMatch = app.title.toLowerCase().contains(
              query.toLowerCase(),
            );
            final skillMatch =
                app.skills!.name.toLowerCase().contains(query.toLowerCase()) ??
                false;
            return titleMatch || skillMatch;
          }).toList();
    }

    filteredJobs.assignAll(applyDialogFilters(filtered));
  }

  List<JobData> applyDialogFilters(List<JobData> inputList) {
    var filtered = inputList;

    if (selectedJobType.value.isNotEmpty) {
      filtered =
          filtered.where((app) {
            return app.jobType.toLowerCase() ==
                selectedJobType.value.toLowerCase();
          }).toList();
    }

    if (salaryController.text.isNotEmpty) {
      final salary = int.tryParse(salaryController.text);
      if (salary != null) {
        filtered =
            filtered.where((app) {
              return app.salaryRange.min == salary;
            }).toList();
      }
    }

    if (experienceController.text.isNotEmpty) {
      final experience = int.tryParse(experienceController.text);
      if (experience != null) {
        filtered =
            filtered.where((app) {
              return app.experienceLevel == experience;
            }).toList();
      }
    }

    return filtered;
  }

  @override
  void onClose() {
    // Dispose controllers
    searchController.dispose();
    experienceController.dispose();
    salaryController.dispose();
    super.onClose();
  }
}
