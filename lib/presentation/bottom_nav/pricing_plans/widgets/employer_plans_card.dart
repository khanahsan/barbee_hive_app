import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/model/pricing_plans_model.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/widgets/plan_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class EmployerPlansCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final int index;

  const EmployerPlansCard({super.key, required this.plan, required this.index});

  // Different gradients per plan
  static const List<List<Color>> planGradients = [
    [AppColors.color9A5CB4, AppColors.black], // Purple
    [AppColors.color35D79C, AppColors.black], // Green
    [AppColors.colorE74A60, AppColors.black], // Red
    [AppColors.color1894CE, AppColors.black], // Blue
    [AppColors.colorFF8600, AppColors.black], // Orange
  ];

  @override
  Widget build(BuildContext context) {
    final gradientColors = planGradients[index % planGradients.length];
    final primaryColor = gradientColors[0];

    // Static titles for plans
    final List<String> titles = [
      "Profile Views",
      "Free Job Posts",
      "Additional job posting cost",
    ];

    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
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
            /// PLAN NAME
            CustomText(
              title: plan.name,
              fontSize: 25,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 5.h),

            /// PLAN DURATION
            CustomText(
              title: "${plan.durationDisplay} Plan",
              fontSize: 16,
              color: AppColors.colorFFFFFF,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 5.h),

            /// PLAN PRICE
            CustomText(
              title: plan.price == 0 ? "Free" : "\$${plan.price}",
              fontSize: 32,
              color: AppColors.colorFFFFFF,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 20.h),

            /// PLAN FEATURES
            for (int i = 0; i < titles.length; i++)
              if (i < plan.features.length)
                plansItem(
                  title: titles[i],
                  subTitle: plan.features[i],
                  titleColor: primaryColor,
                ),

            /// TRY PLAN OPTION
            if (plan.price != 0) ...[
              SizedBox(height: 20.h),
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
          ],
        ),
      ),
    );
  }

  Widget plansItem({
    required String title,
    required String subTitle,
    required Color titleColor,
  }) {
    return Column(
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
