import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/constants/app_colors.dart';
import '../../../../../infrastructure/constants/app_images.dart';
import '../../../../../infrastructure/navigation/routes.dart';

class EmployeeCard extends StatefulWidget {
  final JobListData job;

  const EmployeeCard({required this.job, super.key});

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard>
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HexagonAvatar(
                    imagePath: widget.job.employer.profileImage ?? '',
                    name: widget.job.recruiterName,
                    width: 70.w,
                    height: 80.h,
                  ),

                  SizedBox(width: 8.w),

                  Expanded(   // 👈 THIS FIXES THE OVERFLOW
                    child: Column(
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
                          widget.job.employer.businessName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorFFFFFF,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 👈 Add ellipsis
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /*   Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8.w,
                children: [
                  *//*HexagonAvatar(
                    imagePath: AppAssets.profileImage,
                    width: 70.w,
                    height: 80.h,
                  ),*//*
                  HexagonAvatar(
                    imagePath: widget.job.employer.profileImage ?? '',
                    // Pass empty string if null
                    name: widget.job.recruiterName,
                    // Pass recruiterName for fallback initial
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
              ),*/
              Divider(color: AppColors.textFieldBackground),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      title: widget.job.skills.name,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorFFFFFF,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
                rowTitle: "\$${widget.job.salaryRange.min}-\$${widget.job.salaryRange.max} per month",
                // "\$${widget.job.salaryRange.min}-${widget.job.salaryRange.max} per month",
              ),

              infoRow(
                iconPath: AppAssets.locationIcon,
                rowTitle: '${widget.job.country?.name}, ${widget.job.state?.name}, ${widget.job.city}',
              ),

              infoRow(
                iconPath: AppAssets.bagIcon,
                rowTitle: widget.job.experienceLevel,
              ),

              if (isExpanded)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3.h,
                  children: [
                    Text(
                      "Job Description",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorFFFFFF,
                      ),
                    ),
                    Text(
                      widget.job.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.color5E5E5E,
                      ),
                    ),
                  ],
                ),
              CustomButton(
                buttonHeight: 60.h,
                buttonText: widget.job.isApplied == 1
                    ? "Applied"
                    : (isExpanded ? "Apply Now" : "View Detail"),
                buttonWidth: double.infinity,
                buttonColor: AppColors.color101010,
                borderColor: AppColors.colorFF8600,
                onTap: widget.job.isApplied == 1
                    ? null // disables the tap if already applied
                    : () {
                  if (isExpanded) {
                    Get.toNamed(
                      Routes.APPLY_VIEW,
                      arguments: {
                        'jobId': widget.job.id,
                        'profileImage': widget.job.image,
                      },
                    );
                  } else {
                    toggleExpanded();
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Widget infoRow({required String iconPath, required String rowTitle}) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisSize: MainAxisSize.min,
  //     spacing: 8.w,
  //     children: [
  //       SvgPicture.asset(
  //         iconPath,
  //         height: 18.h,
  //         width: 18.w,
  //         fit: BoxFit.cover,
  //       ),
  //       Text(
  //         rowTitle,
  //         style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //           fontSize: 15.sp,
  //           fontWeight: FontWeight.w600,
  //           color: AppColors.color5E5E5E,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget infoRow({required String iconPath, required String rowTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max, // allow full width
      spacing: 8.w,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 18.h,
          width: 18.w,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Text(
            rowTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
