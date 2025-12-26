import 'package:get/get.dart';

import '../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';

class NotificationsController extends GetxController{

  Rx<String?> userProfileImage = ''.obs;

  /// Load user profile imaeg
  Future<void> loadRole() async {
    userProfileImage.value =
        SharedPreferenceHelper.getString(SharedPrefKeys.userProfileImage);
  }


  @override
  void onInit() {
    loadRole();
    super.onInit();
  }

}