import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dropdown.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class CustomJobFilterDialog extends StatelessWidget {
  const CustomJobFilterDialog({
    super.key,
    required this.jobRoles,
    required this.experienceLevels,
    required this.salaryTypes,
    required this.jobTypes,
    required this.selectedJobRole,
    required this.selectedExperience,
    required this.selectedSalary,
    required this.selectedJobType,
    required this.onDone,
    required this.onClear,
    required this.onCloseTap,
  });

  final List<String> jobRoles;
  final List<String> experienceLevels;
  final List<String> salaryTypes;
  final List<String> jobTypes;

  final RxString selectedJobRole;
  final RxString selectedExperience;
  final RxString selectedSalary;
  final RxString selectedJobType;

  final VoidCallback onDone;
  final VoidCallback onClear;
  final VoidCallback onCloseTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Close icon
                Align(
                  alignment: Alignment.topRight,
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

                /// Job Role
                _buildDropdown(
                  hint: "Job Role",
                  selectedValue: selectedJobRole,
                  items: jobRoles,
                ),

                const SizedBox(height: 10),

                /// Experience
                _buildDropdown(
                  hint: "Experience",
                  selectedValue: selectedExperience,
                  items: experienceLevels,
                ),

                const SizedBox(height: 10),

                /// Salary
                _buildDropdown(
                  hint: "Salary",
                  selectedValue: selectedSalary,
                  items: salaryTypes,
                ),

                const SizedBox(height: 10),

                /// Job Type
                _buildDropdown(
                  hint: "Job Type",
                  selectedValue: selectedJobType,
                  items: jobTypes,
                ),

                const SizedBox(height: 20),

                /// Buttons
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
                          onDone();
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
                          onClear();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required RxString selectedValue,
    required List<String> items,
  }) {
    return CustomDropdown(
      hint: hint,
      iconPath: '',
      selectedValue: selectedValue,
      items:
          items
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
      onChanged: (v) => selectedValue.value = v ?? '',
      backgroundColor: AppColors.color000000,
      borderRadius: 10,
      textColor: AppColors.colorFFFFFF,
      dropdownColor: AppColors.colorFF8600,
      borderColor: AppColors.colorA3A3A3,
    );
  }
}
