import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/b2b/b2b_fading_carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'controller/applicant_profile_controller.dart';




class ApplicantProfileScreen extends GetView<ApplicantProfileController> {
  const ApplicantProfileScreen({super.key});

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
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: AppColors.colorFF8600))
            : controller.errorMessage.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              CustomButton(
                buttonText: 'Retry',
                onTap: () => controller.fetchProfile(Get.arguments?['userId'] ?? 38),
                buttonWidth: 100.w,
                buttonColor: AppColors.colorFF8600,
                buttonHeight: 40.h,
                buttonTextSize: 16.sp,
              ),
            ],
          ),
        )
            : controller.profile.value == null
            ? Center(
          child: Text(
            'No profile data',
            style: TextStyle(color: AppColors.white, fontSize: 16.sp),
          ),
        )
            : Stack(
          children: [
            Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              child: CustomFadingCarousel(
                showIndicators: false,
                imagePaths: [
                  controller.profile.value!.profileImage ?? AppAssets.profileImage,
                  controller.profile.value!.coverPhoto ?? AppAssets.profileImage,
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
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: 532.h,
                      padding: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.colorFF8600,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.r),
                            topLeft: Radius.circular(18.r),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.profile.value!.employee?.name ??
                                  controller.profile.value!.employer?.businessName ??
                                  controller.profile.value!.email,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              controller.profile.value!.employee != null
                                  ? '${controller.profile.value!.employee!.city ?? 'Unknown'}, ${controller.profile.value!.employee!.country ?? 'Unknown'}'
                                  : '${controller.profile.value!.employer?.city ?? 'Unknown'}, ${controller.profile.value!.employer?.country ?? 'Unknown'}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.colorFF8600,
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _infoRow(
                                  context,
                                  'Job Role',
                                  controller.profile.value!.employee?.skill?.name ??
                                      controller.profile.value!.employer?.skill?.name ??
                                      'N/A',
                                ),
                                _infoRow(
                                  context,
                                  'Experience Level',
                                  controller.profile.value!.employee?.experienceYears ?? 'N/A',
                                ),
                                _infoRow(
                                  context,
                                  'Years Of Experience',
                                  controller.profile.value!.employee?.experienceYears ?? 'N/A',
                                ),
                                _infoRow(
                                  context,
                                  'Expected Salary',
                                  controller.profile.value!.employee!.height.toString() ?? 'N/A',
                                ),
                                _infoRow(
                                  context,
                                  'Job Type',
                                  controller.profile.value!.employee?.eyeColor?.name ?? 'N/A',
                                ),
                      
                              ],
                            ),
                            SizedBox(height: 20.h),
                            CustomButton(
                              buttonText: 'Send Message',
                              buttonWidth: double.infinity,
                              buttonColor: AppColors.colorFF8600,
                              textColor: AppColors.white,
                              buttonHeight: 55.h,
                              buttonTextSize: 16.sp,
                              onTap: () {
                                print('Send Message to: ${controller.profile.value!.id}');
                                // Implement messaging
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _infoTile(context, label, AppColors.white, false)),
        Expanded(child: _infoTile(context, value, AppColors.color5E5E5E, true)),
      ],
    );
  }

  Widget _infoTile(BuildContext context, String text, Color color, bool isLeftAligned) {
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