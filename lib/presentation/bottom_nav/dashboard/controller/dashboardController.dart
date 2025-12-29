import 'dart:developer';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/data/model/dropdown_response.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/location_service.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class DashboardController extends GetxController {
  final RxList<User> employees = <User>[].obs; // Role 3 (Hive)
  final RxList<User> employers = <User>[].obs; // Role 2 (B2B)
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  RxString userProfileImage = ''.obs;

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

  // Selected values
  final Rx<String?> selectedJob = Rx<String?>(null);
  final Rx<String?> selectedPosition = Rx<String?>(null);
  final Rx<String?> selectedMinAge = Rx<String?>(null);
  final Rx<String?> selectedMaxAge = Rx<String?>(null);
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<String?> selectedHeight = Rx<String?>(null);
  final Rx<String?> selectedEyeColor = Rx<String?>(null);
  final Rx<String?> selectedHairColor = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // fetchDashboardUsers();
    getUserLocationAndFetchDashboard();
    loadBannerAd();
    AdsHelper().loadInterstitialAd();
    fetchDropdownData();

    loadUserData();
  }

  Future<void> loadUserData() async {
    userProfileImage.value =
        SharedPreferenceHelper.getString(SharedPrefKeys.userProfileImage) ?? '';
  }

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

      employees.assignAll(response.data.employees); // Role 3 (Hive)
      employers.assignAll(response.data.employers); // Role 2 (B2B)

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

    Get.back(); // Close the drawer

    // TODO: Implement filter logic - make API call with selected filters
    Utilities.showSnackBar(
      title: "Filters Applied",
      message: "Dashboard will be updated with selected filters",
      isSuccess: true,
    );
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
