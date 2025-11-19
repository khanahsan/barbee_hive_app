import 'dart:developer';

import 'package:get/get.dart';

import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class HiveProfileController extends GetxController {
  RxInt userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserID();
  }

  /// Fetch the logged-in user's ID
  Future<void> fetchUserID() async {
    final userID = SharedPreferenceHelper.getInt(SharedPrefKeys.userId) ?? 0;
    userId.value = userID;

    log("USER ID: ${userId.value}");
  }

  /// Check if the displayed user is the same as the logged-in user.
  bool isSameUser(int otherUserId) {
    log('SAME USER: ${userId.value == otherUserId}');
    return userId.value == otherUserId;
  }
}
