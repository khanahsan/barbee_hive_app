import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_application_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_textfield.dart';
import 'employee/find_job_card.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  bool isEmployer = true;

  Future<void> loadRole() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    setState(() {
      isEmployer = role == 2;
    });
  }

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: isEmployer == true ? 0.h : 25.h,
      children: [
        if (isEmployer == false)
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
        if (isEmployer == false)
          Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 18.h),
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return FindJobCard();
              },
            ),
          ),
        if (isEmployer)
          Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return JobApplicationCard();
              },
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
              print("Post a Job clicked");
            },
          ).paddingOnly(bottom: 20.h),
      ],
    ).paddingOnly(left: 15.w, right: 15.w, top: 15.h);
  }
}
