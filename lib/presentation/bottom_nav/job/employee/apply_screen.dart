import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_dialog.dart';

class ApplyScreen extends StatelessWidget {
  const ApplyScreen({super.key});

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0.w,
            right: 0.w,
            top: 25.h,
            child: Image.asset(AppAssets.sampleCoverImage, fit: BoxFit.cover),
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

                    DropdownButtonFormField<String>(
                      dropdownColor: AppColors.textFieldBackground,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          AppAssets.jobTypeIcon,
                          height: 15.h,
                          width: 15.w,
                          fit: BoxFit.scaleDown,
                        ),
                        filled: true,
                        fillColor: AppColors.textFieldBackground,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 12.w,
                        ),
                      ),
                      style: TextStyle(
                        color: AppColors.textFieldTextColor,
                        fontSize: 17.sp,
                      ),
                      hint: Text(
                        "Job Type",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 17.sp,
                          color: AppColors.textFieldTextColor,
                        ),
                      ),
                      items:
                          ['Monthly', 'Yearly', 'Weekly']
                              .map(
                                (type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        // Handle selection logic
                      },
                    ),

                    CustomButton(
                      buttonText: 'Submit Now',
                      buttonWidth: double.infinity,
                      textColor: Colors.white,
                      buttonTextSize: 18.sp,
                      buttonColor: AppColors.primary,
                      buttonHeight: 65.h,
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
}
