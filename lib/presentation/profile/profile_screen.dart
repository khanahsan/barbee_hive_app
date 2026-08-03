import 'dart:io';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_profile_image.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
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
    final topOffset = 170.h;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: customAppbar(
          context: context,
          leadingTapFunction: () {
            Get.back();
          },
          title: '',
          titleWidget: Image.asset(
            AppAssets.appLogo4,
            width: 195.w,
            height: 54.h,
            fit: BoxFit.cover,
          ),
          // title: controller.isEditing.value ? "Edit Profile" : "Profile",
          showActions: false,
          leadingIconPath: AppAssets.backIcon,
          showHexagon: false,
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
                      _submitProfileUpdate();
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
                      bottom: 0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: double.infinity,
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
                              child: LayoutBuilder(
                                builder:
                                    (
                                      context,
                                      constraints,
                                    ) => SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight,
                                        ),
                                        child: Form(
                                          key: controller.formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Obx(
                                                () => CustomText(
                                                  title:
                                                      controller.userName.value,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.colorFFFFFF,
                                                ),
                                              ),
                                              Obx(() {
                                                if (controller
                                                    .isEditing
                                                    .value) {
                                                  return SizedBox.shrink();
                                                }

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // CustomText(
                                                    //   title: "Skills",
                                                    //   fontSize: 16,
                                                    //   fontWeight: FontWeight.w600,
                                                    //   color: AppColors.colorFF8600,
                                                    // ),
                                                    SizedBox(height: 10.h),
                                                    if (controller
                                                        .selectedSkills
                                                        .isNotEmpty)
                                                      Wrap(
                                                        spacing: 8.w,
                                                        runSpacing: 8.h,
                                                        children:
                                                            controller
                                                                .selectedSkills
                                                                .map(
                                                                  (
                                                                    skill,
                                                                  ) => Chip(
                                                                    label: Text(
                                                                      skill,
                                                                      style: TextStyle(
                                                                        color:
                                                                            AppColors.colorFFFFFF,
                                                                        fontSize:
                                                                            12.sp,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .color262626,
                                                                    side: BorderSide(
                                                                      color:
                                                                          AppColors
                                                                              .colorFF8600,
                                                                    ),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            20.r,
                                                                          ),
                                                                    ),
                                                                    materialTapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .shrinkWrap,
                                                                    visualDensity:
                                                                        VisualDensity
                                                                            .compact,
                                                                  ),
                                                                )
                                                                .toList(),
                                                      )
                                                    else
                                                      CustomText(
                                                        title:
                                                            "No skills selected",
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppColors
                                                                .colorFFFFFF,
                                                      ),
                                                  ],
                                                );
                                              }),
                                              SizedBox(height: 40.h),
                                              if (controller
                                                  .isEditing
                                                  .value) ...[
                                                /// SHOW EMPLOYER EDIT PROFILE
                                                if (controller
                                                        .currentUserRole
                                                        .value ==
                                                    2)
                                                  EmployerEditWidget(),

                                                /// SHOW EMPLOYEE EDIT PROFILE
                                                if (controller
                                                        .currentUserRole
                                                        .value ==
                                                    3)
                                                  EmployeeEditWidget(),

                                                SizedBox(height: 5.h),
                                              ],

                                              if (!controller.isEditing.value)
                                                Column(
                                                  children: [
                                                    CustomBtn(
                                                      buttonHeight: 58.h,
                                                      btnTitle: 'Edit Profile',
                                                      btnBackgroundColor:
                                                          AppColors.colorFF8600,
                                                      btnTxtColor: Colors.white,
                                                      onPressed: () {
                                                        controller
                                                            .toggleEditing();
                                                      },
                                                    ),
                                                    if (controller
                                                            .currentUserRole
                                                            .value ==
                                                        3) ...[
                                                      SizedBox(height: 14.h),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                14.r,
                                                              ),
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              const Color(
                                                                0xFF2E1A05,
                                                              ),
                                                              AppColors
                                                                  .color000000,
                                                            ],
                                                            begin:
                                                                Alignment
                                                                    .topLeft,
                                                            end:
                                                                Alignment
                                                                    .bottomRight,
                                                          ),
                                                          border: Border.all(
                                                            color:
                                                                AppColors
                                                                    .colorFF8600,
                                                            width: 1.2,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: AppColors
                                                                  .colorFF8600
                                                                  .withOpacity(
                                                                    0.18,
                                                                  ),
                                                              blurRadius: 18.r,
                                                              offset: Offset(
                                                                0,
                                                                8.h,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Material(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          child: Obx(() {
                                                            final isLoading =
                                                                controller
                                                                    .isBoostLoading
                                                                    .value;
                                                            final hasActiveBoost =
                                                                controller
                                                                    .hasActiveBoost;

                                                            return InkWell(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    14.r,
                                                                  ),
                                                              onTap:
                                                                  isLoading
                                                                      ? null
                                                                      : controller
                                                                          .activateBoost,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          18.w,
                                                                      vertical:
                                                                          16.h,
                                                                    ),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          44.w,
                                                                      height:
                                                                          44.h,
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .colorFF8600
                                                                            .withOpacity(
                                                                              0.14,
                                                                            ),
                                                                        shape:
                                                                            BoxShape.circle,
                                                                      ),
                                                                      child:
                                                                          isLoading
                                                                              ? Padding(
                                                                                padding: EdgeInsets.all(
                                                                                  11.r,
                                                                                ),
                                                                                child: CircularProgressIndicator(
                                                                                  strokeWidth:
                                                                                      2.3,
                                                                                  valueColor: AlwaysStoppedAnimation(
                                                                                    AppColors.colorFF8600,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              : Icon(
                                                                                hasActiveBoost
                                                                                    ? Icons.timer_rounded
                                                                                    : Icons.rocket_launch_rounded,
                                                                                color:
                                                                                    AppColors.colorFF8600,
                                                                                size:
                                                                                    22.sp,
                                                                              ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          14.w,
                                                                    ),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            title:
                                                                                hasActiveBoost
                                                                                    ? 'Boost Activated'
                                                                                    : 'Boost your profile',
                                                                            color:
                                                                                AppColors.colorFFFFFF,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                4.h,
                                                                          ),
                                                                          CustomText(
                                                                            title:
                                                                                isLoading
                                                                                    ? 'Processing boost activation...'
                                                                                    : hasActiveBoost
                                                                                    ? 'Time left: ${controller.boostRemainingText}'
                                                                                    : 'Promote your profile for more visibility',
                                                                            color:
                                                                                AppColors.colorB1B1B1,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.w,
                                                                        vertical:
                                                                            6.h,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            AppColors.colorFF8600,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              50.r,
                                                                            ),
                                                                      ),
                                                                      child: CustomText(
                                                                        title:
                                                                            isLoading
                                                                                ? 'Wait'
                                                                                : hasActiveBoost
                                                                                ? 'Active'
                                                                                : 'Boost',
                                                                        color:
                                                                            AppColors.colorFFFFFF,
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              SizedBox(height: 20.h),

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

  void _submitProfileUpdate() {
    final isValid = controller.formKey.currentState?.validate() ?? false;

    if (!isValid) {
      Utilities.showSnackBar(
        title: 'Missing Information',
        message: 'Please complete the required profile fields.',
        isSuccess: false,
      );
      return;
    }

    controller.updateUserProfile();
  }
}
