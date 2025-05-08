import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
        title: "Applications",
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300.h,
            color: Colors.red,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12.w,
                  children: [
                    HexagonAvatar(
                      imagePath: AppAssets.profileImage,
                      width: 80.w,
                      height: 90.h,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alissa Machan",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 22.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: AppColors.colorE0E0E0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 2.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.locationBIcon,
                                height: 15.h,
                                width: 15.w,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "China",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontSize: 10.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      spacing: 10.h,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Job Role",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Year of Experience",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Salary",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Experience level",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 10.h,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Bartender",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "2 Years",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "300\$",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Experience level",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 13.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
