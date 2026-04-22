import 'dart:developer';

import 'package:barbee_hive_app/data/api/profile/profile_api.dart';
import 'package:barbee_hive_app/data/model/user_profile_response.dart'
    as profile_model;
import 'package:get/get.dart';

import '../constants/shared_pref_keys.dart';
import '../helpers/shared_preference_helper.dart';

class CurrentUserSubscriptionController extends GetxController {
  final Rxn<profile_model.UserProfileData> currentUserProfile =
      Rxn<profile_model.UserProfileData>();
  final RxBool isLoading = false.obs;
  final RxBool hasLoaded = false.obs;

  int get currentUserId =>
      SharedPreferenceHelper.getInt(SharedPrefKeys.userId) ?? 0;

  int get currentUserRole =>
      SharedPreferenceHelper.getInt(SharedPrefKeys.userRole) ?? 0;

  profile_model.Subscription? get currentSubscription =>
      currentUserProfile.value?.subscription;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  @override
  Future<void> refresh() async {
    final userId = currentUserId;
    if (userId == 0) {
      currentUserProfile.value = null;
      hasLoaded.value = true;
      return;
    }

    try {
      isLoading.value = true;
      final response = await ProfileApi.getUserProfile(userId);
      currentUserProfile.value = response.data;
    } catch (e) {
      log('Failed to refresh current user subscription: $e');
      currentUserProfile.value = null;
    } finally {
      isLoading.value = false;
      hasLoaded.value = true;
    }
  }
}
