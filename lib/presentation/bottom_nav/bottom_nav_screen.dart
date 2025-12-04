import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/dashboard_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/job_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/message_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/pricing_plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'controller/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Screen list
    final List<Widget> screens = [
      DashboardScreen(onMenuPressed: onMenuPressed),
      MessageScreen(onMenuPressed: onMenuPressed),
      JobScreen(onMenuPressed: onMenuPressed),
      PricingPlansScreen(onMenuPressed: onMenuPressed, showBackButton: false),
    ];

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.black,

        // endDrawer: Drawer(
        //   backgroundColor: AppColors.black,
        //   child: Column(
        //     children: [
        //       AppBar(
        //         backgroundColor: AppColors.colorFF8600,
        //         title: const Text("Filters"),
        //         titleTextStyle: Theme.of(
        //           context,
        //         ).textTheme.titleMedium?.copyWith(
        //           fontSize: 20.sp,
        //           fontWeight: FontWeight.w500,
        //           color: AppColors.white,
        //         ),
        //         automaticallyImplyLeading: false,
        //         actions: [
        //           IconButton(
        //             icon: const Icon(Icons.close, color: AppColors.white),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: 30.h),
        //
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedJob?.value,
        //         hintText: "Select Job Type",
        //         items: controller.jobList,
        //         onChanged: (val) => controller.selectedJob?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedPosition?.value,
        //         hintText: "Select Position Type",
        //         items: controller.positionList,
        //         onChanged:
        //             (val) => controller.selectedPosition?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedMinAge?.value,
        //         hintText: "Min Age",
        //         items: controller.minAgeList,
        //         onChanged:
        //             (val) => controller.selectedMinAge?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedMaxAge?.value,
        //         hintText: "Max Age",
        //         items: controller.maxAgeList,
        //         onChanged:
        //             (val) => controller.selectedMaxAge?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedGender?.value,
        //         hintText: "Gender",
        //         items: controller.genderList,
        //         onChanged:
        //             (val) => controller.selectedGender?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedHeight?.value,
        //         hintText: "Height",
        //         items: controller.heightList,
        //         onChanged:
        //             (val) => controller.selectedHeight?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedEyeColor?.value,
        //         hintText: "Eye Color",
        //         items: controller.eyeColorList,
        //         onChanged:
        //             (val) => controller.selectedEyeColor?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedHairColor?.value,
        //         hintText: "Hair Color",
        //         items: controller.hairColorList,
        //         onChanged:
        //             (val) => controller.selectedHairColor?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       CustomButton(
        //         buttonText: "Apply Filters",
        //         onTap: controller.applyFilters,
        //         buttonWidth: double.infinity,
        //         buttonHeight: 60.h,
        //         buttonColor: AppColors.colorFF8600,
        //         borderRadius: 10.r,
        //       ).paddingSymmetric(horizontal: 15.w),
        //     ],
        //   ),
        // ),
        body: screens[controller.currentBottomIndex.value],

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentBottomIndex.value,
          onTap: (index) => controller.onItemTapped(index),
        ),
      ),
    );
  }

}
