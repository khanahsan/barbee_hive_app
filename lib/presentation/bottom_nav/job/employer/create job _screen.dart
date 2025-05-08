import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class CreateJobScreen extends StatelessWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        title: "Create Job",
        showHexagon: false,
        leadingIconPath: AppAssets.backIcon,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, .7],
                colors: [
                  AppColors.color995000,
                  // AppColors.primary,
                  AppColors.black,
                ],
              ),
            ),
            child: Text(
              textAlign: TextAlign.center,
              "You have to pay to\npost your Job",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 35.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          SizedBox(height: 40.h),
          Text(
            textAlign: TextAlign.center,
            "Pay \$5",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 25.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            "To Create Job",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 25.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 30.h),
          _buildActionButton(
            onTap: () {},
            text: "View Monthly Plans",
            buttonColor: AppColors.black,
            borderColor: AppColors.primary,
            isIcon: true,
            iconPath: AppAssets.arrowForwardBIcon,
            iconSize: 12.sp,
            iconColor: AppColors.primary,
          ),

          SizedBox(height: 20.h),
          _buildActionButton(
            onTap: () {},
            text: "Continue",
            buttonColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color buttonColor,
    required VoidCallback onTap,
    Color? textColor,
    double? textSize,
    double? height,
    bool isIcon = false,
    String? iconPath,
    double? iconSize,
    Color? iconColor,
    Color? borderColor,
  }) {
    return CustomButton(
      onTap: onTap,
      buttonText: text,
      buttonWidth: double.infinity,
      buttonColor: buttonColor,
      borderColor: borderColor,
      buttonTextSize: textSize ?? 16.sp,
      buttonHeight: height ?? 62.h,
      isIcon: isIcon,
      iconPath: iconPath,
      iconSize: iconSize,
      iconColor: iconColor,
    ).paddingSymmetric(horizontal: 15.w);
  }
}
