import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/data/model/city_response.dart';
import 'package:barbee_hive_app/data/model/experience_level_response.dart';
import 'package:barbee_hive_app/data/model/gender_response.dart';
import 'package:barbee_hive_app/data/model/height_response.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/customDrawer/controller/custom_drawer_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/dashboardController.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/api/auth_provider.dart';
import '../../../data/api/profile/profile_api.dart';
import '../../../data/model/color_response.dart' as colorModel;
import '../../../data/model/state_response.dart';
import '../../../data/model/user_profile_response.dart';
import '../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';

class ProfileController extends GetxController {
  // ---------------- Rx Variables ----------------
  Rx<UserProfileResponse?> userProfile = Rx<UserProfileResponse?>(null);
  RxBool isLoading = false.obs;
  RxBool isCitiesLoading = false.obs;
  RxInt currentUserId = 0.obs;
  RxInt currentUserRole = 0.obs;
  RxString userProfileImage = ''.obs;
  RxString userCoverImage = ''.obs;
  RxString selectedDate = ''.obs;
  RxBool isEditing = false.obs;

  // Text controllers for form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final businessTaxController = TextEditingController();
  final dobController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> coverImageFile = Rx<File?>(null);

  Future<void> pickCoverPhoto() async {
    // Request permission
    // var status = await Permission.photos.request();
    //
    // if (status.isDenied) {
    //   Utilities.showSnackBar(
    //     title: "Permission Denied",
    //     message: "Gallery access is required to pick cover photo.",
    //     isSuccess: false,
    //   );
    //   return;
    // }
    //
    // if (status.isPermanentlyDenied) {
    //   openAppSettings();
    //   return;
    // }

    // Pick the image
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      coverImageFile.value = File(image.path);
    }
  }

  // Eye colors
  RxString currentEyeColorName = "".obs;
  RxInt currentEyeColorId = 0.obs;
  final RxList<colorModel.EyeColor> eyeColors = <colorModel.EyeColor>[].obs;

  // Hair colors
  RxString currentHairColorName = "".obs;
  RxInt currentHairColorId = 0.obs;
  final RxList<colorModel.HairColor> hairColors = <colorModel.HairColor>[].obs;

  // Gender, height, and skills
  RxString currentGender = "".obs;
  RxInt currentHeight = 0.obs;

  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  final RxList<Gender> genders = <Gender>[].obs;
  final RxList<Height> heights = <Height>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<City> cities = <City>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;

  RxString currentSkillName = "".obs;
  RxInt currentSkillId = 0.obs;

  RxList<String> selectedSkills = <String>[].obs;

  RxString currentCountryName = "".obs;
  RxInt currentCountryId = 0.obs;

  RxString currentStateName = "".obs;
  RxInt currentStateId = 0.obs;

  RxString currentCityName = "".obs;

  RxString currentUID = "".obs;

  // Dropdown selections
  final selectedExperience = ''.obs;

  // Resume file handling
  final selectedResumeFilePath = ''.obs;
  Rx<File?> selectedResumeFile = Rx<File?>(null);

  // Password visibility
  RxBool passwordObscure = true.obs;
  RxBool confirmPasswordObscure = true.obs;

  void pickDate() async {
    DateTime initialDate = DateTime.now();

    if (dobController.text.isNotEmpty) {
      try {
        // Replace '-' with '/' to match the expected format
        final normalizedText = dobController.text.replaceAll('-', '/');
        initialDate = DateFormat('MM-dd-yyyy').parse(normalizedText);
      } catch (e) {
        debugPrint("Error parsing DOB: $e. Using current date instead.");
        initialDate = DateTime.now();
      }
    }

    final DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final formattedDate = DateFormat('MM-dd-yyyy').format(date);
      selectedDate.value = formattedDate;
      dobController.text = formattedDate;
    }
  }

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    initController();
  }

  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    businessTaxController.dispose();
    dobController.dispose();
    super.onClose();
  }

  // ---------------- UI Actions ----------------
  void toggleEditing() {
    isEditing.value = !isEditing.value;
    debugPrint("isEditing: ${isEditing.value}");
  }

  // ---------------- Initialization ----------------
  Future<void> initController() async {
    getUserRole();
    getUserIdAndFetchProfile();
    await Future.wait([
      fetchEyeColors(),
      fetchHairColors(),
      fetchSkills(),
      fetchExperienceLevels(),
      fetchGenders(),
      fetchHeights(),
      fetchCountries(),
      fetchStates(),
    ]);
  }

  void getUserIdAndFetchProfile() async {
    final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);
    currentUserId.value = userId ?? 0;

    debugPrint("currentUserId: ${currentUserId.value}");

    if (currentUserId.value != 0) {
      await fetchUserProfile(currentUserId.value);
    } else {
      showError('Error', 'User ID not found');
    }
  }

  void getUserRole() {
    final userRole = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    currentUserRole.value = userRole ?? 0;

    debugPrint("currentUserRole: ${currentUserRole.value}");
  }

  // ---------------- Fetch Profile Data ----------------
  Future<void> fetchUserProfile(int userId) async {
    try {
      isLoading.value = true;
      final profile = await ProfileApi.getUserProfile(userId);
      userProfile.value = profile;

      userName.value = isEmployer
          ? userProfile.value?.data.employer?.businessName ?? ''
          : userProfile.value?.data.employee?.name ?? '';


      populateData();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      showError('Error', 'Failed to fetch user profile');
    } finally {
      isLoading.value = false;
    }
  }

  // Populate form fields with profile data
  void populateData() {
    final data = userProfile.value?.data;
    if (data == null) return;

    emailController.text = data.email;
    currentUID.value = data.uid;

    if (isEmployer) {
      nameController.text = data.employer?.businessName ?? '';
      // currentSkillName.value = data.employer?.skill?.name ?? '';
      // currentSkillId.value = data.employer?.skill?.id ?? 0;

      if (data.employer?.skills != null && data.employer!.skills.isNotEmpty) {
        // safe: map over non-nullable list
        selectedSkills.assignAll(data.employer!.skills.map((s) => s.name));
        currentSkillId.value =
            data.employer!.skills.first.id; // keep first for API if needed

        log("SELECTED SKILLS: $selectedSkills");
      } else {
        selectedSkills.clear();
        currentSkillId.value = 0;
      }

      currentCountryName.value = data.employer?.country?.name ?? '';
      currentCountryId.value = data.employer?.country?.id ?? 0;

      log(
        'COUNTRY NAME: ${currentCountryName.value} --- COUNTRY ID: ${currentCountryId.value}',
      );

      currentStateName.value = data.employer?.state?.name ?? '';
      currentStateId.value = data.employer?.state?.id ?? 0;
      currentCityName.value = data.employer?.city ?? '';
      currentCityName.value = data.employer?.city ?? '';

      log(
        'STATE NAME: ${currentCountryName.value} --- STATE ID: ${currentCountryId.value}',
      );

      userProfileImage.value = data.profileImage ?? '';
      userCoverImage.value = data.coverPhoto ?? '';
      countryController.text = data.employer?.country?.name ?? '';
      stateController.text = data.employer?.state?.name ?? '';
      cityController.text = data.employer?.city ?? '';
      addressController.text = data.employer?.address ?? '';
      businessTaxController.text = data.employer?.businessTaxNumber ?? '';


      if (currentStateId.value != 0) {
        fetchCities(stateId: currentStateId.value);
      }
    } else {
      // Employee details
      nameController.text = data.employee?.name ?? '';
      countryController.text = data.employee?.country?.name ?? '';
      stateController.text = data.employee?.state?.name ?? '';
      cityController.text = data.employee?.city ?? '';
      addressController.text = data.employee?.address ?? '';
      currentCityName.value = data.employee?.city ?? '';

      currentEyeColorName.value = data.employee?.eyeColor?.name ?? '';
      currentEyeColorId.value = data.employee?.eyeColor?.id ?? 0;
      selectedResumeFilePath.value = data.employee?.resumePath ?? '';

      currentHairColorName.value = data.employee?.hairColor?.name ?? '';
      currentHairColorId.value = data.employee?.hairColor?.id ?? 0;

      currentGender.value = (data.employee?.gender ?? '');
      currentHeight.value = data.employee?.height ?? 0;
      selectedExperience.value = data.employee?.experienceYears ?? '';

      // Employee skills (multi-select)
      if (data.employee?.skills != null && data.employee!.skills.isNotEmpty) {
        // safe: map over non-nullable list
        selectedSkills.assignAll(data.employee!.skills.map((s) => s.name));
        currentSkillId.value =
            data.employee!.skills.first.id; // keep first for API if needed

        log("SELECTED SKILLS: $selectedSkills");
      } else {
        selectedSkills.clear();
        currentSkillId.value = 0;
      }

      // currentSkillName.value = data.employee?.skill.name ?? '';
      // currentSkillId.value = data.employee?.skill.id ?? 0;

      currentCountryName.value = data.employee?.country?.name ?? '';
      currentCountryId.value = data.employee?.country?.id ?? 0;

      log(
        'COUNTRY NAME: ${currentCountryName.value} --- COUNTRY ID: ${currentCountryId.value}',
      );

      currentStateName.value = data.employee?.state?.name ?? '';
      currentStateId.value = data.employee?.state?.id ?? 0;

      log(
        'STATE NAME: ${currentCountryName.value} --- STATE ID: ${currentCountryId.value}',
      );

      userProfileImage.value = data.profileImage ?? '';
      userCoverImage.value = data.coverPhoto ?? '';
      dobController.text = data.employee?.dob ?? '';

      if (currentStateId.value != 0) {
        fetchCities(stateId: currentStateId.value);
      }

      debugPrint("currentGender: ${currentGender.value}");
      log("currentSkillName: ${currentSkillName.value}");
      log("currentGender: ${currentGender.value}");
      log("currentHeight: ${currentHeight.value}");
      log("cover photo: ${userCoverImage.value}");
    }
  }

  // ---------------- Getters ----------------
  bool get isEmployer => currentUserRole.value == 2;

  RxString userName = ''.obs;



  // String get currentUserSkill =>
  //     isEmployer
  //         ? userProfile.value?.data.employer?.skill?.name ?? ''
  //         : userProfile.value?.data.employee?.skill.name ?? '';

  // ---------------- Fetch Supporting Data ----------------
  Future<void> fetchEyeColors() async {
    isLoading.value = true;

    try {
      print('Fetching eye colors');
      final response = await AuthProvider.getEyeColors();
      if (response.status) {
        eyeColors.assignAll(response.data);
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      showError('Error', 'Failed to fetch eye colors');
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
        showError('Error', response.message);
      }
    } catch (e) {
      showError('Error', 'Failed to fetch hair colors');
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
        showError('Error', response.message);
      }
    } catch (e) {
      showError('Error', 'Failed to fetch skills');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGenders() async {
    isLoading.value = true;

    try {
      print('Fetching genders');
      final response = await AuthProvider.getGenders();
      if (response.status) {
        genders.assignAll(response.data);
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      showError('Error', 'Failed to genders');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHeights() async {
    isLoading.value = true;

    try {
      print('Fetching heights');
      final response = await AuthProvider.getHeights();
      if (response.status) {
        heights.assignAll(response.data);
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      showError('Error', 'Failed to heights');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;

    try {
      print('Fetching Countries');
      final response = await AuthProvider.getCountries();
      if (response.status) {
        countries.assignAll(response.data);
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      log('Failed to countries');
      showError('Error', 'Failed to countries');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStates() async {
    isLoading.value = true;

    try {
      print('Fetching States');
      final response = await AuthProvider.getStates();
      if (response.status) {
        states.assignAll(response.data);
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      log('Failed to States');

      showError('Error', 'Failed to States');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExperienceLevels() async {
    isLoading.value = true;

    try {
      print('Fetching experience levels');
      final response = await AuthProvider.getExperienceLevels();
      if (response.status) {
        experienceLevels.assignAll(response.data);
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      showError('Error', 'Failed to fetch experience levels');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCities({required int stateId}) async {
    try {
      isCitiesLoading.value = true;
      print('Fetching Cities');
      final response = await AuthProvider.getCities(stateId: stateId);
      if (response.status) {
        cities.assignAll(response.data);
        if (currentCityName.value.isNotEmpty &&
            !cities.any((c) => c.name == currentCityName.value)) {
          currentCityName.value = '';
          cityController.text = '';
        }
      } else {
        showError('Error', response.message);
      }
    } catch (e) {
      log('Failed to Cities');
      showError('Error', 'Failed to Cities');
    } finally {
      isCitiesLoading.value = false;
    }
  }

  void updateStateSelection(String? val) {
    currentStateName.value = val ?? '';
    final selected = states.firstWhereOrNull((e) => e.name == val);
    currentStateId.value = selected?.id ?? 0;

    currentCityName.value = '';
    cityController.text = '';
    cities.clear();

    if (currentStateId.value != 0) {
      fetchCities(stateId: currentStateId.value);
    }
  }

  void updateCitySelection(String? val) {
    currentCityName.value = val ?? '';
    cityController.text = currentCityName.value;
  }

  // ---------------- UI Helpers ----------------
  void showError(String title, String message) {
    Utilities.showSnackBar(title: title, message: message, isSuccess: false);
  }

  // ---------------- Update Profile ----------------
  Future<void> updateUserProfile() async {
    log("updateUserProfile called");

    // final state = states.firstWhere(
    //       (j) => (j.name ?? "") == selectedState.value,
    //   orElse: () => throw Exception("Invalid State Selected"),
    // );

    try {
      isLoading.value = true;

      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final city = cityController.text.trim();
      final address = addressController.text.trim();
      final businessTaxNumber = businessTaxController.text.trim();
      final country = countryController.text.trim();
      final state = stateController.text.trim();
      final dobText = dobController.text.trim();
      final gender = currentGender.value.toLowerCase();

      final File? profileImageFile =
          userProfileImage.value.startsWith('http')
              ? null
              : File(userProfileImage.value);

      // ========== 1️⃣ API CALL ==========
      final response = await ProfileApi.updateUserProfile(
        city: city,
        address: address.isNotEmpty ? address : null,
        businessTaxNumber:
            businessTaxNumber.isNotEmpty ? businessTaxNumber : null,
        country: currentCountryId.value.toString(),
        state: currentStateId.value.toString(),
        resume: selectedResumeFile.value,
        profileImage: profileImageFile,
        coverImage: coverImageFile.value,
        name: name,
        email: email,
        dob: dobText.isNotEmpty ? dobText : null,
        eyeColorId:
            currentEyeColorId.value == 0 ? null : currentEyeColorId.value,
        hairColorId:
            currentHairColorId.value == 0 ? null : currentHairColorId.value,
        gender: gender.isEmpty ? null : gender,
        height: currentHeight.value == 0 ? null : currentHeight.value,
        skillIds:
            selectedSkills
                .map(
                  (name) => skills.firstWhere((skill) => skill.name == name).id,
                )
                .toList(),

        // skillId: currentSkillId.value == 0 ? null : currentSkillId.value,
      );

      if (!response.status) {
        return showError("Error", "Failed to update profile");
      }

      // ========== 2️⃣ SAVE LOCALLY (PARALLEL) ==========
      final String newProfileName =
          currentUserRole.value == 2
              ? (response.data.employer?.businessName ?? '')
              : (response.data.employee?.name ?? '');

      final String newProfileImg = response.data.profileImage ?? '';

      userName.value = newProfileName;

      await Future.wait([
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userName,
          newProfileName,
        ),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.userProfileImage,
          newProfileImg,
        ),
      ]);

      // ========== 3️⃣ FIREBASE UPDATE (ONLY IF NEEDED) ==========
      if (currentUID.isNotEmpty) {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUID.value);

        await userRef.update({
          'name': name,
          'profileImage': newProfileImg,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // ========== 4️⃣ REFRESH CONTROLLERS (PARALLEL) ==========
      await Future.wait([
        Get.find<CustomDrawerController>().loadUserData(),
        Get.find<DashboardController>().fetchUserProfile(),
        Get.find<DashboardController>().getUserLocationAndFetchDashboard(),
        Get.find<ChatController>().loadUserData(),
        Get.find<JobController>().loadRole(),
      ]);

      // ========== 5️⃣ SUCCESS UI ==========
      //Get.back();
      toggleEditing();
      Utilities.showSnackBar(
        title: 'Success',
        message: response.message,
        isSuccess: true,
      );


    } catch (e) {
      debugPrint("Error updating profile: $e");
      showError("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
