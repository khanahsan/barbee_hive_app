import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/customDrawer/controller/custom_drawer_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/dashboardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class LogoutService {
  static bool _isLoggingOut = false;

  static Future<void> logout() async {
    if (_isLoggingOut) return; // prevent double taps
    _isLoggingOut = true;

    _showLoader();

    try {
      await AuthApi.logout();

      _closeDialog();

      await _clearSession();

      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      _closeDialog();

      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );

      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      Utilities.showSnackBar(
        message: errorMessage,
        title: 'Error',
        isSuccess: false,
      );
    } finally {
      _isLoggingOut = false;
    }
  }

  static void _showLoader() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.colorFFFFFF,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.colorE4A74C),
                SizedBox(height: 20.h),
                const CustomText(
                  title: 'Signing Out..',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.color000000,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void _closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back<void>(closeOverlays: true);
      // Fallback: pop via root navigator if dialog is still open.
      if (Get.isDialogOpen ?? false) {
        final context = Get.overlayContext ?? Get.context;
        if (context != null &&
            Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }
  }

  static Future<void> _clearSession() async {
    await TokenStorage.clearToken();
    await SharedPreferenceHelper.remove(SharedPrefKeys.userRole);
    await SharedPreferenceHelper.remove(SharedPrefKeys.authToken);
    await SharedPreferenceHelper.remove(SharedPrefKeys.userId);
    await SharedPreferenceHelper.remove(SharedPrefKeys.userProfileImage);
    await SharedPreferenceHelper.remove(SharedPrefKeys.userName);
    // await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);

    ApiService.clearToken();

    // These controllers can still hold lifecycle observers or eager startup logic
    // that hits authenticated endpoints. Deleting them during logout stops stale
    // dashboard/navigation state from calling APIs after the session is cleared.
    if (Get.isRegistered<DashboardController>()) {
      Get.delete<DashboardController>(force: true);
    }
    if (Get.isRegistered<BottomNavController>()) {
      Get.delete<BottomNavController>(force: true);
    }
    if (Get.isRegistered<CustomDrawerController>()) {
      Get.delete<CustomDrawerController>(force: true);
    }
  }
}
