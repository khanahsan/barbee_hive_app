import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'controller/job_controller.dart';
import 'employee/component/employee_card.dart';
import 'employer/component/employer_card.dart';

class JobScreen extends GetView<JobController> {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmployer = controller.isEmployer.value;
      print('controller.isEmployer.value ${controller.isEmployer.value}');

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isEmployer)
            CustomTextField(
              hintText: "Search jobs here...",
              enabledBorderColor: AppColors.color2E2E2E,
              fillColor: AppColors.color101010,
              filled: true,
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
          if (!isEmployer)
            Flexible(
              child: Obx(
                () =>
                    controller.isLoadingEmployee.value
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : controller.employeeJobs.isEmpty
                        ? const Center(
                          child: Text(
                            'No jobs found',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                        : ListView.separated(
                          separatorBuilder:
                              (context, index) => SizedBox(height: 18.h),
                          itemCount: controller.employeeJobs.length,
                          shrinkWrap: true,
                          itemBuilder:
                              (context, index) => EmployeeCard(
                                job: controller.employeeJobs[index],
                              ),
                        ),
              ),
            ),
          if (isEmployer)
            Flexible(
              child: Obx(
                () =>
                    controller.isLoadingEmployer.value
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : controller.employerJobs.isEmpty
                        ? const Center(
                          child: Text(
                            'No jobs found',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                        : ListView.separated(
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
          if (isEmployer)
            CustomButton(
              buttonText: "Create a Job",
              buttonWidth: double.infinity,
              buttonColor: AppColors.primary,
              buttonTextSize: 16.sp,
              buttonHeight: 60.h,
              onTap: () {
                Get.toNamed(Routes.createJobScreen);
              },
            ).paddingOnly(bottom: 20.h),
        ],
      ).paddingOnly(left: 15.w, right: 15.w, top: 15.h);
    });
  }
}
