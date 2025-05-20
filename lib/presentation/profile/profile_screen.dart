import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
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
                      child: Container(
                        // height: 200.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: Image.asset(
                            AppAssets.profileImage,
                            fit: BoxFit.cover,
                          ),
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
                            height: controller.isEditing.value ? null : fullHeight,
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
                                    controller
                                            .userProfile
                                            .value
                                            ?.data
                                            .employee
                                            .name ??
                                        "",
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
                                          text: "Experience",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(text: "  "),
                                        TextSpan(
                                          text:
                                              controller
                                                  .userProfile
                                                  .value
                                                  ?.data
                                                  .employee
                                                  .skill
                                                  .name ??
                                              "",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 50.h),
                                  if (controller.isEditing.value) ...[
                                    SizedBox(
                                      height: 400.h,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 15.h,
                                          children: [
                                            _buildCustomTextField(
                                              hintText: "Name",
                                              controller:
                                                  controller.nameController,
                                              prefixIconPath:
                                                  AppAssets.editIcon,
                                            ),
                                            _buildCustomTextField(
                                              hintText: "Email Address",
                                              controller:
                                                  controller.emailController,
                                              prefixIconPath:
                                                  AppAssets.envelopeIcon,
                                            ),
                                            _buildCustomTextField(
                                              hintText: "Password",
                                              controller:
                                                  controller.nameController,
                                              prefixIconPath:
                                                  AppAssets.lockIcon,
                                            ),
                                            _buildCustomTextField(
                                              hintText: "Confirm Password",
                                              controller:
                                                  controller.nameController,
                                              prefixIconPath:
                                                  AppAssets.lockIcon,
                                            ),
                                            _buildDropdown(
                                              context: context,
                                              value:
                                                  controller
                                                      .selectedExperience
                                                      .value,
                                              hintText: "Experience",
                                              items: controller.experienceList,
                                              onChanged: (val) {
                                                controller
                                                    .selectedExperience
                                                    .value = val ?? '';
                                              },
                                            ),
                                            _buildCustomTextField(
                                              hintText: "MM/DD/YYYY",
                                              controller:
                                                  controller.nameController,
                                              prefixIconPath:
                                                  AppAssets.lockIcon,
                                            ),

                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              spacing: 20.w,
                                              children: [
                                                Expanded(
                                                  child: _buildDropdown(
                                                    context: context,
                                                    value:
                                                        controller
                                                            .selectedExperience
                                                            .value,
                                                    hintText: "Gender",
                                                    items:
                                                        controller
                                                            .experienceList,
                                                    onChanged: (val) {
                                                      controller
                                                          .selectedExperience
                                                          .value = val ?? '';
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildDropdown(
                                                    context: context,
                                                    value:
                                                        controller
                                                            .selectedExperience
                                                            .value,
                                                    hintText: "Height",
                                                    items:
                                                        controller
                                                            .experienceList,
                                                    onChanged: (val) {
                                                      controller
                                                          .selectedExperience
                                                          .value = val ?? '';
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              spacing: 20.w,
                                              children: [
                                                Expanded(
                                                  child: _buildDropdown(
                                                    context: context,
                                                    value:
                                                        controller
                                                            .selectedExperience
                                                            .value,
                                                    hintText: "Eye Color",
                                                    items:
                                                        controller
                                                            .experienceList,
                                                    onChanged: (val) {
                                                      controller
                                                          .selectedExperience
                                                          .value = val ?? '';
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildDropdown(
                                                    context: context,
                                                    value:
                                                        controller
                                                            .selectedExperience
                                                            .value,
                                                    hintText: "Hair Color",
                                                    items:
                                                        controller
                                                            .experienceList,
                                                    onChanged: (val) {
                                                      controller
                                                          .selectedExperience
                                                          .value = val ?? '';
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // _buildCustomDropdown(
                                            //   hintText: "Experience",
                                            //   prefixIconPath: AppAssets.experienceIcon, // Replace with your icon
                                            //   selectedValue: controller.selectedExperience,
                                            //   items: controller.experienceList,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                  CustomBtn(
                                    buttonHeight: 55.h,
                                    btnTitle: 'Edit Profile',
                                    btnBackgroundColor: AppColors.primary,
                                    btnTxtColor: Colors.white,
                                    // width: double.infinity,
                                    onPressed: () {
                                      controller.toggleEditing();
                                    },
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

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required String prefixIconPath,
  }) {
    return CustomTextField(
      fontColor: AppColors.color4C4C4C,
      controller: controller,
      filled: true,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      hintText: hintText,
      prefixIcon: SvgPicture.asset(
        prefixIconPath,
        fit: BoxFit.scaleDown,
        color: AppColors.color4C4C4C,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required BuildContext context,
    String? prefixIconPath,
  }) {
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        // border: Border.all(color: AppColors.colorA3A3A3),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefixIconPath == null) ...[
            SvgPicture.asset(AppAssets.lockIcon),
            SizedBox(width: 30.w),
          ],
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: safeValue,
                hint: Text(
                  hintText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.color4C4C4C,
                    fontSize: 16.sp,
                  ),
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.color4C4C4C),
                items:
                    items.toSet().map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

