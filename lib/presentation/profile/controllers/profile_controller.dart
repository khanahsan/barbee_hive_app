import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/api/auth_provider.dart';
import '../../../data/model/user_profile_response.dart';

class ProfileController extends GetxController {
  Rx<UserProfileResponse?> userProfile = Rx<UserProfileResponse?>(null);
  RxBool isLoading = false.obs;
  RxInt currentUserId = 0.obs;

  RxBool isEditing = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  final experienceList = ["Fresher", "1-2 Years", "3-5 Years", "5+ Years"];
  final selectedExperience = ''.obs;





  @override
  void onInit() {
    super.onInit();
    getUserIdAndFetchProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    debugPrint("isEditing.value ${isEditing.value}");
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
      final profile = await AuthProvider.getUserProfile(userId);
      userProfile.value = profile;

      debugPrint("userProfile.value ${userProfile.value}");
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
