

import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/api/auth_provider.dart';
import '../../../../../data/api/job/job_api.dart';
import '../../../../../data/model/experience_level_response.dart';
import '../../../../../data/model/job_type_response.dart';
import '../../controller/job_controller.dart';

class ApplyScreenController extends GetxController {
  final yearsOfExperience = TextEditingController();
  final expectedSalary = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Experience Levels
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final selectedExperienceLevel = ''.obs;

  void updateExperienceLevel(String? value) =>
      selectedExperienceLevel.value = value ?? '';

  // Job Types
  final RxList<JobType> jobTypes = <JobType>[].obs;
  final selectedJobType = ''.obs;

  void updateJobType(String? value) => selectedJobType.value = value ?? '';

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAllDropdowns();
  }

  @override
  void onClose() {
    yearsOfExperience.dispose();
    expectedSalary.dispose();
    super.onClose();
  }

  Future<void> fetchAllDropdowns() async {
    isLoading.value = true;
    try {
      await Future.wait([_fetchExperienceLevels(), _fetchJobTypes()]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchExperienceLevels() async {
    try {
      final response = await AuthProvider.getExperienceLevels();
      if (response.status) experienceLevels.assignAll(response.data);
    } catch (e) {
      log('Failed to fetch experience levels: $e');
    }
  }

  Future<void> _fetchJobTypes() async {
    try {
      final response = await AuthProvider.getJobTypes();
      if (response.status) jobTypes.assignAll(response.data);
    } catch (e) {
      log('Failed to fetch job types: $e');
    }
  }

  Future<void> applyForJob(int jobId, context) async {
    final years = int.tryParse(yearsOfExperience.text);
    final salary = double.tryParse(expectedSalary.text);

    if (!_validateInputs(years, salary)) return;

    final jobType = _getSelectedJobType();
    final jobExperience = _getSelectedExperienceLevel();

    isLoading.value = true;
    errorMessage.value = '';

    try {
      log('Applying for jobId: $jobId');
      final response = await JobApi.applyJob(
        jobId: jobId,
        experienceLevel: jobExperience.id,
        yearsOfExperience: years!,
        jobType: jobType.id,
        expectedSalary: salary!.toStringAsFixed(2),
      );

      log('Apply job response: ${response.message}');

      if (response.status) {
        final controller = Get.find<JobController>();

        controller.fetchEmployeeJobs();

        Get.back();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const CustomDialog(
            title: 'Success',
            subTitle: 'Your Job Application Has Been Submitted',
          ),
        );
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs(int? years, double? salary) {
    if (years == null || years <= 0) {
      _showError('Invalid years of experience');
      return false;
    }
    if (salary == null || salary <= 0) {
      _showError('Invalid expected salary');
      return false;
    }
    if (selectedExperienceLevel.value.isEmpty) {
      _showError('Please select an experience level');
      return false;
    }
    if (selectedJobType.value.isEmpty) {
      _showError('Please select a job type');
      return false;
    }
    return true;
  }

  JobType _getSelectedJobType() {
    return jobTypes.firstWhere(
      (type) => type.name == selectedJobType.value,
      orElse: () => throw Exception('Invalid job type selected'),
    );
  }

  ExperienceLevel _getSelectedExperienceLevel() {
    return experienceLevels.firstWhere(
      (exp) => exp.name == selectedExperienceLevel.value,
      orElse: () => throw Exception('Invalid experience level selected'),
    );
  }

  void _showError(String message) {
    errorMessage.value = message;

    log('${errorMessage.value}');
    Utilities.showSnackBar(title: 'Error', message: message, isSuccess: false);
  }
}
