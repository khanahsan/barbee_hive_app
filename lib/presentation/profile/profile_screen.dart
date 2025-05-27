import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/custom_appbar.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'employee/employee_edit_widget.dart';
import 'employer/employer_edit_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topOffset = 120.h;
    final fullHeight = screenHeight - topOffset;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => customAppbar(
            context: context,
            leadingTapFunction: () {
              Get.back();
            },
            title: controller.isEditing.value ? "Edit Profile" : "Profile",
            showActions: true,
            leadingIconPath: AppAssets.backIcon,
            showHexagon: false,
            actions: [
              SvgPicture.asset(
                AppAssets.settingIcon,
                fit: BoxFit.cover,
                height: 23.h,
                width: 23.w,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),

      backgroundColor: Colors.black,
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Image.asset(
                          AppAssets.profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      top: topOffset,
                      // 50.h
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height:
                                controller.isEditing.value ? null : fullHeight,
                            padding: EdgeInsets.only(top: 3.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0.r),
                                topRight: Radius.circular(20.0.r),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 15.w,
                                right: 15.w,
                                top: 70.h,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(18.0),
                                  topLeft: Radius.circular(18.0),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.userName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              controller.isEditing.value
                                                  ? ""
                                                  : "Experience",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(text: " "),
                                        TextSpan(
                                          text: controller.currentUserSkill,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                controller.isEditing.value
                                                    ? AppColors.primary
                                                    : AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  if (controller.isEditing.value) ...[
                                    if (controller.currentUserRole.value == 2)
                                      EmployerEditWidget(),
                                    if (controller.currentUserRole.value == 3)
                                      EmployeeEditWidget(),
                                    SizedBox(height: 20.h),
                                  ],
                                  Obx(
                                    () => CustomBtn(
                                      buttonHeight: 58.h,
                                      btnTitle:
                                          controller.isEditing.value == true
                                              ? "Submit Now"
                                              : 'Edit Profile',
                                      btnBackgroundColor: AppColors.primary,
                                      btnTxtColor: Colors.white,
                                      // width: double.infinity,
                                      onPressed: () {
                                        controller.isEditing.value == true ?
                                        controller.updateUserProfile() : controller.toggleEditing();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: -80.h,
                            child: HexagonAvatar(
                              imagePath: AppAssets.profileImage,
                              width: 140.w,
                              height: 150.h,
                              showOption: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).paddingOnly(top: 25.h),
      ),
    );
  }
}
