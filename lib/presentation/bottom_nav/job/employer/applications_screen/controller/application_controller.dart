
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/job_application_response.dart';
import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/api/job/job_api.dart';
import '../../../../../../data/model/color_response.dart' as colorModel;




class ApplicationsController extends GetxController {

  final ageController = TextEditingController();
  final experienceController = TextEditingController();
  final searchController = TextEditingController();


  final applications = <JobApplyData>[].obs;
  final filteredApplications = <JobApplyData>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;


  final RxString selectedSkill = ''.obs;
  final RxString selectedGender = ''.obs;

  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchSkills();
    searchController.addListener(() {
      filterApplicationsByText(searchController.text);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ageController.dispose();
    experienceController.dispose();
    searchController.dispose();
  }

  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void updateSkill(String? value) {
    if (value != null) {
      selectedSkill.value = value;
    }
  }

  void updateGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
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

  Future<void> fetchApplications(int jobId, {Map<String, dynamic>? filters}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching applications for jobId: $jobId, Filters: $filters');
      final response = await JobApi.getJobApplications(jobId, filters: filters);
      print('API Response: status=${response.status}, message=${response.message}, applications');
      if (response.status) {
        applications.assignAll(response.data); // Fixed: response.data is List<JobApplicationData>
        filteredApplications.assignAll(response.data); // Update filtered list
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Fetch Applications Error: $e');
      LogUtil.logError('fetchApplications: $e');
      errorMessage.value = e.toString().contains('No internet connection')
          ? 'No internet connection. Please check your connection and try again.'
          : e.toString().replaceFirst('Exception: ', '');
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Filter applications based on text input
  void filterApplicationsByText(String query) {
    var filtered = applications.toList();

    if (query.isNotEmpty) {
      filtered = filtered.where((app) {
        final emailMatch = app.applicant.email.toLowerCase().contains(query.toLowerCase());
        final nameMatch = app.applicant.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return emailMatch || nameMatch;
      }).toList();
    }

    // Apply dialog filters on top of text filter
    filteredApplications.assignAll(applyDialogFilters(filtered));
  }

  // Apply filters from dialog
  List<JobApplyData> applyDialogFilters(List<JobApplyData> inputList) {
    var filtered = inputList;

    // Filter by selected skill (position)
    if (selectedSkill.value.isNotEmpty) {
      filtered = filtered.where((app) {
        return app.applicant.skills != null &&
            app.applicant.skills!.any(
                  (skill) => skill.name.toLowerCase() == selectedSkill.value.toLowerCase(),
            );
      }).toList();
    }


    // Filter by age
    if (ageController.text.isNotEmpty) {
      final age = int.tryParse(ageController.text);
      if (age != null) {
        filtered = filtered.where((app) {
          return app.applicant.age == age;
        }).toList();
      }
    }

    // Filter by gender
    if (selectedGender.value.isNotEmpty) {
      filtered = filtered.where((app) {
        return app.applicant.gender.toLowerCase() == selectedGender.value.toLowerCase();
      }).toList();
    }

    // Filter by experience (using years_of_experience from JobApplicationData)
    if (experienceController.text.isNotEmpty) {
      final experience = int.tryParse(experienceController.text);
      if (experience != null) {
        filtered = filtered.where((app) {
          return app.yearsOfExperience == experience;
        }).toList();
      }
    }

    return filtered;
  }

// Clear all filters
  void clearFilters() {
    selectedSkill.value = '';
    selectedGender.value = '';
    ageController.clear();
    experienceController.clear();
    searchController.clear();
    filteredApplications.assignAll(applications);
  }
}