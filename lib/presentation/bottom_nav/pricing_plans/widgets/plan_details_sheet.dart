import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/controller/pricing_plans_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/widgets/custom_btn.dart';
import '../model/pricing_plans_model.dart';

class PlanDetailsBottomSheet extends GetView<PricingPlansController> {
  final SubscriptionPlan plan;

  const PlanDetailsBottomSheet({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(
        color: AppColors.black,

        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Drag Handle
          Center(
            child: Container(
              width: 50.w,
              height: 5.h,
              margin: EdgeInsets.only(bottom: 15.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          /// Plan Title
          CustomText(
            title: plan.name,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.colorFFFFFF,
          ),
          SizedBox(height: 10.h),

          /// Plan Description
          if (plan.type.isNotEmpty)
            CustomText(
              title: plan.type,
              fontSize: 15.sp,
              color: Colors.grey.shade400,
            ),

          SizedBox(height: 20.h),

          /// Features List
          if (plan.features.isNotEmpty) ...[
            CustomText(
              title: "Features",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 10.h),
            ...plan.features!.map(
                  (feature) =>
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.colorFF8600,
                          size: 18,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomText(
                            title: feature,
                            color: Colors.grey.shade300,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ],

          SizedBox(height: 30.h),

          /// Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                title: "Price:",
                color: AppColors.colorFFFFFF,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                title: "\$${plan.price ?? 'N/A'}",
                color: AppColors.colorE4A74C,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          SizedBox(height: 25.h),

          /// Subscribe Button
          Obx(() {
            return CustomBtn(
              isLoading: controller.isApplying.value,
              btnBackgroundColor: AppColors.colorFF8600,
              buttonWidth: double.infinity,
              buttonHeight: 55.h,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              btnTitle: "Subscribe",
              onPressed: () {
                controller.purchaseSubscription(plan: plan);
              },
            );
          }),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
