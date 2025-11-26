import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        title: "Settings",
        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 5.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// NOTIFICATION SECTION
            _notificationSection(),

            /// DISPLAY SECTION
            _displaySection(),

            /// ACCOUNT SECTION
            _accountSection(),

            /// ABOUT SECTION
            _aboutSection(),

            /// DELETE ACCOUNT OPTION
            _buildButton(
              context: context,
              buttonText: "Delete Account",
              onTap: () {},
              textColor: AppColors.colorFF3B30,
            ),
            SizedBox(height: 10.h),

            /// SIGN OUT OPTION
            _buildButton(
              context: context,
              buttonText: "Sign Out",
              onTap: () {},
              textColor: AppColors.colorFFFFFF,
            ),
          ],
        ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
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

  Widget _buildAboutTile({required String title, VoidCallback? onTap}) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
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
        fit: BoxFit.cover,
      ),
    );
  }

  Theme _buildSwitchTile({required String tileText}) {
    return Theme(
      data: ThemeData(
        useMaterial3: false,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.white),
          trackColor: MaterialStateProperty.all(Colors.grey),
        ),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.symmetric(),
        value: true,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        onChanged: (val) {},
        title: CustomText(
          title: tileText,
          fontSize: 16,
          color: AppColors.colorFFFFFF,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _notificationSection() {
    return Column(
      spacing: 2.h,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "Notifications",
          fontSize: 19,
          color: AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
        _buildSwitchTile(tileText: "Receive Message"),
        _buildSwitchTile(tileText: "Sound"),
        _buildSwitchTile(tileText: "Vibrate"),
        _buildSwitchTile(tileText: "Location"),
        Divider(color: AppColors.color262626),
      ],
    );
  }

  Widget _displaySection() {
    return Column(
      spacing: 2.h,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "Display",
          fontSize: 19,
          color: AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
        _buildSwitchTile(tileText: "Show Distance"),
        Divider(color: AppColors.color262626),
      ],
    );
  }

  Widget _accountSection() {
    return Column(
      spacing: 2.h,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "Account",
          fontSize: 19,
          color: AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
        // Change Password
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "About",
          fontSize: 19,
          color: AppColors.colorFF8600,
          fontWeight: FontWeight.w600,
        ),
        _buildAboutTile(title: "Community Guidelines"),
        _buildAboutTile(title: "Terms & Conditions"),
        _buildAboutTile(title: "Feedback & Support"),
        Divider(color: AppColors.color262626),
      ],
    );
  }
}
