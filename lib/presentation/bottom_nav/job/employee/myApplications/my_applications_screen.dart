import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_job_filter_dialog.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/component/employee_card2.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/myApplications/controller/my_applications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class MyApplicationsScreen extends GetView<MyApplicationsController> {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: customAppbar(
          context: context,
          leadingTapFunction: () {
            Get.back();
          },
          profileImagePath: controller.userProfileImage ?? '',
          title: "My Applications",
          leadingIconPath: AppAssets.backIcon,
          showActions: true,

          showHexagon: true,
          actions: [
            SvgPicture.asset(
              AppAssets.bellIcon,
              fit: BoxFit.cover,
              height: 23.h,
              width: 23.w,
              color: AppColors.colorFFFFFF,
            ),
          ],
        ),
      ),

      backgroundColor: Colors.black,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        child: Column(
          spacing: 5.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              hintText: "Search jobs here...",
              fillColor: AppColors.color101010,
              fontColor: Colors.white,
              filled: true,
              controller: controller.searchController,
              onChanged: (value) => controller.applyFilters(),
              prefixIcon: SvgPicture.asset(
                AppAssets.searchIcon,
                width: 10.w,
                height: 10.h,
                fit: BoxFit.scaleDown,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return CustomJobFilterDialog(
                        /// Pass dropdown lists
                        jobRoles: controller.skills.map((e) => e.name).toList(),
                        experienceLevels:
                            controller.experienceLevels
                                .map((e) => e.name)
                                .toList(),
                        salaryTypes:
                            controller.salaryTypes.map((e) => e.name).toList(),
                        jobTypes:
                            controller.jobTypes.map((e) => e.name).toList(),

                        /// Pass selected values to bind state
                        selectedJobRole: controller.selectedJobRole,
                        selectedExperience: controller.selectedExperience,
                        selectedSalary: controller.selectedSalary,
                        selectedJobType: controller.selectedJobType,

                        /// Callbacks
                        onDone: controller.applyFilters,
                        onClear: controller.clearFilters,
                      );
                    },
                  );
                },

                /*       onTap: (){

                },*/
                child: SvgPicture.asset(
                  AppAssets.searchFilterIcon,
                  width: 10.w,
                  height: 10.h,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),

            SizedBox(height: 15.h),
            Flexible(
              child: Obx(
                () =>
                    controller.isLoading.value
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.colorFF8600,
                          ),
                        )
                        : controller.filteredJobs.isEmpty
                        ? const Center(
                          child: Text(
                            'No jobs found',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                        : ListView.separated(
                          scrollDirection: Axis.vertical,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 18.h),
                          itemCount: controller.filteredJobs.length,
                          shrinkWrap: true,
                          itemBuilder:
                              (context, index) => EmployeeCard2(
                                job: controller.filteredJobs[index],
                              ),
                        ),
              ),
            ),

            /*    Flexible(
              child: Obx(
                () =>
                    controller.isLoading.value
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.colorFF8600,
                          ),
                        )
                        : controller.appliedJobs.isEmpty
                        ? const Center(
                          child: Text(
                            'No jobs found',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                        : ListView.separated(
                          scrollDirection: Axis.vertical,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 18.h),
                          itemCount: controller.appliedJobs.length,
                          shrinkWrap: true,

                          itemBuilder:
                              (context, index) => EmployeeCard2(
                                job: controller.appliedJobs[index],
                              ),
                        ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
