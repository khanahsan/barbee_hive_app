/*
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dropdown.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/widgets/custom_btn.dart';

class JobFilterDialog extends GetView<JobController> {
  const JobFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // Make it full width
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 15.w),
            // Add vertical margin so it's not stuck at top
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child:
                controller.skills.isEmpty ||
                        controller.experienceLevels.isEmpty ||
                        controller.salaryTypes.isEmpty ||
                        controller.jobTypes.isEmpty
                    ? SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.colorFF8600,
                        ),
                      ),
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Header with title & close icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: "Search Filter",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Get.back<void>(),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.colorFF8600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Job Role Dropdown
                        _buildDropdown(
                          hint: "Job Role",
                          iconPath: 'assets/icons/job_icon.svg',
                          selectedValue: controller.selectedJobRole,
                          items:
                              controller.skills
                                  .map(
                                    (role) => DropdownMenuItem(
                                      value: role.name,
                                      child: Text(role.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) =>
                                  controller.selectedJobRole.value = val ?? '',
                        ),
                        const SizedBox(height: 10),

                        // Experience Dropdown
                        _buildDropdown(
                          hint: "Experience",
                          iconPath: 'assets/icons/experience_icon.svg',
                          selectedValue: controller.selectedExperience,
                          items:
                              controller.experienceLevels
                                  .map(
                                    (exp) => DropdownMenuItem(
                                      value: exp.name,
                                      child: Text(exp.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) =>
                                  controller.selectedExperience.value =
                                      val ?? '',
                        ),
                        const SizedBox(height: 10),

                        // Salary Dropdown
                        _buildDropdown(
                          hint: "Salary",
                          iconPath: 'assets/icons/salary_icon.svg',
                          selectedValue: controller.selectedSalary,
                          items:
                              controller.salaryTypes
                                  .map(
                                    (sal) => DropdownMenuItem(
                                      value: sal.name,
                                      child: Text(sal.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) =>
                                  controller.selectedSalary.value = val ?? '',
                        ),
                        const SizedBox(height: 10),

                        // Job Type Dropdown
                        _buildDropdown(
                          hint: "Job Type",
                          iconPath: 'assets/icons/job_icon.svg',
                          selectedValue: controller.selectedJobType,
                          items:
                              controller.jobTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type.name,
                                      child: Text(type.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) =>
                                  controller.selectedJobType.value = val ?? '',
                        ),
                        const SizedBox(height: 20),

                        Row(
                          spacing: 10.w,
                          children: [
                            Expanded(
                              child: CustomBtn(
                                borderRadius: 30,
                                buttonHeight: 52.h,
                                btnTitle: "Done",
                                btnBackgroundColor: AppColors.colorFF8600,
                                btnTxtColor: Colors.white,
                                onPressed: () {
                                  Get.back<void>();
                                  controller.applyFilters();
                                },
                              ),
                            ),

                            Expanded(
                              child: CustomBtn(
                                borderRadius: 30,
                                buttonHeight: 52.h,
                                btnTitle: "Clear Filter",
                                btnBackgroundColor: Colors.white,
                                btnTxtColor: AppColors.colorFF8600,
                                borderColor: AppColors.colorFF8600,
                                borderWidth: 1.5,
                                onPressed: () {
                                  Get.back<void>();
                                  controller.clearFilters();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        ),
      );
    });
  }

  Widget _buildDropdown({
    required String hint,
    required String iconPath,
    required RxString selectedValue,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return CustomDropdown(
      hint: hint,
      iconPath: '',
      selectedValue: selectedValue,
      items: items,
      onChanged: onChanged,
      backgroundColor: AppColors.color000000,
      borderRadius: 10,
      textColor: AppColors.colorFFFFFF,
      dropdownColor: AppColors.colorFF8600,
      borderColor: AppColors.colorA3A3A3,
    );
  }
}
*/

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dropdown.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/widgets/custom_btn.dart';

class JobFilterDialog extends GetView<JobController> {
  const JobFilterDialog({
    super.key,
    required this.onCloseTap,
    required this.onClear,
    required this.onDone,
  });

  final VoidCallback onDone;
  final VoidCallback onClear;
  final VoidCallback onCloseTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      return WillPopScope(
        onWillPop: () async => false, // Disable Android back button
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth,
                margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 15.w),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child:
                    controller.skills.isEmpty ||
                            controller.experienceLevels.isEmpty ||
                            controller.salaryTypes.isEmpty ||
                            controller.jobTypes.isEmpty
                        ? SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.colorFF8600,
                            ),
                          ),
                        )
                        : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Header with centered title & close icon
                            Align(
                              alignment: AlignmentGeometry.topRight,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: onCloseTap,
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.colorFF8600,
                                ),
                              ),
                            ),
                            Center(
                              child: CustomText(
                                title: "Search Filter",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.color000000,
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Job Role Dropdown
                            _buildDropdown(
                              hint: "Job Role",
                              iconPath: 'assets/icons/job_icon.svg',
                              selectedValue: controller.selectedJobRole,
                              items: controller.skills,
                              onChanged:
                                  (val) =>
                                      controller.selectedJobRole.value =
                                          val ?? '',
                            ),
                            const SizedBox(height: 10),

                            // Experience Dropdown
                            _buildDropdown(
                              hint: "Experience",
                              iconPath: 'assets/icons/experience_icon.svg',
                              selectedValue: controller.selectedExperience,
                              items: controller.experienceLevels,
                              onChanged:
                                  (val) =>
                                      controller.selectedExperience.value =
                                          val ?? '',
                            ),
                            const SizedBox(height: 10),

                            // Salary Dropdown
                            _buildDropdown(
                              hint: "Salary",
                              iconPath: 'assets/icons/salary_icon.svg',
                              selectedValue: controller.selectedSalary,
                              items: controller.salaryTypes,
                              onChanged:
                                  (val) =>
                                      controller.selectedSalary.value =
                                          val ?? '',
                            ),
                            const SizedBox(height: 10),

                            // Job Type Dropdown
                            _buildDropdown(
                              hint: "Job Type",
                              iconPath: 'assets/icons/job_icon.svg',
                              selectedValue: controller.selectedJobType,
                              items: controller.jobTypes,
                              onChanged:
                                  (val) =>
                                      controller.selectedJobType.value =
                                          val ?? '',
                            ),
                            const SizedBox(height: 20),

                            // Buttons
                            Row(
                              spacing: 10.w,
                              children: [
                                Expanded(
                                  child: CustomBtn(
                                    borderRadius: 30,
                                    buttonHeight: 52.h,
                                    btnTitle: "Done",
                                    btnBackgroundColor: AppColors.colorFF8600,
                                    btnTxtColor: Colors.white,
                                    onPressed: onDone,
                                  ),
                                ),
                                Expanded(
                                  child: CustomBtn(
                                    borderRadius: 30,
                                    buttonHeight: 52.h,
                                    btnTitle: "Clear Filter",
                                    btnBackgroundColor: Colors.white,
                                    btnTxtColor: AppColors.colorFF8600,
                                    borderColor: AppColors.colorFF8600,
                                    borderWidth: 1.5,
                                    onPressed: onClear,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDropdown({
    required String hint,
    required String iconPath,
    required RxString selectedValue,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return CustomDropdown(
      hint: hint,
      iconPath: '',
      selectedValue: selectedValue,
      items: items,
      onChanged: onChanged,
      backgroundColor: AppColors.color000000,
      borderRadius: 10,
      textColor: AppColors.colorFFFFFF,
      dropdownColor: AppColors.color4A4A4A,
      borderColor: AppColors.colorA3A3A3,
    );
  }
}
