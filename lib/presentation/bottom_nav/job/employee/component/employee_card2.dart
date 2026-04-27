import 'package:barbee_hive_app/data/model/applied_job_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class EmployeeCard2 extends StatefulWidget {
  final AppliedJobData job;
  const EmployeeCard2({required this.job, super.key});

  @override
  State<EmployeeCard2> createState() => _EmployeeCard2State();
}

class _EmployeeCard2State extends State<EmployeeCard2>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isExpanded) toggleExpanded();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.color101010,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8.w,
                children: [
                  HexagonAvatar(
                    imagePath:
                        widget.job.employer.profileImage ??
                        '', // Pass empty string if null
                    name:
                        widget
                            .job
                            .recruiterName, // Pass recruiterName for fallback initial
                    width: 70.w,
                    height: 80.h,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Posted By",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorFF8600,
                        ),
                      ),
                      Text(
                        widget.job.recruiterName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorFFFFFF,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: AppColors.textFieldBackground),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      //   widget.job.skills?.map((skill) => skill.name).join(', ') ?? 'N/A',
                      widget.job.skills?.name ?? 'N/A',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorFFFFFF,
                      ),
                      overflow: TextOverflow.ellipsis, // Truncate long text
                      maxLines: 1, // Limit to one line
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.colorFF8600,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      widget.job.jobType.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorFFFFFF,
                      ),
                    ),
                  ),
                ],
              ),
              infoRow(
                iconPath: AppAssets.containerIcon,
                rowTitle: "\$${widget.job.salaryRange.min} per month",
                // "\$${widget.job.salaryRange.min}-${widget.job.salaryRange.max} per month",
              ),

              infoRow(
                iconPath: AppAssets.locationIcon,
                rowTitle: widget.job.city,
              ),

              infoRow(
                iconPath: AppAssets.bagIcon,
                rowTitle: widget.job.experienceLevel,
              ),
              Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorFF8600),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "Applied",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.colorFFFFFF,
                    ),
                  ),
                ),
              ),

              // if (isExpanded)
              //   Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     spacing: 3.h,
              //     children: [
              //       Text(
              //         "Job Description",
              //         style: Theme.of(context).textTheme.titleSmall?.copyWith(
              //           fontSize: 16.sp,
              //           fontWeight: FontWeight.w600,
              //           color: AppColors.white,
              //         ),
              //       ),
              //       Text(
              //         widget.job.description,
              //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //           fontSize: 14.sp,
              //           color: AppColors.color5E5E5E,
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow({required String iconPath, required String rowTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 18.h,
          width: 18.w,
          fit: BoxFit.cover,
        ),
        Text(
          rowTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.color5E5E5E,
          ),
        ),
      ],
    );
  }
}
