import 'dart:io';

import 'package:barbee_hive_app/data/api/profile/profile_api.dart';
import 'package:barbee_hive_app/data/model/color_response.dart' as colorModel;
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/api/auth_provider.dart';
import '../../../data/model/user_profile_response.dart';

class ProfileController extends GetxController {
  Rx<UserProfileResponse?> userProfile = Rx<UserProfileResponse?>(null);
  RxBool isLoading = false.obs;
  RxInt currentUserId = 0.obs;
  RxInt currentUserRole = 0.obs;
  RxString userProfileImage = ''.obs;

  RxBool isEditing = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final dobController = TextEditingController();

  RxString currentEyeColorName = "".obs;
  RxInt currentEyeColorId = 0.obs;
  final RxList<colorModel.EyeColor> eyeColors = <colorModel.EyeColor>[].obs;

  RxString currentHairColorName = "".obs;
  RxInt currentHairColorId = 0.obs;
  final RxList<colorModel.HairColor> hairColors = <colorModel.HairColor>[].obs;

  RxString currentGender = "".obs;
  RxInt currentHeight = 0.obs;

  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  RxString currentSkillName = "".obs;
  RxInt currentSkillId = 0.obs;

  final experienceList = ["Fresher", "1-2 Years", "3-5 Years", "5+ Years"];
  final genderList = ["Male", "Female"];
  final heightList = [140, 150, 160];
  final selectedExperience = ''.obs;

  final selectedResumeFilePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initController();
    // getUserIdAndFetchProfile();
    // getUserRole();
    // fetchEyeColors();
    // fetchHairColors();
  }


  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    dobController.dispose();
    super.onClose();
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    debugPrint("isEditing.value ${isEditing.value}");
  }

  Future<void> initController() async {
    getUserRole();
    getUserIdAndFetchProfile();
    await Future.wait([fetchEyeColors(), fetchHairColors(), fetchSkills()]);
  }

  void getUserIdAndFetchProfile() async {
    final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);
    currentUserId.value = userId ?? 0;

    debugPrint("currentUserId ${currentUserId.value}");

    if (currentUserId.value != 0) {
      await fetchUserProfile(currentUserId.value);
    } else {
      Get.snackbar('Error', 'User ID not found in Shared Preferences');
    }
  }

  Future<void> fetchUserProfile(int userId) async {
    try {
      isLoading.value = true;
      final profile = await ProfileApi.getUserProfile(userId);
      userProfile.value = profile;

      debugPrint("userProfile.value ${userProfile.value}");

      populateData();
    } catch (e) {
      debugPrint('Error, Failed to fetch user profile: $e');
      Get.snackbar('Error', 'Failed to fetch user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void getUserRole() {
    final userRole = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);

    currentUserRole.value = userRole ?? 0;

    debugPrint("currentUserRole.value ${currentUserRole.value}");
  }

  void populateData() {
    final data = userProfile.value?.data;
    if (data != null) {
      if (isEmployer) {
        nameController.text = data.employer?.businessName ?? '';
      } else {
        nameController.text = data.employee?.name ?? '';
        currentEyeColorName.value = data.employee?.eyeColor?.name ?? '';
        currentEyeColorId.value = data.employee?.eyeColor?.id ?? 0;
        currentHairColorName.value = data.employee?.hairColor?.name ?? '';
        currentHairColorId.value = data.employee?.hairColor?.id ?? 0;
        currentGender.value =
            (data.employee?.gender ?? '').capitalizeFirst ?? '';
        currentHeight.value = data.employee?.height ?? 0;
        currentSkillName.value = data.employee?.skill.name ?? '';
        currentSkillId.value = data.employee?.skill.id ?? 0;
        userProfileImage.value = data.profileImage ?? '';
        final rawDob = data.employee?.dob;
        if (rawDob != null && rawDob.isNotEmpty) {
          try {
            final inputFormat = DateFormat('MM-dd-yyyy');
            final outputFormat = DateFormat('MM/dd/yyyy');
            final parsedDob = inputFormat.parse(rawDob);
            final formattedDob = outputFormat.format(parsedDob);
            dobController.text = formattedDob;
          } catch (e) {
            debugPrint('Invalid DOB format: $rawDob');
          }
        }

        debugPrint("currentGender.value ${currentGender.value}");
      }
      emailController.text = data.email ?? '';
    }
  }

  bool get isEmployer => currentUserRole.value == 2;

  String get userName =>
      isEmployer
          ? userProfile.value?.data.employer?.businessName ?? ''
          : userProfile.value?.data.employee?.name ?? '';

  String get currentUserSkill =>
      isEmployer
          ? userProfile.value?.data.employer?.skill.name ?? ''
          : userProfile.value?.data.employee?.skill.name ?? '';

  Future<void> fetchEyeColors() async {
    isLoading.value = true;

    try {
      print('Fetching eye colors');
      final response = await AuthProvider.getEyeColors();
      if (response.status) {
        // eyeColors.assignAll(response.data.cast<EyeColor>());
        eyeColors.assignAll(response.data);
      } else {
        debugPrint(response.message);
        showErrorSnackbar('Error', 'Failed to fetch eye colors');
      }
    } catch (e) {
      print('Eye Colors Error: $e');
      debugPrint('Failed to fetch eye colors');
      showErrorSnackbar('Error', 'Failed to fetch eye colors');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHairColors() async {
    isLoading.value = true;

    try {
      print('Fetching hair colors');
      final response = await AuthProvider.getHairColors();
      if (response.status) {
        hairColors.assignAll(response.data);
      } else {
        debugPrint(response.message);
        showErrorSnackbar('Error', 'Failed to fetch hair colors');
      }
    } catch (e) {
      print('Hair Colors Error: $e');
      debugPrint('Failed to fetch hair colors');
      showErrorSnackbar('Error', 'Failed to fetch hair colors');
    } finally {
      isLoading.value = false;
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

  void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> updateUserProfile() async {
    try {
      isLoading.value = true;

      final response = await ProfileApi.updateUserProfile(
        city: "Los Angeles",
        country: "US",
        state: "CA",
        resume:
            selectedResumeFilePath.isNotEmpty
                ? File(selectedResumeFilePath.value)
                : null,

        name: nameController.text.trim(),
        email: emailController.text.trim(),
        dob:
            dobController.text.trim().isNotEmpty
                ? dobController.text.trim()
                : null,
        eyeColorId:
            currentEyeColorId.value != 0 ? currentEyeColorId.value : null,
        hairColorId:
            currentHairColorId.value != 0 ? currentHairColorId.value : null,
        gender:
            currentGender.value.isNotEmpty
                ? currentGender.value.toLowerCase()
                : null,
        height: currentHeight.value != 0 ? currentHeight.value : null,
        skillId: currentSkillId.value != 0 ? currentSkillId.value : null,
      );

      debugPrint("response.message ${response.message}");

      if (response.status) {
        Get.snackbar('Success', 'Profile updated successfully');
        toggleEditing(); // exit edit mode
        await fetchUserProfile(currentUserId.value); // refresh profile
      } else {
        showErrorSnackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      showErrorSnackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
