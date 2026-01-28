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
        titleWidget: SvgPicture.asset(
          AppAssets.appIconTwo,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
        ),
        showHexagon: false,
        // profileImagePath: controller.userProfileImage.value,
      ),

      backgroundColor: AppColors.black,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 25.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: AppColors.textFieldBackground,
          ),
          child: CustomText(
            textAlign: TextAlign.center,
            maxLines: 2,
            title: "Coming\nSoon!",
            color: AppColors.colorFFFFFF,
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
