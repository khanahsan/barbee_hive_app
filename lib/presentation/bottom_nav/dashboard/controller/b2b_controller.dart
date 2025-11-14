import 'dart:developer';

import 'package:get/get.dart';

import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class B2BController extends GetxController {
  RxInt userRole = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
  }

  /// FETCH ROLE (EMPLOYEE (3) OR EMPLOYER (2))
  Future<void> fetchUserRole() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole) ?? 0;
    userRole.value = role;

    log("USER ROLE: ${userRole.value}");
  }

  /// CONDITION TO CHECK AND SHOW MESSAGE OPTION
  bool get canSendMessage => userRole.value != 3;
}
