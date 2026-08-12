import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

/// Shown when an employee tries to complete their profile without having
/// uploaded a resume/certification. Lets them either continue without it
/// or go back to upload it now.
void showResumeReminderDialog({
  required VoidCallback onContinue,
  required VoidCallback onUploadNow,
}) {
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      backgroundColor: AppColors.colorFFFFFF,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: const BorderSide(color: AppColors.colorE0E0E0, width: 1),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25.h),

              Image.asset(AppAssets.resumeReminder, width: 120.w, height: 120.h, fit: BoxFit.cover,),
              SizedBox(height: 20.h),

              // Title
              CustomText(
                fontFamily: "Inter",
                title: "Complete Your Profile Later",
                textAlign: TextAlign.center,
                color: AppColors.color000000,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 12.h),

              // Description
              CustomText(
                height: 1.8,
                textAlign: TextAlign.center,
                title:
                    "You can continue without uploading a resume or certifications today. You have 7 days to upload them before your profile is placed on hold.  Profiles with resumes and verified credentials are more likely to get hired.",
                color: AppColors.color000000,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ).paddingSymmetric(horizontal: 5.w),
              SizedBox(height: 40.h),

              Row(
                spacing: 10.w,
                children: [
                  Expanded(
                    child: CustomBtn(
                      buttonHeight: 50.h,
                      btnTitle: 'Continue',
                      btnBackgroundColor: AppColors.colorFF8600,
                      btnTxtColor: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w700,
                      showShadow: false,
                      onPressed: () {
                        Get.back(); // close dialog first
                        onContinue();
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomBtn(
                      buttonHeight: 50.h,
                      btnTitle: 'Upload Now',
                      btnBackgroundColor: AppColors.colorFFFFFF,
                      btnTxtColor: AppColors.colorFF8600,
                      borderColor: AppColors.colorFF8600,
                      borderWidth: 1.5,
                      fontWeight: FontWeight.w700,
                      showShadow: false,
                      onPressed: () {
                        Get.back(); // close dialog first
                        onUploadNow();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w, vertical: 25.h),

          // Close button (X)
          Positioned(
            right: 12.w,
            top: 12.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.close,
                color: AppColors.colorFF8600,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: true,
  );
}
