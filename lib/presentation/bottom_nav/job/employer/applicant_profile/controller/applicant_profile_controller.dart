import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/model/applicant_profile_response.dart';
import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicantProfileController extends GetxController {
  final profile = Rxn();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = Get.arguments?['userId'] ?? 38;

    fetchProfile(userId);
  }

  Future fetchProfile(int userId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('Fetching profile for userId: $userId');
      final endpoint = '${ApiEndPoints.userProfile}/$userId';
      final data = await ApiService.get(endpoint, auth: true);
      print('GET Response: $data');
      final response = ApplicantProfileResponse.fromJson(data);
      if (response.status) {
        profile.value = response.data;
        print('Profile loaded: ${profile.value?.email}');
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Fetch Profile Error: $e');
      LogUtil.logError('fetchProfile: $e');
      errorMessage.value =
          e.toString().contains('No internet connection')
              ? 'No internet connection. Please check your connection and try again.'
              : e.toString().replaceFirst('Exception: ', '');
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
