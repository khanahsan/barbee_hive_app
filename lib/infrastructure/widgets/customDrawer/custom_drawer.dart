import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../presentation/auth/controllers/auth.controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../navigation/routes.dart';
import 'controller/custom_drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomDrawerController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            /// Drawer background (only visible when open)
            if (controller.isDrawerOpen.value)
              FadeTransition(
                opacity: controller.fadeAnimation,
                child: Container(
                  color: AppColors.black,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.w, top: 80.h),
                    child: ScaleTransition(
                      scale: controller.drawerScaleAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: controller.toggleDrawer,
                            child: SvgPicture.asset(
                              AppAssets.closeIcon,
                              width: 15.w,
                              height: 15.h,
                              color: AppColors.colorFFFFFF,
                            ).paddingSymmetric(horizontal: 5.w),
                          ),
                          SizedBox(height: 30.h),

                          HexagonAvatar(
                            imagePath: controller.userProfileImage.value,
                            width: 60.w,
                            height: 70.h,
                            borderColor: AppColors.colorFF8600,
                          ),

                          CustomText(
                            title: "Welcome",
                            fontSize: 19,
                            color: AppColors.colorFF8600,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            width: 160.w,
                            child: CustomText(
                              title: controller.userName.value,
                              fontSize: 30,
                              color: AppColors.colorFFFFFF,
                              fontWeight: FontWeight.w600,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 60.h),

                          drawerMenuTile(
                            title: "Edit Profile",
                            iconPath: AppAssets.editIcon,
                            controller: controller,
                            onTap: () {
                              Get.toNamed(Routes.PROFILE_SCREEN);
                            },
                          ),
                          SizedBox(height: 25.h),

                          drawerMenuTile(
                            title:
                                controller.role == 2
                                    ? "My Jobs"
                                    : "My Applications",
                            iconPath: AppAssets.jobIcon,
                            controller: controller,
                            onTap: () {
                              controller.role == 2
                                  ? Get.toNamed(
                                    Routes.jobs,
                                    arguments: {"showBackButton": true},
                                  )
                                  : Get.toNamed(Routes.myJobs);
                            },
                          ),

                          SizedBox(height: 25.h),

                          drawerMenuTile(
                            title: "Settings",
                            iconPath: AppAssets.settingIcon,
                            controller: controller,
                            onTap: () {
                              Get.toNamed(Routes.settingsScreen);
                            },
                          ),
                          SizedBox(height: 25.h),

                          drawerMenuTile(
                            title: "Logout",
                            iconPath: AppAssets.exitIcon,
                            controller: controller,
                            onTap: () {
                              Get.find<AuthController>().logout();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              BottomNavScreen(onMenuPressed: controller.toggleDrawer),

            /// Foreground content
            IgnorePointer(
              ignoring: controller.isDrawerOpen.value,
              child: SlideTransition(
                position: controller.offsetAnimation,
                child: GestureDetector(
                  onTap: controller.toggleDrawer,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ScaleTransition(
                      scale: controller.dashboardStackScaleAnimation,
                      child: _buildDashboardStack(controller),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardStack(CustomDrawerController controller) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(height: 700.h, width: 150.w),
        Positioned(
          left: -15.w,
          child: Container(
            height: 500.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: AppColors.color151515,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ),
        Positioned(
          left: 10.w,
          child: Container(
            height: 600.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: AppColors.color1F1F1F,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ),
        Positioned(
          left: 40.w,
          child: Container(
            height: 700.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: BottomNavScreen(onMenuPressed: controller.toggleDrawer),
            ),
          ),
        ),
      ],
    );
  }

  Widget drawerMenuTile({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
    CustomDrawerController? controller,
  }) {
    return InkWell(
      onTap: () async {
        if (controller != null) {
          // Close the drawer first
          controller.toggleDrawer();

          // Wait for the animation to finish (same as drawer animation duration)
          await Future.delayed(const Duration(milliseconds: 280));
        }

        // Now navigate
        onTap();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12.w,
        children: [
          SvgPicture.asset(iconPath, width: 22.w, height: 22.h),
          CustomText(
            title: title,
            fontSize: 21,
            color: AppColors.colorFFFFFF,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  // Widget drawerMenuTile({
  //   required String title,
  //   required String iconPath,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       spacing: 12.w,
  //       children: [
  //         SvgPicture.asset(iconPath, width: 22.w, height: 22.h),
  //         CustomText(
  //           title: title,
  //           fontSize: 21,
  //           color: AppColors.white,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
