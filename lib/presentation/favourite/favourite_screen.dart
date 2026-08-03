import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class FavouriteScreen extends GetView<JobController> {
  const FavouriteScreen({super.key, this.onMenuPressed, this.showBackButton});

  final VoidCallback? onMenuPressed;
  final bool? showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          if (showBackButton == true) {
            Get.back();
          } else {
            if (onMenuPressed != null) onMenuPressed!();
          }
        },
        leadingIconPath: showBackButton == true ? AppAssets.backIcon : null,
        // title: isEmployer ? 'Job Applications' : 'Find Jobs',
        title: '',
        titleWidget: Image.asset(
          AppAssets.appLogo4,
          width: 195.w,
          height: 54.h,
          fit: BoxFit.cover,
        ),
        showHexagon: false,
        // profileImagePath: controller.userProfileImage.value,
      ),

      backgroundColor: AppColors.black,
      body: Center(
        child: CustomText(
          textAlign: TextAlign.center,
          maxLines: 2,
          title: "Coming Soon!",
          color: AppColors.colorFFFFFF,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
