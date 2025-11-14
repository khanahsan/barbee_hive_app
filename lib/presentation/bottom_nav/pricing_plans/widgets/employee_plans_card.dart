import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/model/pricing_plans_model.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/widgets/plan_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class EmployeePlansCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final int index;

  const EmployeePlansCard({super.key, required this.plan, required this.index});

  static const List<List<Color>> planGradients = [
    [AppColors.colorFF8600, AppColors.black], // Purple
    [AppColors.color9F7857, AppColors.black], // Green
    [AppColors.colorB1B1B1, AppColors.black], // Red
    [AppColors.colorE4A74C, AppColors.black], // Blue
    [AppColors.colorD2D7D3, AppColors.black], // Orange
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = planGradients[index % planGradients.length];
    final primaryColor = gradient.first;

    return Container(
      padding: EdgeInsets.all(1), // Thickness of the border
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.colorFF8600, AppColors.black],
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.black,
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
                /// PLAN NAME
                CustomText(
                  title: plan.name,
                  fontSize: 25,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),

                /// PLAN DURATION
                CustomText(
                  title: "${plan.durationDisplay} Plan",
                  fontSize: 16,
                  color: AppColors.colorFFFFFF,
                  fontWeight: FontWeight.w400,
                ),

                /// PLAN PRICE
                CustomText(
                  title: plan.price == 0 ? "Free" : "\$${plan.price}",
                  fontSize: 25,
                  color: AppColors.colorFFFFFF,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(height: 20.h),

            /// PLAN FEATURES (SHOW ONLY FOR FREE ONE)
            if (plan.price == 0) ...[
              ...plan.features.map((text) => _buildBulletPoint(text)),
              SizedBox(height: 20.h),
            ],

            /// PLAN DESCRIPTION (SHOW ONLY FOR PAID ONE)
            if (plan.price != 0)
              plansItem(
                title: 'Description',
                subTitle: plan.features[0].toString(),
                titleColor: primaryColor,
              ),

            /// TRY PLAN OPTION
            CustomButton(
              onTap: () {
                log('CALLING');
                if (plan == null) {
                  log('Plan is null, cannot open details.');
                  return;
                }

                Get.bottomSheet(
                  PlanDetailsBottomSheet(plan: plan),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },

              buttonText: "Get Started",
              buttonWidth: double.infinity,
              buttonHeight: 52.h,
              buttonTextSize: 16.sp,
              buttonTextWeight: FontWeight.w600,
              buttonColor: AppColors.colorFF8600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: AppColors.colorFF8600, size: 23.sp),
        Expanded(
          child: CustomText(
            title: text,
            fontSize: 16,
            color: AppColors.colorFFFFFF,
            fontWeight: FontWeight.w400,
            maxLines: 3,
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 8.h);
  }

  Widget plansItem({
    required String title,
    required String subTitle,
    required Color titleColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        CustomText(
          title: title,
          fontSize: 16,
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          title: subTitle,
          fontSize: 16,
          color: AppColors.colorFFFFFF,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
