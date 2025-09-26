import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../data/model/dashboard_response.dart';
import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_appbar.dart';
import '../../../../infrastructure/widgets/custom_pdf_view.dart';
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
        leadingTapFunction: Get.back,
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
            child: Image.network(currentUser.profileImage),
            // child: CustomFadingCarousel
            //   showIndicators: false,
            //   imagePaths: List.filled(3, AppAssets.profileImage),
            // ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
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
                          currentUser.employee?.name ?? "",
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
                        SizedBox(height: 25.h),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 1.5.h,
                          children: [
                            _infoRow(
                              context,
                              "Experience",
                              currentUser.employee?.skill?.name ?? "",
                            ),
                            _infoRow(context, "Age", "28 Yr"),
                            _infoRow(
                              context,
                              "Gender",
                              currentUser.employee?.gender ?? "",
                            ),
                            _infoRow(
                              context,
                              "Eye Color",
                              currentUser.employee?.eyeColor?.name ?? "",
                            ),
                            _infoRow(
                              context,
                              "Hair Color",
                              currentUser.employee?.hairColor?.name ?? "",
                            ),
                            _resumeRow(context),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          buttonText: "Send Message",
                          buttonWidth: double.infinity,
                          buttonColor: AppColors.primary,
                          textColor: AppColors.white,
                          buttonHeight: 55.h,
                          buttonTextSize: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 1.5.w,
      children: [
        Expanded(child: _infoTile(context, label, AppColors.white, false)),
        Expanded(child: _infoTile(context, value, AppColors.color5E5E5E, true)),
      ],
    );
  }

  Widget _resumeRow(BuildContext context) {
    final resumePath = currentUser.employee?.resumePath;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 1.5.w,
      children: [
        Expanded(
          child: _infoTile(
            context,
            "Resume/Certification",
            AppColors.white,
            false,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (resumePath != null && resumePath.isNotEmpty) {
                Get.to(() => CustomPdfView(pdfUrl: resumePath));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No resume available')),
                );
              }
            },
            child: _infoTile(
              context,
              "Click View",
              AppColors.color8690FF,
              true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(
    BuildContext context,
    String text,
    Color color,
    bool isLeftAligned,
  ) {
    return Container(
      alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.only(
        left: isLeftAligned ? 35.w : 0,
        right: isLeftAligned ? 0 : 35.w,
      ),
      height: 50.h,
      color: AppColors.color111111,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
