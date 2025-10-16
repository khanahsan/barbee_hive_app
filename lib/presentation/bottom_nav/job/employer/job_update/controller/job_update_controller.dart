import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../data/model/color_response.dart' as colorModel;

class JobUpdateController extends GetxController {
  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController experienceLevelController =
      TextEditingController();
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

  late JobData job; 

  @override
  void onInit() {
    super.onInit();
    fetchSkills();

    if (Get.arguments != null && Get.arguments is JobData) {
      job = Get.arguments as JobData;

      /// Set controllers text with job data
      jobRoleController.text = job.title;
      experienceLevelController.text = job.experienceLevel;
      salaryController.text = job.salaryRange.min;
      countryController.text = job.country;
      stateController.text = job.state;
      cityController.text = job.city;
      recruiterController.text = job.recruiterName ?? "";
      jobDesController.text = job.description;

      selectedJobType.value = job.jobType;
      selectedSkill.value = job.skills?.name ?? "";
    }
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

  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> showUpdateDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Congratulations",
          subTitle: "Your Job Application Has Been Updated",
        );
      },
    );
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

  Future<void> updateJob(BuildContext context) async {
    if (jobRoleController.text.isEmpty ||
        jobDesController.text.isEmpty ||
        experienceLevelController.text.isEmpty ||
        salaryController.text.isEmpty ||
        selectedJobType.value.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        cityController.text.isEmpty ||
        recruiterController.text.isEmpty ||
        selectedSkill.value.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // if (selectedImage.value == null) {
    //   Get.snackbar(
    //     'Error',
    //     'Please select an image',
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }
    final userSkill = skills.firstWhere(
      (skill) => skill.name == selectedSkill.value,
      orElse: () => throw Exception('Invalid eye color'),
    );

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await AuthProvider.updateJob(
        id: job.id,
        title: jobRoleController.text,
        description: jobDesController.text,
        experienceLevel: experienceLevelController.text,
        minSalary: salaryController.text,
        maxSalary: salaryController.text,
        jobType:
            selectedJobType.value, // Assuming selectedJobType.value was a typo
        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        recruiterName: recruiterController.text,
        //noOfDays: int.parse(noOfDaysController.text),
        noOfDays: 2,
        image: selectedImage.value, // Pass selected image
        skillId: userSkill.id,
      );

      if (response.status == true) {
        print('Status is true, showing dialog');
        await showUpdateDialog(context); // Wait for dialog to close
        print('Dialog closed, navigating to SIGN_IN_VIEW');
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Job Post Error: $e');
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
  
 
