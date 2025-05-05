import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class PricingPlansScreen extends StatelessWidget {
  const PricingPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        separatorBuilder: (context, index) => SizedBox(height: 25.h),
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return pricePlansCard(context: context);
        },
      ),
    );
  }

  Widget pricePlansCard({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(1), // Thickness of the border
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.black], // Adjust as needed
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.black, // Inner background color
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 5.h,
              children: [
                Text(
                  "Free Membership",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  "For Free Users",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  "\$0",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ...[
              "Limited profile views",
              "Ads displayed after every 10-11 profiles",
              "Full-screen ad after the 4th profile view",
              "Upgrade prompt after the 10th & 33rf profiles, linking to membership options",
              "Boost button available for \$0.99 (3-hour boost)",
            ].map((text) => _buildBulletPoint(context, text)),
            SizedBox(height: 20.h),
            CustomBtn(btnTitle: "Get Started", onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: AppColors.primary, size: 20.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 8.h);
  }
}
