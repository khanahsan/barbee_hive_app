import 'dart:developer';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/applied_job_response.dart';
import 'package:barbee_hive_app/data/model/color_response.dart' as colorModel;
import 'package:barbee_hive_app/data/model/experience_level_response.dart';
import 'package:barbee_hive_app/data/model/job_type_response.dart';
import 'package:barbee_hive_app/data/model/salary_type_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../data/api/job/job_api.dart';

/*class MyApplicationsController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  String? userProfileImage = '';
  final appliedJobs = <AppliedJobData>[].obs;

  final TextEditingController searchController = TextEditingController();


  /// Dropdown Selections
  RxString selectedJobRole = ''.obs;
  RxString selectedExperience = ''.obs;
  RxString selectedSalary = ''.obs;
  RxString selectedJobType = ''.obs;


  /// Dropdown Data
  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final RxList<SalaryType> salaryTypes = <SalaryType>[].obs;
  final RxList<JobType> jobTypes = <JobType>[].obs;
  final filteredJobs = <AppliedJobData>[].obs;


  @override
  void onInit() {
    super.onInit();
    userProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );
    fetchEmployeeAppliedJobs();
    fetchAllDropdowns();
  }

  Future<void> fetchEmployeeAppliedJobs() async {
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
      final response = await JobApi.getAppliedJobs(userId);
      if (response.status) {
        appliedJobs.assignAll(response.data);
        print('response $response');
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

  Future<void> fetchAllDropdowns() async {
    await Future.wait([
      _fetchSkills(),
      _fetchExperienceLevels(),
      _fetchSalaryTypes(),
      _fetchJobTypes(),
    ]);
  }

  Future<void> _fetchSkills() async {
    try {
      final res = await AuthProvider.getSkills();
      if (res.status) skills.assignAll(res.data);
    } catch (_) {}
  }

  Future<void> _fetchExperienceLevels() async {
    try {
      final res = await AuthProvider.getExperienceLevels();
      if (res.status) experienceLevels.assignAll(res.data);
    } catch (_) {}
  }

  Future<void> _fetchSalaryTypes() async {
    try {
      final res = await AuthProvider.getSalaryTypes();
      if (res.status) salaryTypes.assignAll(res.data);
    } catch (_) {}
  }

  Future<void> _fetchJobTypes() async {
    try {
      final res = await AuthProvider.getJobTypes();
      if (res.status) jobTypes.assignAll(res.data);
    } catch (_) {}
  }

  /// Filter Jobs based on search query
  void filterApplicationsByText(String query) {
    var filtered = appliedJobs.toList();

    if (query.isNotEmpty) {
      filtered = filtered.where((job) {
        final titleMatch = job.title.toLowerCase().contains(query.toLowerCase());
        final skillMatch =
        job.skills!.name.toLowerCase().contains(query.toLowerCase());
        return titleMatch || skillMatch;
      }).toList();
    }

    filteredJobs.assignAll(_applyDropdownFilters(filtered));
  }

  /// Apply dialog dropdown filters
  List<AppliedJobData> _applyDropdownFilters(List<AppliedJobData> jobs) {
    var filtered = jobs;

    if (selectedJobRole.value.isNotEmpty) {
      filtered = filtered
          .where((job) =>
      job.skills.name.toLowerCase() == selectedJobRole.value.toLowerCase())
          .toList();
    }

    if (selectedExperience.value.isNotEmpty) {
      filtered = filtered
          .where((job) =>
      job.experienceLevel.toLowerCase() ==
          selectedExperience.value.toLowerCase())
          .toList();
    }

    if (selectedSalary.value.isNotEmpty) {
      filtered = filtered
          .where((job) =>
      job.salaryRange.type.name.toLowerCase() ==
          selectedSalary.value.toLowerCase())
          .toList();
    }

    if (selectedJobType.value.isNotEmpty) {
      filtered = filtered
          .where((job) =>
      job.jobType.name.toLowerCase() ==
          selectedJobType.value.toLowerCase())
          .toList();
    }

    return filtered;
  }

  /// Apply all filters
  void applyFilters() {
    // filterApplicationsByText(searchController.text);
    filteredJobs.assignAll(_applyDropdownFilters(filteredJobs));

    log('Filters Applied: '
        'JobRole=${selectedJobRole.value}, '
        'Experience=${selectedExperience.value}, '
        'Salary=${selectedSalary.value}, '
        'JobType=${selectedJobType.value}');
  }

  /// Clear all filters
  void clearFilters() {
    selectedJobRole.value = '';
    selectedExperience.value = '';
    selectedSalary.value = '';
    selectedJobType.value = '';
    searchController.clear();
    filteredJobs.assignAll(appliedJobs);
  }
}*/

class MyApplicationsController extends GetxController {
  /// Loading & Error
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// User Data
  String? userProfileImage = '';

  /// All Jobs from API
  final appliedJobs = <AppliedJobData>[].obs;

  /// Filtered Jobs (search + dropdowns)
  final filteredJobs = <AppliedJobData>[].obs;

  /// Search text controller
  final TextEditingController searchController = TextEditingController();

  /// Dropdown selections
  final RxString selectedJobRole = ''.obs;
  final RxString selectedExperience = ''.obs;
  final RxString selectedSalary = ''.obs;
  final RxString selectedJobType = ''.obs;

  /// Dropdown Data
  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final RxList<SalaryType> salaryTypes = <SalaryType>[].obs;
  final RxList<JobType> jobTypes = <JobType>[].obs;

  @override
  void onInit() {
    super.onInit();

    userProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );

    fetchEmployeeAppliedJobs();
    fetchAllDropdowns();
  }

  // ---------------------------------------------------------
  // FETCH JOB APPLICATIONS
  // ---------------------------------------------------------

  Future<void> fetchEmployeeAppliedJobs() async {

    log('fetchEmployeeAppliedJobs called');
    final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);

    if (userId == null) {
      _showError("User ID not found");
      return;
    }

    isLoading.value = true;

    try {
      final response = await JobApi.getAppliedJobs(userId);

      if (response.status) {
        appliedJobs.assignAll(response.data);
        filteredJobs.assignAll(response.data); // initial load
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------
  // FETCH DROPDOWN DATA
  // ---------------------------------------------------------

  Future<void> fetchAllDropdowns() async {
    log('fetchAllDropdowns called');

    await Future.wait([
      _fetchSkills(),
      _fetchExperienceLevels(),
      _fetchSalaryTypes(),
      _fetchJobTypes(),
    ]);
  }

  Future<void> _fetchSkills() async {
    try {
      final res = await AuthProvider.getSkills();
      if (res.status) skills.assignAll(res.data);
    } catch (_) {}
  }

  Future<void> _fetchExperienceLevels() async {
    try {
      final res = await AuthProvider.getExperienceLevels();
      if (res.status) experienceLevels.assignAll(res.data);
    } catch (_) {}
  }

  Future<void> _fetchSalaryTypes() async {
    try {
      final res = await AuthProvider.getSalaryTypes();
      if (res.status) salaryTypes.assignAll(res.data);
    } catch (_) {}
  }

  Future<void> _fetchJobTypes() async {
    try {
      final res = await AuthProvider.getJobTypes();
      if (res.status) jobTypes.assignAll(res.data);
    } catch (_) {}
  }

  // ---------------------------------------------------------
  // FILTER LOGIC (Search + Dropdowns)
  // ---------------------------------------------------------

  /// Re-run filter whenever text or dropdown changes
  void runAllFilters() {
    List<AppliedJobData> list = appliedJobs.toList();

    // Search filter
    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list =
          list.where((job) {
            return job.title.toLowerCase().contains(query) ||
                job.skills.name.toLowerCase().contains(query);
          }).toList();
    }

    // Dropdown filters
    if (selectedJobRole.isNotEmpty) {
      list =
          list
              .where(
                (job) =>
                    job.skills.name.toLowerCase() ==
                    selectedJobRole.value.toLowerCase(),
              )
              .toList();
    }

    if (selectedExperience.isNotEmpty) {
      list =
          list
              .where(
                (job) =>
                    job.experienceLevel.toLowerCase() ==
                    selectedExperience.value.toLowerCase(),
              )
              .toList();
    }

    if (selectedSalary.isNotEmpty) {
      list =
          list
              .where(
                (job) =>
                    job.salaryRange.type.name.toLowerCase() ==
                    selectedSalary.value.toLowerCase(),
              )
              .toList();
    }

    if (selectedJobType.isNotEmpty) {
      list =
          list
              .where(
                (job) =>
                    job.jobType.name.toLowerCase() ==
                    selectedJobType.value.toLowerCase(),
              )
              .toList();
    }

    filteredJobs.assignAll(list);

    log(
      "Filters Applied -> "
      "Search=$query, "
      "JobRole=${selectedJobRole.value}, "
      "Experience=${selectedExperience.value}, "
      "Salary=${selectedSalary.value}, "
      "JobType=${selectedJobType.value}",
    );
  }

  // Dialog applies dropdown filters
  void applyFilters() => runAllFilters();

  // ---------------------------------------------------------
  // CLEAR ALL FILTERS
  // ---------------------------------------------------------

  void clearFilters() {
    selectedJobRole.value = '';
    selectedExperience.value = '';
    selectedSalary.value = '';
    selectedJobType.value = '';
    searchController.clear();

    filteredJobs.assignAll(appliedJobs);
  }

  // ---------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------

  void _showError(String msg) {
    errorMessage.value = msg;
    Utilities.showSnackBar(title: "Error", message: msg, isSuccess: false);
  }
}
