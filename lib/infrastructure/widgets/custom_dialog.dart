import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final String? email;
  final String title;
  final String subTitle;

  const CustomDialog({
    this.email,
    required this.title,
    required this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      child: SizedBox(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.logo,
                      width: 50.w,
                      height: 50.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.black,
                  ),
                ),

                if(email != null)
                SizedBox(height: 10.h),
                if(email != null)
                Text(
                  email ?? "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingOnly(top: 30.h, bottom: 60.h, left: 20.w, right: 20.w),
            Positioned(
              right: 1.w,
              top: 1.h,
              child: IconButton(
                icon: Icon(Icons.close, color: AppColors.primary, size: 24.sp),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
