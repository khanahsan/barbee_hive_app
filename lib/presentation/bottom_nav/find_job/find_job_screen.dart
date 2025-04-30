import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
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
}
