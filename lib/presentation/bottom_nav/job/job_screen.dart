import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'controller/job_controller.dart';
import 'employee/component/employee_card.dart';
import 'employer/component/employer_card.dart';

class JobScreen extends GetView<JobController> {
  const JobScreen({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmployer = controller.isEmployer.value;
      print('controller.isEmployer.value ${controller.isEmployer.value}');

      return Scaffold(
        appBar: customAppbar(
          context: context,
          leadingTapFunction: () {
            if (onMenuPressed != null) onMenuPressed!();
          },
          title: isEmployer ? 'Job Applications' : 'Find Jobs',
          profileImagePath: controller.userProfileImage.value,
          // actions: [
          //   SvgPicture.asset(AppAssets.bellIcon, height: 24.h, width: 24.w),
          // ],
        ),
        backgroundColor: AppColors.black,
        body: Column(
          spacing: 15.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// SEARCH FIELD
            if (!isEmployer)
              AppTextField(
                hintText: "Search jobs here...",
                fillColor: AppColors.color101010,
                // cursorColor: AppColors.grey,
                // focusedBorderColor: AppColors.grey,
                // hintStyle: TextStyle(color: Colors.grey.shade700),
                fontColor: Colors.white,
                filled: true,
                controller: controller.searchController,
                onChanged:
                    (value) => controller.filterApplicationsByText(value),
                prefixIcon: SvgPicture.asset(
                  AppAssets.searchIcon,
                  width: 10.w,
                  height: 10.h,
                  fit: BoxFit.scaleDown,
                ),
                suffixIcon: SvgPicture.asset(
                  AppAssets.searchFilterIcon,
                  width: 10.w,
                  height: 10.h,
                  fit: BoxFit.scaleDown,
                ),
              ),
            if (!isEmployer) SizedBox(height: 15.h),

            /// EMPLOYEE SECTION
            if (!isEmployer)
              Flexible(
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: controller.fetchEmployeeJobs,
                    // Refresh function
                    color: AppColors.colorFF8600,
                    child:
                        /// SHOW LOADING
                        controller.isLoading.value
                            ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                AppShimmer(
                                  isList: true,
                                  itemCount: 4,
                                  width: double.infinity,
                                  height: 250.h,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ],
                            )
                            /// LIST EMPTY
                            : controller.filteredJobs.isEmpty
                            ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 50.h),
                                Center(
                                  child: Text(
                                    'No jobs found',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            /// LIST NOT EMPTY
                            : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 18.h),
                              itemCount: controller.filteredJobs.length,
                              shrinkWrap: true,
                              itemBuilder:
                                  (context, index) => EmployeeCard(
                                    job: controller.filteredJobs[index],
                                  ),
                            ),
                  ),
                ),
              ),

            /// EMPLOYER SECTION
            if (isEmployer)
              Flexible(
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: controller.fetchEmployerJobs,
                    // Refresh function
                    color: AppColors.colorFF8600,
                    child:
                        /// SHOW LOADING
                        controller.isLoading.value
                            ? AppShimmer(
                              isList: true,
                              itemCount: 5,
                              width: double.infinity,
                              height: 300.h,
                              borderRadius: BorderRadius.circular(15.r),
                            )
                            /// LIST IS EMPTY
                            : controller.employerJobs.isEmpty
                            ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 250.h),
                                Center(
                                  child: CustomText(
                                    title: 'No Jobs Found',
                                    fontSize: 20,
                                    color: AppColors.filterBGColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                            /// LIST IS NOT EMPTY
                            : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 20.h),
                              itemCount: controller.employerJobs.length,
                              shrinkWrap: true,
                              itemBuilder:
                                  (context, index) => EmployerCard(
                                    job: controller.employerJobs[index],
                                  ),
                            ),
                  ),
                ),
              ),

            /// CREATE JOB OPTION (FOR EMPLOYER ONLY)
            if (isEmployer)
              CustomButton(
                buttonText: "Create a Job",
                buttonWidth: double.infinity,
                buttonColor: AppColors.colorFF8600,
                buttonTextSize: 16.sp,
                buttonHeight: 60.h,
                onTap: () {
                  Get.toNamed(Routes.createJobScreen);
                },
              ).paddingOnly(bottom: 20.h),
          ],
        ).paddingOnly(left: 15.w, right: 15.w, top: 15.h),
      );
    });
  }
}
