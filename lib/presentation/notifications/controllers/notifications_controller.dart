import 'package:barbee_hive_app/data/api/notifications/notifications_api.dart';
import 'package:get/get.dart';

import '../../bottom_nav/dashboard/controller/dashboardController.dart';

import '../../../data/model/notification_response.dart';
import '../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';

class NotificationsController extends GetxController{

  Rx<String?> userProfileImage = ''.obs;
  RxList<AppNotification> notificationsList = <AppNotification>[].obs;
  RxBool isLoading = true.obs;

  void _startLoading() => isLoading.value = true;
  void _stopLoading() => isLoading.value = false;

  /// Load user profile imaeg
  Future<void> loadRole() async {
    userProfileImage.value =
        SharedPreferenceHelper.getString(SharedPrefKeys.userProfileImage);
  }


  getAllNotifications() async {
    _startLoading();
    try {
      notificationsList.value = await NotificationsApi.getAllNotifications();
      _stopLoading();
    } catch (e) {
      _stopLoading();
    }


  }

  markAllAsRead() async {
    _startLoading();
    try {
      await NotificationsApi.markAllAsRead();
      _stopLoading();

      // The server count is now zero; pull it through so the dashboard badge
      // goes away instead of waiting for the dashboard to be rebuilt.
      DashboardController.refreshUnreadBadge();
    } catch (e) {
      _stopLoading();
    }
  }


  @override
  void onInit() {
    loadRole();
    getAllNotifications();
    markAllAsRead();
    super.onInit();
  }

}