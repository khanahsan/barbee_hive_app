import 'dart:io';

import 'package:barbee_hive_app/infrastructure/widgets/custom_profile_image.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/widgets/custom_appbar.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'employee/employee_edit_widget.dart';
import 'employer/employer_edit_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topOffset = 170.h;
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
              GestureDetector(
                onTap: () => Get.offNamed(Routes.settingsScreen),
                child: SvgPicture.asset(
                  AppAssets.settingIcon,
                  fit: BoxFit.cover,
                  height: 23.h,
                  width: 23.w,
                  color: AppColors.colorFFFFFF,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () =>
            controller.isEditing.value && controller.isLoading.value == false
                ? Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    bottom: 20.h,
                  ),
                  child: CustomBtn(
                    buttonHeight: 58.h,
                    btnTitle: "Submit Now",
                    btnBackgroundColor: AppColors.colorFF8600,
                    btnTxtColor: Colors.white,
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.updateUserProfile();
                      }
                    },
                  ),
                )
                : SizedBox.shrink(), // nothing at bottom if not editing
      ),

      backgroundColor: Colors.black,
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // COVER IMAGE
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Stack(
                          children: [
                            // Image area (local first, then network, then grey)
                            Obx(() {
                              // 1) show newly picked local image immediately
                              if (controller.coverImageFile.value != null) {
                                return Image.file(
                                  controller.coverImageFile.value!,
                                  fit: BoxFit.cover,
                                  height: 200.h,
                                  width: double.infinity,
                                );
                              }

                              // 2) If server-provided cover exists
                              if (controller.userCoverImage.value.isNotEmpty &&
                                  controller.userCoverImage.value != "null") {
                                return Image.network(
                                  controller.userCoverImage.value,
                                  fit: BoxFit.cover,
                                  height: 200.h,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200.h,
                                      width: double.infinity,
                                      color: Colors.grey.shade800,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Failed to load cover photo",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    );
                                  },
                                );
                              }

                              // 3) No image available -> grey background
                              return Container(
                                height: 200.h,
                                width: double.infinity,
                                color: Colors.grey.shade800,
                              );
                            }),

                            // Add/Change Cover Photo button (only when editing)
                            if (controller.isEditing.value)
                              Positioned(
                                right: 15.w,
                                top: 15.h,
                                child: CustomBtn(
                                  buttonWidth: 165.w,
                                  buttonHeight: 45.h,
                                  fontSize: 16.sp,
                                  btnBackgroundColor: AppColors.color000000
                                      .withOpacity(0.5),
                                  btnTitle:
                                      controller.coverImageFile.value != null ||
                                              controller
                                                  .userCoverImage
                                                  .value
                                                  .isNotEmpty
                                          ? "Change Cover Photo"
                                          : "Add Cover Photo",
                                  onPressed: () => controller.pickCoverPhoto(),
                                ),
                              ),
                          ],
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
                              color: AppColors.colorFF8600,
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
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => CustomText(
                                        title: controller.userName.value,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.colorFFFFFF,
                                      ),
                                    ),
                                    Obx(() => RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  controller.isEditing.value
                                                      ? ""
                                                      : "Skills",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.colorFF8600,
                                              ),
                                            ),
                                            TextSpan(text: " "),
                                            TextSpan(
                                              text:
                                                  controller
                                                          .selectedSkills
                                                          .isNotEmpty
                                                      ? controller
                                                          .selectedSkills
                                                          .first
                                                      : "No skills selected",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    controller.isEditing.value
                                                        ? AppColors.colorFF8600
                                                        : AppColors.colorFFFFFF,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    if (controller.isEditing.value) ...[
                                      /// SHOW EMPLOYER EDIT PROFILE
                                      if (controller.currentUserRole.value == 2)
                                        EmployerEditWidget(),

                                      /// SHOW EMPLOYEE EDIT PROFILE
                                      if (controller.currentUserRole.value == 3)
                                        EmployeeEditWidget(),

                                      SizedBox(height: 5.h),
                                    ],

                                    if (!controller.isEditing.value)
                                      CustomBtn(
                                        buttonHeight: 58.h,
                                        btnTitle: 'Edit Profile',
                                        btnBackgroundColor:
                                            AppColors.colorFF8600,
                                        btnTxtColor: Colors.white,
                                        onPressed: () {
                                          controller.toggleEditing();
                                        },
                                      ),

                                    // Obx(
                                    //   () => CustomBtn(
                                    //     buttonHeight: 58.h,
                                    //     btnTitle:
                                    //         controller.isEditing.value == true
                                    //             ? "Submit Now"
                                    //             : 'Edit Profile',
                                    //     btnBackgroundColor:
                                    //         AppColors.colorFF8600,
                                    //     btnTxtColor: Colors.white,
                                    //     // width: double.infinity,
                                    //     onPressed: () {
                                    //       log(
                                    //         "BUTTON PRESSED ${!controller.isEditing.value}",
                                    //       );
                                    //
                                    //       if (!controller.isEditing.value) {
                                    //         controller.toggleEditing();
                                    //         return;
                                    //       }
                                    //
                                    //       if (controller.formKey.currentState!
                                    //           .validate()) {
                                    //         log("Calling updateUserProfile()");
                                    //         controller.updateUserProfile();
                                    //       }
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: -80.h,
                            child: Obx(
                              () => Center(
                                child: CustomProfileImage(
                                  width: 130,
                                  height: 140,
                                  imagePath: controller.userProfileImage.value,
                                  text: controller.userName.value,
                                  isEditMode: controller.isEditing.value,
                                  wholeAvatarClickable: false,
                                  onImagePicked: (File? file) {
                                    if (file != null) {
                                      controller.userProfileImage.value =
                                          file.path;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Positioned(
                          //   top: -80.h,
                          //   child: HexagonAvatar(
                          //     imagePath: controller.userProfileImage.value,
                          //     width: 130.w,
                          //     height: 140.h,
                          //     showOption: true,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ).paddingOnly(top: 25.h),
      ),
    );
  }
}
