import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
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
      body: Column(
        spacing: 5.h,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _notificationSection(context),
          _displaySection(context),
          _aboutSection(context: context),
          _buildButton(
            context: context,
            buttonText: "Delete Account",
            onTap: () {},
            textColor: AppColors.colorFF3B30,
          ),
          SizedBox(height: 10.h),
          _buildButton(
            context: context,
            buttonText: "Sign Out",
            onTap: () {},
            textColor: AppColors.white,
          ),
        ],
      ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
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
          color: textColor ?? AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAboutTile({
    required BuildContext context,
    required String title,
  }) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 16.sp,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: SvgPicture.asset(
        AppAssets.arrowForwardIcon,
        color: AppColors.white,
        height: 25.h,
        width: 25.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Theme _buildSwitchTile({
    required BuildContext context,
    required String tileText,
  }) {
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
        title: Text(
          tileText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _notificationSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notifications",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 19.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        _buildSwitchTile(context: context, tileText: "Receive Message"),
        SizedBox(height: 12.h),
        _buildSwitchTile(context: context, tileText: "Sound"),
        SizedBox(height: 12.h),
        _buildSwitchTile(context: context, tileText: "Vibrate"),
        SizedBox(height: 12.h),
        _buildSwitchTile(context: context, tileText: "Location"),
        Divider(color: AppColors.color262626),
      ],
    );
  }

  Widget _displaySection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Display",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 19.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        _buildSwitchTile(context: context, tileText: "Show Distance"),
        Divider(color: AppColors.color262626),
      ],
    );
  }

  Widget _aboutSection({required BuildContext context}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 19.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        _buildAboutTile(context: context, title: "Community Guidelines"),
        SizedBox(height: 12.h),
        _buildAboutTile(context: context, title: "Terms & Conditions"),
        SizedBox(height: 12.h),
        _buildAboutTile(context: context, title: "Feedback & Support"),
        Divider(color: AppColors.color262626),
      ],
    );
  }
}
