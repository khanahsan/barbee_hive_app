import 'dart:developer';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/profile/profile_api.dart';
import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/data/model/dropdown_response.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../data/api/notifications/notifications_api.dart';
import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/location_service.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class DashboardController extends GetxController {
  final RxList<User> employees = <User>[].obs; // Role 3 (Hive) - Displayed list
  final RxList<User> employers = <User>[].obs; // Role 2 (B2B) - Displayed list
  final RxList<User> allEmployees = <User>[].obs; // All employees (unfiltered)
  final RxList<User> allEmployers = <User>[].obs; // All employers (unfiltered)
  final RxBool isLoading = false.obs;
  final RxInt count = 0.obs;
  final RxString errorMessage = ''.obs;
  RxString userProfileImage = ''.obs;
  RxString userName = ''.obs;
  RxString fcmToken = ''.obs;
  RxString testToken = ''.obs;
  RxInt userID = 0.obs;

  RxDouble currentLatitude = 0.0.obs;
  RxDouble currentLongitude = 0.0.obs;

  var isBannerLoaded = false.obs;
  BannerAd? bannerAd;

  // Dropdown lists
  final RxList<DropdownMenuItem<String>> jobList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> positionList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> minAgeList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> maxAgeList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> genderList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> heightList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> eyeColorList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> hairColorList = <DropdownMenuItem<String>>[].obs;
  final RxList<DropdownMenuItem<String>> skillList = <DropdownMenuItem<String>>[].obs;

  // Selected values
  final Rx<String?> selectedJob = Rx<String?>(null);
  final Rx<String?> selectedPosition = Rx<String?>(null);
  final Rx<String?> selectedMinAge = Rx<String?>(null);
  final Rx<String?> selectedMaxAge = Rx<String?>(null);
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<String?> selectedHeight = Rx<String?>(null);
  final Rx<String?> selectedEyeColor = Rx<String?>(null);
  final Rx<String?> selectedHairColor = Rx<String?>(null);
  final Rx<String?> selectedSkill = Rx<String?>(null);



  @override
  void onInit() {
    super.onInit();
    // fetchDashboardUsers();
    getUnreadCount();
    getUserLocationAndFetchDashboard();
    loadBannerAd();
    AdsHelper().loadInterstitialAd();
    fetchDropdownData();
    // loadUserData();
    fetchUserProfile();
  }

  getUnreadCount() async {
    count.value =  await NotificationsApi.getUnreadCount();
  }



  Future<void> fetchUserProfile() async {
    try {
      final userId = SharedPreferenceHelper.getInt(SharedPrefKeys.userId) ?? 0;
      if (userId == 0) return;

      final profile = await ProfileApi.getUserProfile(userId);
      userProfileImage.value = profile.data.profileImage ?? '';

      log("USER PROFILE PATH: ${userProfileImage.value}");
      userName.value = profile.data.role == 2
          ? profile.data.employer?.businessName ?? ''
          : profile.data.employee?.name ?? '';
    } catch (e) {
      log('Error fetching user profile: $e');
    }
  }

  // Future<void> loadUserData() async {
  //   userProfileImage.value =
  //       SharedPreferenceHelper.getString(SharedPrefKeys.userProfileImage) ?? '';
  //
  //   fcmToken.value =
  //       SharedPreferenceHelper.getString(SharedPrefKeys.fcmToken) ?? '';
  //
  //   testToken.value =
  //       SharedPreferenceHelper.getString(SharedPrefKeys.testToken) ?? '';
  //
  //   userID.value =
  //       SharedPreferenceHelper.getInt(SharedPrefKeys.userId) ?? 0;
  // }

  void loadBannerAd() {
    AdsHelper().loadBannerAd(
      onAdLoaded: (ad) {
        bannerAd = ad;
        isBannerLoaded.value = true;

        log('✅ Banner ad loaded successfully.');
      },
      onAdFailed: () {
        isBannerLoaded.value = false;
        log('❌ Failed to load banner ad.');
      },
    );
  }

  Future<void> getUserLocationAndFetchDashboard() async {
    isLoading.value = true;

    try {
      final position = await LocationService.determinePosition();

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;

      print('Lat: ${position.latitude}, Lng: ${position.longitude}');

      await fetchDashboardUsers(); // ✅ Fetch users after getting location
    } catch (e) {
      print('Location error: $e');
      Utilities.showSnackBar(
        title: "Location Error",
        message: "Could not get current location.",
        isSuccess: false,
      );
    }
  }

  Future<void> fetchDashboardUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      employers.clear();
      print('Fetching dashboard users');

      log("LATITUDE: ${currentLatitude.value.toString()}");
      log("LONGITUDE: ${currentLongitude.value.toString()}");

      final response = await AuthProvider.getDashboardUsers(
        currentLatitude: currentLatitude.value.toString(),
        currentLongitude: currentLongitude.value.toString(),
      );

      // Store all users (unfiltered)
      allEmployees.assignAll(response.data.employees);
      allEmployers.assignAll(response.data.employers);

      // Display all users initially
      employees.assignAll(response.data.employees); // Role 3 (Hive)
      employers.assignAll(response.data.employers); // Role 2 (B2B)

      log('Total Employees: ${employees.length}');
      log('Total Employers: ${employers.length}');
      employers.asMap().forEach((index, e) {
        log(
          '[$index] Business: ${e.employer?.businessName ?? "N/A"} | Email: ${e.email}',
        );
      });
    } catch (e) {
      print('Dashboard Error: $e');
      errorMessage.value = e.toString().replaceFirst(
        'Exception: GET request error: Exception: ',
        '',
      );
      errorMessage.value =
          errorMessage.value.startsWith('Exception: ')
              ? errorMessage.value.replaceFirst('Exception: ', '')
              : errorMessage.value;
      Utilities.showSnackBar(
        title: "Error",
        message: errorMessage.value,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void trackProfileView() {
    AdsHelper().trackProfileView();
  }

  Future<void> fetchDropdownData() async {
    try {
      log('Fetching dropdown data...');
      final response = await AuthProvider.getDashboardDropdowns();

      if (response.status) {
        // Convert job types to dropdown items
        jobList.assignAll(
          response.data.jobTypes.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        // Convert experience levels to dropdown items (for positions)
        positionList.assignAll(
          response.data.experienceLevels.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        // Convert skills to dropdown items
        skillList.assignAll(
          response.data.skills.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        // Generate age lists (18-65)
        final ageList = List.generate(48, (index) => (18 + index).toString());
        minAgeList.assignAll(
          ageList.map(
            (age) => DropdownMenuItem<String>(
              value: age,
              child: Text(age),
            ),
          ).toList(),
        );
        maxAgeList.assignAll(
          ageList.map(
            (age) => DropdownMenuItem<String>(
              value: age,
              child: Text(age),
            ),
          ).toList(),
        );

        // Convert genders to dropdown items
        genderList.assignAll(
          response.data.genders.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        // Convert heights to dropdown items
        heightList.assignAll(
          response.data.heights.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        // Convert eye colors to dropdown items
        eyeColorList.assignAll(
          response.data.eyeColors.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        // Convert hair colors to dropdown items
        hairColorList.assignAll(
          response.data.hairColors.map(
            (item) => DropdownMenuItem<String>(
              value: item.id.toString(),
              child: Text(item.name),
            ),
          ).toList(),
        );

        log('Dropdown data fetched successfully');
        log('Job Types: ${jobList.length}');
        log('Positions: ${positionList.length}');
        log('Skills: ${skillList.length}');
        log('Genders: ${genderList.length}');
        log('Heights: ${heightList.length}');
        log('Eye Colors: ${eyeColorList.length}');
        log('Hair Colors: ${hairColorList.length}');
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

  void applyFilters() {
    log('Applying filters...');
    log('Selected Job: ${selectedJob.value}');
    log('Selected Position: ${selectedPosition.value}');
    log('Selected Min Age: ${selectedMinAge.value}');
    log('Selected Max Age: ${selectedMaxAge.value}');
    log('Selected Gender: ${selectedGender.value}');
    log('Selected Height: ${selectedHeight.value}');
    log('Selected Eye Color: ${selectedEyeColor.value}');
    log('Selected Hair Color: ${selectedHairColor.value}');
    log('Selected Skill: ${selectedSkill.value}');

    // Filter employees based on selected criteria
    List<User> filteredEmployees = allEmployees.where((user) {
      if (user.employee == null) return false;

      final employee = user.employee!;

      // Filter by gender
      if (selectedGender.value != null && selectedGender.value!.isNotEmpty) {
        if (employee.gender.toLowerCase() != selectedGender.value!.toLowerCase()) {
          return false;
        }
      }

      // Filter by height
      if (selectedHeight.value != null && selectedHeight.value!.isNotEmpty) {
        final selectedHeightId = int.tryParse(selectedHeight.value!);
        if (selectedHeightId != null && employee.height != selectedHeightId) {
          return false;
        }
      }

      // Filter by eye color
      if (selectedEyeColor.value != null && selectedEyeColor.value!.isNotEmpty) {
        final selectedEyeColorId = int.tryParse(selectedEyeColor.value!);
        if (selectedEyeColorId != null) {
          if (employee.eyeColor == null || employee.eyeColor!.id != selectedEyeColorId) {
            return false;
          }
        }
      }

      // Filter by hair color
      if (selectedHairColor.value != null && selectedHairColor.value!.isNotEmpty) {
        final selectedHairColorId = int.tryParse(selectedHairColor.value!);
        if (selectedHairColorId != null) {
          if (employee.hairColor == null || employee.hairColor!.id != selectedHairColorId) {
            return false;
          }
        }
      }

      // Filter by experience level (position)
      if (selectedPosition.value != null && selectedPosition.value!.isNotEmpty) {
        if (employee.experienceYears == null ||
            employee.experienceYears!.toLowerCase() != selectedPosition.value!.toLowerCase()) {
          return false;
        }
      }

      // Filter by skill
      if (selectedSkill.value != null && selectedSkill.value!.isNotEmpty) {
        final selectedSkillId = int.tryParse(selectedSkill.value!);
        if (selectedSkillId != null) {
          final hasSkill = employee.skills.any((skill) => skill.id == selectedSkillId);
          if (!hasSkill) {
            return false;
          }
        }
      }

      // Filter by age (calculate from DOB)
      if ((selectedMinAge.value != null && selectedMinAge.value!.isNotEmpty) ||
          (selectedMaxAge.value != null && selectedMaxAge.value!.isNotEmpty)) {
        final age = _calculateAge(employee.dob);
        if (age != null) {
          if (selectedMinAge.value != null && selectedMinAge.value!.isNotEmpty) {
            final minAge = int.tryParse(selectedMinAge.value!);
            if (minAge != null && age < minAge) {
              return false;
            }
          }
          if (selectedMaxAge.value != null && selectedMaxAge.value!.isNotEmpty) {
            final maxAge = int.tryParse(selectedMaxAge.value!);
            if (maxAge != null && age > maxAge) {
              return false;
            }
          }
        }
      }

      return true;
    }).toList();

    // Update the displayed employee list
    employees.assignAll(filteredEmployees);

    Get.back(); // Close the drawer

    log('Filtered Employees: ${employees.length} out of ${allEmployees.length}');

    Utilities.showSnackBar(
      title: "Filters Applied",
      message: "Found ${employees.length} users matching your criteria",
      isSuccess: true,
    );
  }

  int? _calculateAge(String dob) {
    try {
      final birthDate = DateTime.parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      log('Error calculating age from DOB: $dob - $e');
      return null;
    }
  }

  void resetFilters() {
    log('Resetting filters...');

    // Clear all selected filter values
    selectedJob.value = null;
    selectedPosition.value = null;
    selectedMinAge.value = null;
    selectedMaxAge.value = null;
    selectedGender.value = null;
    selectedHeight.value = null;
    selectedEyeColor.value = null;
    selectedHairColor.value = null;
    selectedSkill.value = null;

    // Restore all employees and employers
    log('Restoring employees: ${allEmployees.length}');
    log('Restoring employers: ${allEmployers.length}');

    employees.clear();
    employers.clear();

    employees.addAll(allEmployees);
    employers.addAll(allEmployers);

    log('Restored employees: ${employees.length}');
    log('Restored employers: ${employers.length}');

    Get.back(); // Close the drawer

    Utilities.showSnackBar(
      title: "Filters Removed",
      message: "Showing ${employees.length} employees and ${employers.length} employers",
      isSuccess: true,
    );
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
