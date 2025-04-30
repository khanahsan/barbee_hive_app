import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'job_card.dart';

class FindJobScreen extends StatelessWidget {
  const FindJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 25.h,
        children: [
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
          Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 18.h),
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return JobCard();
              },
            ),
          ),
        ],
      ).paddingOnly(left: 15.w, right: 15.w, top: 15.h),
    );
  }

  // Widget jobCard({required BuildContext context}) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
  //     decoration: BoxDecoration(
  //       color: AppColors.color101010,
  //       borderRadius: BorderRadius.circular(10.r),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       spacing: 15.h,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Bartender",
  //               style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //                 fontSize: 24.sp,
  //                 fontWeight: FontWeight.w600,
  //                 color: AppColors.white,
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
  //               decoration: BoxDecoration(
  //                 color: AppColors.primary,
  //                 borderRadius: BorderRadius.circular(5.r),
  //               ),
  //               child: Text(
  //                 "Full Time",
  //                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //                   fontSize: 12.sp,
  //                   fontWeight: FontWeight.w600,
  //                   color: AppColors.white,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         infoRow(
  //           context: context,
  //           iconPath: AppAssets.containerIcon,
  //           rowTitle: "\$3000-3500 per month",
  //         ),
  //         infoRow(
  //           context: context,
  //           iconPath: AppAssets.locationIcon,
  //           rowTitle: "Pasadena Oklahoma",
  //         ),
  //         infoRow(
  //           context: context,
  //           iconPath: AppAssets.bagIcon,
  //           rowTitle: "5-6 years",
  //         ),
  //         CustomBtn(
  //           btnTitle: "View Detail",
  //           onPressed: () {},
  //           btnBackgroundColor: AppColors.color101010,
  //           borderColor: AppColors.primary,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget infoRow({
  //   required BuildContext context,
  //   required String iconPath,
  //   required String rowTitle,
  // }) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     spacing: 5.w,
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
  //           color: AppColors.white,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
