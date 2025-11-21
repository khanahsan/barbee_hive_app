import 'dart:developer';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
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

  @override
  void onInit() {
    super.onInit();
    // fetchDashboardUsers();
    getUserLocationAndFetchDashboard();
    loadBannerAd();
    AdsHelper().loadInterstitialAd();

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

  void getUserLocationAndFetchDashboard() async {

    isLoading.value = true;

    try {
      final position = await LocationService.determinePosition();

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;

      print('Lat: ${position.latitude}, Lng: ${position.longitude}');

      await fetchDashboardUsers(); // ✅ Fetch users after getting location
    } catch (e) {
      print('Location error: $e');
      Get.snackbar(
        "Location Error",
        "Could not get current location.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchDashboardUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      employers.clear();
      print('Fetching dashboard users');
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
      Get.snackbar(
        "Error",
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void trackProfileView() {
    AdsHelper().trackProfileView();
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
