import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/services/current_user_subscription_controller.dart';
import 'package:barbee_hive_app/infrastructure/services/subscription_feature_guard.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class B2BController extends GetxController {
  final CurrentUserSubscriptionController currentUserSubscriptionController =
      Get.find<CurrentUserSubscriptionController>();

  RxInt userRole = 0.obs;
  RxInt userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
    fetchUserID();
  }

  /// FETCH ROLE (EMPLOYEE (3) OR EMPLOYER (2))
  Future<void> fetchUserRole() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole) ?? 0;
    userRole.value = role;

    log("USER ROLE: ${userRole.value}");
  }

  /// Fetch the logged-in user's ID
  Future<void> fetchUserID() async {
    final userID = SharedPreferenceHelper.getInt(SharedPrefKeys.userId) ?? 0;
    userId.value = userID;

    log("USER ID: ${userId.value}");
  }

  /// CONDITION TO CHECK AND SHOW MESSAGE OPTION
  bool get canSendMessage => userRole.value != 3;

  /// Check if the displayed user is the same as the logged-in user.
  bool isSameUser(int otherUserId) {
    log('AAA ${userId.value == otherUserId}');
    return userId.value == otherUserId;
  }

  SubscriptionFeatureGuard get featureGuard => SubscriptionFeatureGuard(
    subscription: currentUserSubscriptionController.currentSubscription,
    userRole: userRole.value,
  );

  bool get shouldShowProfileVisitAds => featureGuard.shouldShowProfileVisitAds;
}
