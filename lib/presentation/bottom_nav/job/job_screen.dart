import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/dashboardController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';
import 'controller/job_controller.dart';
import 'employee/component/employee_card.dart';
import 'employee/component/job_filter_dialog.dart';
import 'employer/component/employer_card.dart';

class JobScreen extends GetView<JobController> {
  const JobScreen({super.key, this.onMenuPressed, this.showBackButton});

  final VoidCallback? onMenuPressed;
  final bool? showBackButton;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmployer = controller.isEmployer.value;
      print('controller.isEmployer.value ${controller.isEmployer.value}');

      return Scaffold(
        appBar: customAppbar(
          context: context,
          leadingTapFunction: () {
            if (showBackButton == true) {
              Get.back();
            } else {
              if (onMenuPressed != null) onMenuPressed!();
            }
          },
          leadingIconPath: showBackButton == true ? AppAssets.backIcon : null,
          // title: isEmployer ? 'Job Applications' : 'Find Jobs',
          title: '',
          titleWidget: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12, color: AppColors.colorFFFFFF),
              children: [
                TextSpan(
                  text: 'Bar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 32.sp,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'Bee',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 32.sp,
                    color: AppColors.colorFF8600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: " "),

                TextSpan(
                  text: 'INC.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          profileImagePath: Get.find<DashboardController>().userProfileImage.value,
        ),

        backgroundColor: AppColors.black,
        body: Column(
          spacing: 5.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// SEARCH FIELD
            if (!isEmployer) ...[
              AppTextField(
                hintText: "Search jobs here...",
                fillColor: AppColors.color101010,
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
                suffixIcon: GestureDetector(
                  onTap: () async {

                    print("12333");
                    // Fetch all dropdown data before opening

                    showDialog(
                      context: context,
                      builder: (_) {
                        return JobFilterDialog(
                          onCloseTap: (){
                            if (Navigator.of(context, rootNavigator: true).canPop()) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                          onDone: (){
                            if (Navigator.of(context, rootNavigator: true).canPop()) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                            controller.applyFilters();
                          },
                          onClear:(){
                            if (Navigator.of(context, rootNavigator: true).canPop()) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                            controller.clearFilters();
                          },
                        );
                      });

                  },
                  child: SvgPicture.asset(
                    AppAssets.searchFilterIcon,
                    width: 10.w,
                    height: 10.h,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],

            /// EMPLOYEE SECTION
            if (!isEmployer)
              Flexible(
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: () async {
                      //await controller.fetchDropdownData();
                      await controller.fetchEmployeeJobs();
                    },
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
                              padding: EdgeInsets.zero,
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
                    onRefresh: () async {
                      controller.fetchEmployerJobs();
                    },
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
                  Get.toNamed(Routes.jobPostingScreen);
                },
              ).paddingOnly(bottom: 20.h),
          ],
        ).paddingOnly(left: 15.w, right: 15.w, top: 15.h),
      );
    });
  }

  Widget _buildDropdown({
    required String hint,
    required String iconPath,
    required RxString selectedValue,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return CustomDropdown(
      hint: hint,
      iconPath: iconPath,
      selectedValue: selectedValue,
      onChanged: onChanged,
      validator: validator,
      items: items,
    );
  }
}
