import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'controller/setting_controller.dart';

class SettingsScreen extends GetView<SettingController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () => Get.back(),
        title: "",
        titleWidget: Image.asset(AppAssets.appLogo4, width: 70.w, height: 70.h, fit: BoxFit.contain,),

        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        return SingleChildScrollView(
          child: Column(
            spacing: 5.h,
            children: [
              _notificationSection(),
              _displaySection(),
              _accountSection(),
              _aboutSection(),

              _buildButton(
                context: context,
                buttonText: "Delete Account",
                textColor: AppColors.colorFF3B30,
                onTap: () => controller.showDeleteAccountDialog(),
              ),

              SizedBox(height: 10.h),

              _buildButton(
                context: context,
                buttonText: "Sign Out",
                textColor: AppColors.colorFFFFFF,
                onTap: () {
                  controller.logout();
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
        );
      }),
    );
  }

  // ------------------------------
  // SECTIONS
  // ------------------------------

  Widget _notificationSection() {
    return Obx(() {
      return Column(
        spacing: 2.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "Notifications",
            fontSize: 19,
            color: AppColors.colorFF8600,
            fontWeight: FontWeight.w600,
          ),

          _buildSwitchTile(
            tileText: "Receive Message",
            currentValue: controller.receiveMessage.value,
            onChanged: (val) {
              controller.receiveMessage.value = val;
              controller.updateSettings();
              controller.updateDisableChatForAllChats(!val);
            },
          ),

          // _buildSwitchTile(
          //   tileText: "Sound",
          //   currentValue: controller.sound.value,
          //   onChanged: (val) {
          //     controller.sound.value = val;
          //     controller.updateSettings();
          //   },
          // ),
          //
          // _buildSwitchTile(
          //   tileText: "Vibrate",
          //   currentValue: controller.vibrate.value,
          //   onChanged: (val) {
          //     controller.vibrate.value = val;
          //     controller.updateSettings();
          //   },
          // ),
          _buildSwitchTile(
            tileText: "Location",
            currentValue: controller.location.value,
            onChanged: (val) {
              controller.location.value = val;
              controller.updateSettings();
            },
          ),

          Divider(color: AppColors.color262626),
        ],
      );
    });
  }

  Widget _displaySection() {
    return Obx(() {
      return Column(
        spacing: 2.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "Display",
            fontSize: 19,
            color: AppColors.colorFF8600,
            fontWeight: FontWeight.w600,
          ),

          _buildSwitchTile(
            tileText: "Show Distance",
            currentValue: controller.showDistance.value == 1,
            onChanged: (val) {
              controller.showDistance.value = val ? 1 : 0;
              controller.updateSettings();
            },
          ),

          Divider(color: AppColors.color262626),
        ],
      );
    });
  }

  Widget _accountSection() {
    return Column(
      spacing: 2.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "Account",
          fontSize: 19,
          color: AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
        _buildAboutTile(
          title: "Change Password",
          onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
        ),
        Divider(color: AppColors.color262626),
      ],
    );
  }

  Widget _aboutSection() {
    return Column(
      spacing: 2.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "About",
          fontSize: 19,
          color: AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
        _buildAboutTile(
          title: "Community Guidelines",
          onTap: () => controller.openCommunityGuidelines(),
        ),
        _buildAboutTile(
          title: "Terms & Conditions",
          onTap: () => controller.openTerms(),
        ),
        _buildAboutTile(
          title: "Feedback & Support",
          onTap: () => Get.toNamed(Routes.feedbackSupportScreen),
        ),
        Divider(color: AppColors.color262626),
      ],
    );
  }

  // ------------------------------
  // REUSABLE WIDGETS
  // ------------------------------

  Widget _buildSwitchTile({
    required String tileText,
    required bool currentValue,
    required Function(bool) onChanged,
  }) {
    return Theme(
      data: ThemeData(
        visualDensity: VisualDensity.compact,
        useMaterial3: false,
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: currentValue,
        onChanged: onChanged,

        activeColor: AppColors.colorFF8600,
        inactiveTrackColor: AppColors.colorC2C2C2,
        title: CustomText(
          title: tileText,
          fontSize: 16,
          color: AppColors.colorFFFFFF,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAboutTile({required String title, VoidCallback? onTap}) {
    return ListTile(
      dense: true,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        title: title,
        fontSize: 16,
        color: AppColors.colorFFFFFF,
        fontWeight: FontWeight.w600,
      ),
      trailing: SvgPicture.asset(
        AppAssets.arrowForwardIcon,
        color: AppColors.colorFFFFFF,
        height: 20.h,
        width: 20.w,
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String buttonText,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 19.sp,
          color: textColor ?? AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
