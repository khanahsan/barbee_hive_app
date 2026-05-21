import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

void resumeLockDialog() {
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      backgroundColor: AppColors.textFieldBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r), side: BorderSide(
        color: AppColors.colorFF8600,
        width: 1.5,
      )),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              // Lock Icon
              SvgPicture.asset(
                AppAssets.lockIcon,
                width: 50.w,
                height: 50.h,
                fit: BoxFit.cover,
                color: AppColors.colorFF8600,
              ),
              SizedBox(height: 15.h),

              // Title
              CustomText(
                title: "Resume Locked",
                color: AppColors.colorFFFFFF,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),

              // Description
              CustomText(
                textAlign: TextAlign.center,
                title:
                    "Please upgrade your subscription to view the resume\nand certifications of employees.",
                color: AppColors.lightgrey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 20),

              // Button
              CustomBtn(
                buttonHeight: 55.h,
                btnTitle: 'Upgrade Now',
                btnBackgroundColor: AppColors.colorFF8600,
                fontWeight: FontWeight.w800,
                btnTxtColor: AppColors.colorFFFFFF,
                onPressed: () {
                  Get.back(); // close dialog first

                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.toNamed(
                      Routes.pricingPlansScreen,
                      arguments: {'showBackButton': true},
                    );
                  });
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 15.w, vertical: 25.h),

          // Close button (X)
          Positioned(
            right: 10.w,
            top: 10.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: true,
  );
}
