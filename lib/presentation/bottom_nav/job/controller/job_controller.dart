import 'package:get/get.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';

import '../../../../infrastructure/helpers/shared_preference_helper.dart';

class JobController extends GetxController {
  Rx<bool> isEmployer = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRole();
  }

  void loadRole() {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    isEmployer.value = role == 2;
  }
}
