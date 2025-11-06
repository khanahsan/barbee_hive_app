import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/controller/pricing_plans_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/widgets/employee_plans_card.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/widgets/employer_plans_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/widgets/custom_appbar.dart';

class PricingPlansScreen extends GetView<PricingPlansController> {
  const PricingPlansScreen({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        showHexagon: false,
        context: context,
        leadingTapFunction: () {
          if (onMenuPressed != null) onMenuPressed!();
        },
        title: 'Pricing Plans',
      ),
      backgroundColor: AppColors.black,
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            controller.errorMessage.value = '';
            controller.onInit();
          },
          child: _bodyWidget(),
        );
      }),
    );
  }

  Widget _bodyWidget() {
    /// SHOW SHIMMER LOADING
    if (controller.isLoading.value) {
      return AppShimmer(
        isList: true,
        width: double.infinity,
        height: 350.h,
        itemCount: 3,
        borderRadius: BorderRadius.circular(15.r),
      ).paddingSymmetric(horizontal: 15.w);
      // return const Center(child: CircularProgressIndicator());
    }

    /// SHOW ERROR MESSAGE
    if (controller.errorMessage.isNotEmpty) {
      return ListView(
        children: [
          SizedBox(height: 300.h),
          Center(
            child: CustomText(
              title: controller.errorMessage.value,
              color: AppColors.white,
              fontSize: 20,
            ),
          ),
        ],
      );
    }

    /// EMPLOYER PLANS
    if (controller.isEmployer.value) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        separatorBuilder: (context, index) => SizedBox(height: 25.h),
        itemCount: controller.plans.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final plan = controller.plans[index];
          return EmployerPlansCard(plan: plan, index: index);
        },
      );
    }

    /// EMPLOYEE PLANS
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      separatorBuilder: (context, index) => SizedBox(height: 25.h),
      itemCount: controller.plans.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final plan = controller.plans[index];
        return EmployeePlansCard(plan: plan, index: index);
      },
    );
  }
}
