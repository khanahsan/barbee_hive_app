import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../infrastructure/constants/app_colors.dart';
import '../infrastructure/constants/app_images.dart';
import '../infrastructure/widgets/custom_btn.dart';

class JobCard extends StatefulWidget {
  const JobCard({super.key});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> with SingleTickerProviderStateMixin {
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
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.color101010,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bartender",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      "Full Time",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              infoRow(
                iconPath: AppAssets.containerIcon,
                rowTitle: "\$3000-3500 per month",
              ),

              infoRow(
                iconPath: AppAssets.locationIcon,
                rowTitle: "Pasadena Oklahoma",
              ),

              infoRow(iconPath: AppAssets.bagIcon, rowTitle: "5-6 years"),

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
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      "This is a detailed job description for the bartender role. Candidates must have at least 5 years of experience in a similar position and excellent customer service skills.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.color5E5E5E,
                      ),
                    ),
                  ],
                ),
              CustomBtn(
                btnTitle: isExpanded ? "Apply Now" : "View Detail",
                onPressed: toggleExpanded,
                btnBackgroundColor: AppColors.color101010,
                borderColor: AppColors.primary,
              ),
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
