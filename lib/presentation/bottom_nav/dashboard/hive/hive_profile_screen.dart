import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../data/model/dashboard_response.dart';
import '../../../../infrastructure/constants/app_colors.dart';
import '../b2b/b2b_fading_carousel.dart';

class HiveProfileScreen extends StatelessWidget {
  const HiveProfileScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        title: "Profile",
        showHexagon: false,
        leadingIconPath: AppAssets.backIcon,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: CustomFadingCarousel(
              showIndicators: false,
              imagePaths: [
                AppAssets.profileImage,
                AppAssets.profileImage,
                AppAssets.profileImage,
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Container(
                  height: 532.h,
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.r),
                      topRight: Radius.circular(20.0.r),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.employer?.businessName ?? "",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          ".6 mi away",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 1.h,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.w,
                              children: [
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Experience",
                                    titleColor: AppColors.white,
                                    isLeftAlign: false,
                                  ),
                                ),
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: currentUser.employer?.positionSeeking?.name ?? "",
                                    titleColor: AppColors.color5E5E5E,
                                    isLeftAlign: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.w,
                              children: [
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Age",
                                    titleColor: AppColors.white,
                                    isLeftAlign: false,
                                  ),
                                ),
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "28 Yr",
                                    titleColor: AppColors.color5E5E5E,
                                    isLeftAlign: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.w,
                              children: [
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Gender",
                                    titleColor: AppColors.white,
                                    isLeftAlign: false,
                                  ),
                                ),
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Male",
                                    titleColor: AppColors.color5E5E5E,
                                    isLeftAlign: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.w,
                              children: [
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Eye Color",
                                    titleColor: AppColors.white,
                                    isLeftAlign: false,
                                  ),
                                ),
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Brown",
                                    titleColor: AppColors.color5E5E5E,
                                    isLeftAlign: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.w,
                              children: [
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Hair Color",
                                    titleColor: AppColors.white,
                                    isLeftAlign: false,
                                  ),
                                ),
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Black",
                                    titleColor: AppColors.color5E5E5E,
                                    isLeftAlign: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.w,
                              children: [
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Resume/Certification",
                                    titleColor: AppColors.white,
                                    isLeftAlign: false,
                                  ),
                                ),
                                Expanded(
                                  child: _seekingTabs(
                                    context: context,
                                    tabTitle: "Black",
                                    titleColor: AppColors.color5E5E5E,
                                    isLeftAlign: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seekingTabs({
    required BuildContext context,
    required String tabTitle,
    required Color titleColor,
    required bool isLeftAlign,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: isLeftAlign ? 35.w : 0.w,
        right: isLeftAlign ? 0.w : 35.w,
      ),

      alignment: isLeftAlign ? Alignment.centerLeft : Alignment.centerRight,
      width: double.infinity,
      height: 50.h,
      color: AppColors.color111111,
      child: Text(
        tabTitle,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
    );
  }
}
