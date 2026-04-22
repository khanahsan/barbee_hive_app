import 'dart:developer';

import 'package:barbee_hive_app/data/api/profile/profile_api.dart';
import 'package:barbee_hive_app/data/model/user_profile_response.dart'
    as profile_model;
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/services/current_user_subscription_controller.dart';
import 'package:barbee_hive_app/infrastructure/services/subscription_feature_guard.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class HiveProfileController extends GetxController {
  final CurrentUserSubscriptionController currentUserSubscriptionController =
      Get.find<CurrentUserSubscriptionController>();

  RxInt userId = 0.obs;
  RxInt userRole = 0.obs;
  final Rxn<profile_model.UserProfileData> viewedUserProfile =
      Rxn<profile_model.UserProfileData>();
  final RxBool isViewedUserLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    AdsHelper().loadInterstitialAd();
    fetchUserID();
  }

  /// Fetch the logged-in user's ID
  Future<void> fetchUserID() async {
    final userID = SharedPreferenceHelper.getInt(SharedPrefKeys.userId) ?? 0;
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole) ?? 0;
    userId.value = userID;
    userRole.value = role;

    log("USER ID: ${userId.value}");

    final args = Get.arguments;
    final viewedUserId = args is Map ? args['viewedUserId'] as int? : null;
    if (viewedUserId != null && viewedUserId != 0) {
      await fetchViewedUserProfile(viewedUserId);
    }
  }

  Future<void> fetchViewedUserProfile(int viewedUserId) async {
    try {
      isViewedUserLoading.value = true;
      final response = await ProfileApi.getUserProfile(viewedUserId);
      viewedUserProfile.value = response.data;
    } catch (e) {
      log('Failed to fetch viewed user profile: $e');
      viewedUserProfile.value = null;
    } finally {
      isViewedUserLoading.value = false;
    }
  }

  /// Check if the displayed user is the same as the logged-in user.
  bool isSameUser(int otherUserId) {
    log('SAME USER: ${userId.value == otherUserId}');
    return userId.value == otherUserId;
  }

  SubscriptionFeatureGuard get featureGuard => SubscriptionFeatureGuard(
    subscription: currentUserSubscriptionController.currentSubscription,
    userRole: userRole.value,
  );

  bool get canEmployerUsePremiumFeatures =>
      featureGuard.canEmployerUsePremiumFeatures;
  bool get canAccessHiveResumeForCurrentRole =>
      userRole.value == 2
          ? featureGuard.canEmployerUsePremiumFeatures
          : featureGuard.canEmployeeUsePremiumFeatures;

  bool get shouldShowProfileVisitAds => featureGuard.shouldShowProfileVisitAds;

  ResumeAdMode get resumeAdMode => featureGuard.resumeAdMode;
}
