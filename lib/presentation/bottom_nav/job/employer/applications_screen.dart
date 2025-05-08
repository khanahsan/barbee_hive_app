import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildDropdown({
      required String label,
      required String? value,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return DropdownButtonFormField<String>(
        dropdownColor: AppColors.color101010,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.colorA3A3A3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.colorA3A3A3),
          ),
        ),
        hint: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15.sp,
            color: AppColors.colorA3A3A3,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconEnabledColor: AppColors.colorA3A3A3,
        value: value,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.colorA3A3A3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
        onChanged: onChanged,
      );
    }

    void _showFilterDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          String? selectedPosition;
          String? selectedAge;
          String? selectedGender;
          String? selectedExperience;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      textAlign: TextAlign.center,
                      "Search Filter",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 18.h),
                    _buildDropdown(
                      label: "Positions",
                      value: selectedPosition,
                      items: ["Bartender", "Chef", "Waiter"],
                      onChanged:
                          (value) => setState(() => selectedPosition = value),
                    ),
                    SizedBox(height: 18.h),
                    _buildDropdown(
                      label: "Age",
                      value: selectedAge,
                      items: ["18-25", "26-35", "36-50"],
                      onChanged: (value) => setState(() => selectedAge = value),
                    ),
                    SizedBox(height: 18.h),
                    _buildDropdown(
                      label: "Gender",
                      value: selectedGender,
                      items: ["Male", "Female", "Other"],
                      onChanged:
                          (value) => setState(() => selectedGender = value),
                    ),
                    SizedBox(height: 18.h),
                    _buildDropdown(
                      label: "Experience",
                      value: selectedExperience,
                      items: ["<1 year", "1-3 years", "3+ years"],
                      onChanged:
                          (value) => setState(() => selectedExperience = value),
                    ),
                    SizedBox(height: 18.h),
                    CustomButton(
                      buttonText: "Done",
                      buttonWidth: double.infinity,
                      buttonTextSize: 15.sp,
                      buttonColor: AppColors.primary,
                      buttonHeight: 55.h,
                      borderRadius: 10.r,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
        title: "Applications",
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20.h,
        children: [
          CustomTextField(
            readonly: true,
            enabledBorderColor: AppColors.color2E2E2E,
            fillColor: AppColors.color101010,
            filled: true,
            hintText: "Search by Filters",
            suffixIcon: GestureDetector(
              onTap: () => _showFilterDialog(context),
              child: SvgPicture.asset(
                AppAssets.searchFilterIcon,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _applicationsCard(context: context);
              },
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 15.w, vertical: 15.h),
    );
  }

  Widget _applicationsCard({required BuildContext context}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 8.h, left: 8.w, right: 8.w, top: 5.h),
      decoration: BoxDecoration(
        color: AppColors.color101010,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 15.w,
            children: [
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 80.w,
                height: 90.h,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alissa Machan",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 22.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.colorE0E0E0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 2.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.locationBIcon,
                          height: 15.h,
                          width: 15.w,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "China",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 10.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 15.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                spacing: 10.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Job Role",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Year of Experience",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Salary",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Experience level",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                spacing: 10.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bartender",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "2 Years",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "300\$",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Bartender",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: "View Profile",
                  buttonWidth: double.infinity,
                  buttonColor: AppColors.color101010,
                  borderColor: AppColors.primary,
                  buttonTextSize: 15.sp,
                  buttonHeight: 55.h,
                ),
              ),
              Expanded(
                child: CustomButton(
                  buttonText: "Send Message",
                  buttonWidth: double.infinity,
                  buttonColor: AppColors.primary,
                  buttonTextSize: 15.sp,
                  buttonHeight: 55.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
