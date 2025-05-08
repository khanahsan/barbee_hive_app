import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_button.dart';

class JobApplicationCard extends StatelessWidget {
  const JobApplicationCard({super.key});

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
        spacing: 20.h,
        children: [
          //Hours Deign Tile
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
              spacing: 5.w,
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
                    spacing: 2.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAssets.clockIcon,
                        height: 16.h,
                        width: 16.w,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "20hrs",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
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

          //Info Tile
          _buildRow(context: context, title: "Job Role", value: "Bartender"),
          CustomButton(
            buttonText: "View Applications",
            buttonWidth: double.infinity,
            buttonColor: AppColors.color101010,
            borderColor: AppColors.primary,
            buttonHeight: 60.h,
            buttonTextSize: 15.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 25.w,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          spacing: 15.h,
          children: [
            Text(
              "Job Role",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            Text(
              "Year of Experience",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            Text(
              "Salary",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            Text(
              "Experience Level",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 15.h,
          children: [
            Text(
              "Bartender",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
            Text(
              "2 Years",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
            Text(
              "300\$",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
            Text(
              "Bartender",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
            Text(
              "USA, Oklahoma,Pasadena",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
