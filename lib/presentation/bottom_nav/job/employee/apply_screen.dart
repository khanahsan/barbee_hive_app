import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/controller/apply_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_dialog.dart';

class ApplyScreen extends GetView<ApplyScreenController> {
  final int? jobId;
  final String? profileImage;
  const ApplyScreen({
    required this.jobId,
    required this.profileImage,
    super.key,
  });

  void applyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Congratulations",
          subTitle: "Your Job Application has been submitted",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('jobId $jobId');
    print('profileImage $profileImage');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0.w,
            right: 0.w,
            top: 25.h,
            child: Image.network(
              profileImage ?? AppAssets.nullProfile,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 1.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: 50.h,
                bottom: 15.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.color101010,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22.r),
                ),
              ),
              // height: kToolbarHeight + 20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 25.sp,
                    ),
                  ),
                  Text(
                    "Apply",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  SvgPicture.asset(
                    AppAssets.settingIcon,
                    height: 22.h,
                    width: 22.w,
                    fit: BoxFit.cover,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              height: 532.h,
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(top: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 16.w),
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
                  spacing: 18.h,
                  children: [
                    CustomTextField(
                      controller: controller.experienceLevel,
                      fontColor: AppColors.textFieldTextColor,
                      hintText: "Experience Level",
                      fillColor: AppColors.textFieldBackground,
                      filled: true,
                      enabledBorderColor: Colors.transparent,
                      prefixIcon: SvgPicture.asset(
                        AppAssets.bagTwoIcon,
                        height: 15.h,
                        width: 15.w,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    CustomTextField(
                      controller: controller.yearsOfExperience,
                      fontColor: AppColors.textFieldTextColor,
                      hintText: "Years of Experience",
                      fillColor: AppColors.textFieldBackground,
                      filled: true,
                      enabledBorderColor: Colors.transparent,
                      prefixIcon: SvgPicture.asset(
                        AppAssets.calenderIcon,
                        height: 15.h,
                        width: 15.w,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    CustomTextField(
                      controller: controller.expectedSalary,
                      fontColor: AppColors.textFieldTextColor,
                      hintText: "Expected Salary",
                      fillColor: AppColors.textFieldBackground,
                      filled: true,
                      enabledBorderColor: Colors.transparent,
                      prefixIcon: SvgPicture.asset(
                        AppAssets.cashIcon,
                        height: 15.h,
                        width: 15.w,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    _buildDropdownField(
                      context,
                      'Job Type',
                      AppAssets.heightLogo,
                      controller.selectedJobType,
                      controller.updateJobType,
                      items: const [
                        DropdownMenuItem(
                          value: 'part-time',
                          child: Text(
                            'Part Time',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'full-time',
                          child: Text(
                            'Full Time',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),
                    Obx(
                      () => CustomButton(
                        buttonText:
                            controller.isLoading.value
                                ? 'Submitting...'
                                : 'Submit Now',
                        buttonWidth: double.infinity,
                        textColor: Colors.white,
                        buttonTextSize: 18.sp,
                        buttonColor: AppColors.primary,
                        buttonHeight: 65.h,
                        onTap:
                            controller.isLoading.value
                                ? null
                                : () {
                                  if (jobId != null) {
                                    controller.applyForJob(jobId!);
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Job ID is missing',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String hint,
    String iconPath,
    RxString selectedValue,
    Function(String?) onChanged, {
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Image.asset(
              iconPath,
              color: AppColors.textFieldTextColor,
              width: 16.w,
              height: 16.h,
            ),
          ),
          Expanded(
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.grey[900],
                  hint: Text(
                    selectedValue.value.isEmpty ? hint : selectedValue.value,
                    style: TextStyle(
                      color: AppColors.textFieldTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  iconEnabledColor: Colors.grey,
                  items: items,
                  onChanged: onChanged,
                  value:
                      selectedValue.value.isEmpty ? null : selectedValue.value,
                  menuMaxHeight: 300.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
