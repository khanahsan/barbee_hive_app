import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_responsive_ui/my_responsive_ui.dart';

class ForceLogoutDialog {
  static bool _isDialogOpen = false;

  static void show() {
    if (_isDialogOpen) return; // prevent multiple dialogs

    _isDialogOpen = true;

    Get.dialog<void>(
      WillPopScope(
        onWillPop: () async => false, // disable back button
        child: AlertDialog(
          title: const CustomText(
            title: 'Session Expired',
            color: AppColors.color000000,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          content: const CustomText(
            title: 'Your session has expired. Please login again.',
            color: AppColors.color000000,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          actions: [
            CustomBtn(
              buttonHeight: 52.h,
              btnTitle: 'OK',
              btnBackgroundColor: AppColors.color2E2E2E,
              btnTxtColor: AppColors.colorFFFFFF,
              onPressed: () async {
                _isDialogOpen = false;

                await SharedPreferenceHelper.clear();

                // First dismiss the dialog
                Get.back();

                // Then navigate to the sign-in page
                Get.offAllNamed<void>(Routes.SIGN_IN_VIEW);
              },
            ),
          ],
        ),
      ),
      barrierDismissible: false, // disable tap outside
    );
  }
}

