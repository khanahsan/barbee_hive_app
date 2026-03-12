/*
import 'dart:developer';

import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/data/model/job_type_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../data/model/color_response.dart' as colorModel;
import '../../../../../../data/model/salary_type_response.dart';
import '../../../../data/api/auth_provider.dart';
import '../../../../data/api/job/job_api.dart';
import '../../../../data/model/experience_level_response.dart';
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
  final employerJobs = <JobListData>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Employee Jobs List
  final employeeJobs = <JobListData>[].obs;

  final RxString selectedJobType = ''.obs;
  final filteredJobs = <JobListData>[].obs;

  RxString selectedJobRole = ''.obs;
  RxString selectedExperience = ''.obs;
  RxString selectedSalary = ''.obs;

  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final RxList<SalaryType> salaryTypes = <SalaryType>[].obs;
  final RxList<JobType> jobTypes = <JobType>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRoleAsync();
    fetchAllDropdowns();
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
      Utilities.showSnackBar(
        title: 'Error',
        message: errorMessage.value,
        isSuccess: false,
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

      Utilities.showSnackBar(
        title: 'Error',
        message: errorMessage.value,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilters() {
    selectedJobRole.value = '';
    selectedExperience.value = '';
    selectedSalary.value = '';
    selectedJobType.value = '';
    searchController.clear();

    filteredJobs.assignAll(employeeJobs);
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

  List<JobListData> applyDialogFilters(List<JobListData> inputList) {
    var filtered = inputList;

    // Filter by Job Role (Skill)
    if (selectedJobRole.value.isNotEmpty) {
      filtered =
          filtered.where((job) {
            return job.skills.name.toLowerCase() ==
                selectedJobRole.value.toLowerCase();
          }).toList();
    }

    // Filter by Experience Level
    if (selectedExperience.value.isNotEmpty) {
      filtered =
          filtered.where((job) {
            return job.experienceLevel.toLowerCase() ==
                selectedExperience.value.toLowerCase();
          }).toList();
    }

    // Filter by Salary Type (Hourly / Weekly / Monthly)
    if (selectedSalary.value.isNotEmpty) {
      filtered =
          filtered.where((job) {
            return job.salaryRange.type.name.toLowerCase() ==
                selectedSalary.value.toLowerCase();
          }).toList();
    }

    // Filter by Job Type (Full-time / Part-time / Contractual)
    if (selectedJobType.value.isNotEmpty) {
      filtered =
          filtered.where((job) {
            return job.jobType.name.toLowerCase() ==
                selectedJobType.value.toLowerCase();
          }).toList();
    }

    return filtered;
  }

  // Apply filters function
  void applyFilters() {
    // Filter the employeeJobs list based on search text first
    filterApplicationsByText(searchController.text);

    // Apply the dropdown filters
    filteredJobs.assignAll(applyDialogFilters(filteredJobs));

    print(
      'Filters Applied: JobRole=${selectedJobRole.value}, Experience=${selectedExperience.value}, Salary=${selectedSalary.value}, JobType=${selectedJobType.value}',
    );
  }

  Future<void> fetchAllDropdowns() async {
    await Future.wait([
      fetchSkills(),
      fetchExperienceLevels(),
      fetchSalaryTypes(),
      fetchJobTypes(),
    ]);
  }

  Future<void> fetchSkills() async {
    try {
      final response = await AuthProvider.getSkills();
      if (response.status) skills.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchExperienceLevels() async {
    try {
      final response = await AuthProvider.getExperienceLevels();
      if (response.status) experienceLevels.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchSalaryTypes() async {
    try {
      final response = await AuthProvider.getSalaryTypes();
      if (response.status) salaryTypes.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchJobTypes() async {
    try {
      final response = await AuthProvider.getJobTypes();
      if (response.status) jobTypes.assignAll(response.data);
    } catch (_) {}
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
*/

import 'dart:developer';

import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/api/auth_provider.dart';
import '../../../../data/api/job/job_api.dart';

class JobController extends GetxController {
  /// Text Controllers
  final searchController = TextEditingController();

  /// State Variables
  RxBool isEmployer = false.obs;
  Rx<String?> userProfileImage = ''.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  bool isScreenLoaded = false;

  /// Dropdown Selections
  RxString selectedJobRole = ''.obs;
  RxString selectedExperience = ''.obs;
  RxString selectedSalary = ''.obs;
  RxString selectedJobType = ''.obs;

  /// Jobs
  final employerJobs = <JobListData>[].obs;
  final employeeJobs = <JobListData>[].obs;
  final filteredJobs = <JobListData>[].obs;

  /// Dropdown Data
  final RxList<DropdownMenuItem<String>> skills =
      <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> experienceLevels =
      <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> salaryTypes =
      <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> jobTypes =
      <DropdownMenuItem<String>>[].obs;

  @override
  void onInit() {
    super.onInit();

    Future.wait([loadRole(), loadUserProfile(), fetchDropdownData()]);

    fetchDropdownData();
    loadScreen();

    print("JOB CONTROLLER :: ");
  }

  loadScreen() async {
    await Future.delayed(Duration(seconds: 3));
    isScreenLoaded = true;
  }

  /// Load user profile
  Future<void> loadUserProfile() async {
    userProfileImage.value = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );
  }

  /// Load user role
  Future<void> loadRole() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    isEmployer.value = role == 2;

    if (isEmployer.value) {
      await fetchEmployerJobs();
    } else {
      await fetchEmployeeJobs();
    }
  }

  /// Fetch Employer Jobs
  Future<void> fetchEmployerJobs() async {
    log('Fetching Employer Jobs...');
    final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);

    if (userId == null) return _showError('User ID not found');

    _startLoading();
    try {
      final response = await JobApi.getJobs(userId);
      if (response.status) {
        employerJobs.assignAll(response.data);
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  /// Fetch Employee Jobs
  Future<void> fetchEmployeeJobs() async {
    log('Fetching Employee Jobs...');
    _startLoading();
    try {
      final response = await JobApi.getEmployeeJobs();
      if (response.status) {
        employeeJobs.assignAll(response.data);
        filteredJobs.assignAll(response.data);
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      _stopLoading();
    }
  }

  /// Filter Jobs based on search query
  void filterApplicationsByText(String query) {
    var filtered = employeeJobs.toList();

    if (query.isNotEmpty) {
      filtered =
          filtered.where((job) {
            final titleMatch = job.title.toLowerCase().contains(
              query.toLowerCase(),
            );
            final skillMatch = job.skills!.name.toLowerCase().contains(
              query.toLowerCase(),
            );
            return titleMatch || skillMatch;
          }).toList();
    }

    filteredJobs.assignAll(_applyDropdownFilters(filtered));
  }

  /// Apply dialog dropdown filters
  List<JobListData> _applyDropdownFilters(List<JobListData> jobs) {
    var filtered = jobs;

    if (selectedJobRole.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (job) =>
                    job.skills.id.toString() ==
                    selectedJobRole.value.toLowerCase(),
              )
              .toList();
    }

    if (selectedExperience.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (job) =>
                    job.experienceLevel.toLowerCase() ==
                    selectedExperience.value.toLowerCase(),
              )
              .toList();
    }

    if (selectedSalary.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (job) =>
                    job.salaryRange.type.name.toLowerCase() ==
                    selectedSalary.value.toLowerCase(),
              )
              .toList();
    }

    if (selectedJobType.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (job) =>
                    job.jobType.name.toLowerCase() ==
                    selectedJobType.value.toLowerCase(),
              )
              .toList();
    }

    return filtered;
  }

  /// Apply all filters
  void applyFilters() {
    filterApplicationsByText(searchController.text);
    filteredJobs.assignAll(_applyDropdownFilters(filteredJobs));

    log(
      'Filters Applied: '
      'JobRole=${selectedJobRole.value}, '
      'Experience=${selectedExperience.value}, '
      'Salary=${selectedSalary.value}, '
      'JobType=${selectedJobType.value}',
    );
  }

  /// Clear all filters
  void clearFilters() {
    selectedJobRole.value = '';
    selectedExperience.value = '';
    selectedSalary.value = '';
    selectedJobType.value = '';
    searchController.clear();
    filteredJobs.assignAll(employeeJobs);
  }

  Future<void> fetchDropdownData() async {
    try {
      if (!isEmployer.value) {
        final response = await AuthProvider.getDashboardDropdowns();

        if (response.status) {
          skills.assignAll(
            response.data.skills
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name),
                  ),
                )
                .toList(),
          );

          experienceLevels.assignAll(
            response.data.experienceLevels
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name),
                  ),
                )
                .toList(),
          );

          salaryTypes.assignAll(
            response.data.salaryTypes
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name),
                  ),
                )
                .toList(),
          );

          jobTypes.assignAll(
            response.data.jobTypes
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name),
                  ),
                )
                .toList(),
          );
        }
      }
    } catch (e) {
      log('Error fetching dropdown data: $e');
      Utilities.showSnackBar(
        title: "Error",
        message: "Failed to load filter options",
        isSuccess: false,
      );
    }
  }

  /// Loading helpers
  void _startLoading() => isLoading.value = true;

  void _stopLoading() => isLoading.value = false;

  void _showError(String message) {
    errorMessage.value = message.replaceFirst('Exception: ', '');
    Utilities.showSnackBar(
      title: 'Error',
      message: errorMessage.value,
      isSuccess: false,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
