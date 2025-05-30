
import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class EmployerCard extends StatelessWidget {
  final JobData job;

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
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: Row(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.clockIcon,
                        height: 16.h,
                        width: 16.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "${job.remainingHours}hrs",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  "Renew Job in \$1.99",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                onTap: () {
                  LogUtil.logError('job.id ${job.id}');
                  Get.toNamed(Routes.applicationsScreen, arguments: {
                    'jobId': job.id
                  });
                },
                buttonText: "View Applications",
                buttonWidth: 185.w,
                buttonColor: AppColors.color101010,
                borderColor: AppColors.primary,
                buttonHeight: 50.h,
                buttonTextSize: 15.sp,
              ),
              CustomButton(
                onTap: () {
                  //Get.toNamed(Routes.editJobScreen, arguments: job);

                },
                buttonText: "Edit Profile",
                buttonWidth: 185.w,
                buttonColor: AppColors.color101010,
                borderColor: AppColors.primary,
                buttonHeight: 50.h,
                buttonTextSize: 15.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Job Role",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Skills",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Salary",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Experience Level",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Location",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        SizedBox(width: 25.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                job.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                job.skills?.map((skill) => skill.name).join(', ') ?? 'N/A',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15.h),
              Text(
                '\$${job.salaryRange.min}-\$${job.salaryRange.max}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                job.experienceLevel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                '${job.country}, ${job.state}, ${job.city}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14.sp,
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
