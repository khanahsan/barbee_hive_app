import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/component/employee_card2.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/controller/myjob_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class MyJobsScreen extends GetView<MyjobsController> {
  const MyJobsScreen({super.key});

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
          title: "My Applcations",
          leadingIconPath: AppAssets.backIcon,
          showActions: true,

          showHexagon: true,
          actions: [
            SvgPicture.asset(
              AppAssets.bellIcon,
              fit: BoxFit.cover,
              height: 23.h,
              width: 23.w,
              color: AppColors.white,
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
            CustomTextField(
              hintText: "Search jobs here...",
              fillColor: AppColors.color101010,
              cursorColor: AppColors.grey,
              focusedBorderColor: AppColors.grey,
              hintColor: Colors.grey.shade700,
              fontColor: Colors.white,
              filled: true,
              // controller: controller.searchController,
              // onChanged: (value) => controller.filterApplicationsByText(value),
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
            ),
          ],
        ),
      ),
    );
  }
}
