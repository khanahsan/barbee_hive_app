import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_btn.dart';

class SelectRoleView extends StatelessWidget {
  const SelectRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'account type',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // BarBee Logo
            Image.asset(
              AppAssets.logo, // Your BarBee logo with hexagonal border
              width: 200.w,
              //height: 120.h,
            ),
            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.only(top: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.r),
                  topRight: Radius.circular(20.0.r),
                ),
              ),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.h,
                  children: [
                    SizedBox(height: 15.h,),
                    const Text(
                      'Choose an account type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'Choose an account type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),),
            ),
            /* SizedBox(height: 10.h),
            const Text(
              'BarBee INC.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            // Gold line with Hero widget for animation
            Hero(
              tag: 'gold_line', // Shared tag for animation
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w), // Padding on sides
                  height: 8.h, // Thicker line
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(50.r), // More rounded corners (pill shape)
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            const Text(
              'Choose an account type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  btnTitle: 'Employee',
                  btnBackgroundColor: Colors.orange,
                  btnTxtColor: Colors.white,
                  width: 120.w,
                  height: 45.h,
                  borderRadius: 25.r,
                  onPressed: () {
                    Get.toNamed(Routes.SIGN_UP_VIEW); // Navigate to Sign Up screen
                  },
                ),
                SizedBox(width: 20.w),
                CustomButton(
                  btnTitle: 'Employer',
                  btnBackgroundColor: Colors.orange,
                  btnTxtColor: Colors.white,
                  width: 120.w,
                  height: 45.h,
                  borderRadius: 25.r,
                  onPressed: () {
                    // Navigate to Employer sign-up screen if needed
                  },
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
