import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class EmployerCard extends StatelessWidget {
  final JobListData job;

  const EmployerCard({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.color101010,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hours Design Tile
          Container(
            padding: EdgeInsets.only(
              left: 2.w,
              right: 5.w,
              top: 1.5.h,
              bottom: 1.5.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: AppColors.colorFF8600, width: 1),
            ),
            child: Row(
              spacing: 5.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.color282828,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      bottomLeft: Radius.circular(5.r),
                    ),
                  ),
                  child: Row(
                    spacing: 2.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.clockIcon,
                        height: 17.h,
                        width: 17.w,
                        fit: BoxFit.cover,
                      ),
                      CustomText(
                        title: "${job.remainingHours}hrs",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorFFFFFF,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Extend Job in \$1.99",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorFF8600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.colorFF8600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Info Tile
          _buildRow(context: context),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonWidth: 0.w,
                  onTap: () {
                    LogUtil.logError('job.id ${job.id}');
                    Get.toNamed(
                      Routes.applicationsScreen,
                      arguments: {'jobId': job.id},
                    );
                  },
                  buttonText: "View Applications",
                  buttonColor: AppColors.color101010,
                  borderColor: AppColors.colorFF8600,
                  buttonHeight: 50.h,
                  buttonTextSize: 15.sp,
                ),
              ),
              SizedBox(width: 10.w), // spacing between buttons
              Expanded(
                child: CustomButton(
                  buttonWidth: 0.w,
                  onTap: () {
                    Get.toNamed(Routes.jobUpdateScreen, arguments: job);
                  },
                  buttonText: "Edit Job",
                  buttonColor: AppColors.color101010,
                  borderColor: AppColors.colorFF8600,
                  buttonHeight: 50.h,
                  buttonTextSize: 15.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required BuildContext context}) {
    return Row(
      spacing: 20.w,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              title: "Job Role",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Experience Level",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Salary",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Job Type",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Location",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
          ],
        ),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                title: job.title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
              SizedBox(height: 15.h),

              CustomText(
                title: job.experienceLevel,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
              SizedBox(height: 15.h),

              CustomText(
                title: '\$${job.salaryRange.min} - ${job.salaryRange.max}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
              SizedBox(height: 15.h),

              CustomText(
                title: job.jobType.name,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
              SizedBox(height: 15.h),

              SizedBox(
                width: 150.w,
                child: CustomText(
                  textOverflow: TextOverflow.ellipsis,
                  title:
                      '${job.country?.name}, ${job.state?.name}, ${job.city}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
