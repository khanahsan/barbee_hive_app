import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';

import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class JobController extends GetxController {
  Rx<bool> isEmployer = false.obs;
  final employerJobs = <JobData>[].obs;
  final isLoadingEmployer = false.obs;
  final errorMessageEmployer = ''.obs;

  final employeeJobs = <JobData>[].obs;
  final isLoadingEmployee = false.obs;
  final errorMessageEmployee = ''.obs;

  final searchController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();
  final RxString selectedJobType = ''.obs;
  final filteredJobs = <JobData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRole();
    fetchEmployerJobs();
    fetchEmployeeJobs();
  }

  void loadRole() {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    isEmployer.value = role == 2;
  }

  Future<void> fetchEmployerJobs() async {
    final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);
    if (userId == null) {
      errorMessageEmployer.value = 'User ID not found';
      Get.snackbar(
        'Error',
        errorMessageEmployer.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingEmployer.value = true;
    errorMessageEmployer.value = '';

    try {
      employerJobs.clear();
      final response = await AuthProvider.getJobs(userId);
      if (response.status) {
        employerJobs.assignAll(response.data);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      errorMessageEmployer.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessageEmployer.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingEmployer.value = false;
    }
  }

  Future<void> fetchEmployeeJobs() async {
    isLoadingEmployee.value = true;
    errorMessageEmployee.value = '';

    try {
      employeeJobs.clear();
      final response = await AuthProvider.getEmployeeJobs();
      if (response.status) {
        employeeJobs.assignAll(response.data);
        filteredJobs.assignAll(response.data);
        print('response.data ${response.data.length}');
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      errorMessageEmployee.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessageEmployee.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingEmployee.value = false;
    }
  }

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

    // Filter by selected skill (position)
    // if (selectedSkill.value.isNotEmpty) {
    //   filtered =
    //       filtered.where((app) {
    //         return app.applicant.skills?.name.toLowerCase() ==
    //             selectedSkill.value.toLowerCase();
    //       }).toList();
    // }

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
}
