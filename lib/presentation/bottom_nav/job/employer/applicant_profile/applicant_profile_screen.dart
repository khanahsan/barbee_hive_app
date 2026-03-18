import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_pdf_view.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/navigation/routes.dart';
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.colorFF8600),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title: controller.errorMessage.value,
                  color: Colors.red,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  buttonText: 'Retry',
                  // onTap: () => controller.fetchProfile(
                  //     Get.arguments?['userId'] ?? 38),
                  buttonWidth: 100.w,
                  buttonColor: AppColors.colorFF8600,
                  buttonHeight: 40.h,
                  buttonTextSize: 16.sp,
                ),
              ],
            ),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Text(
              'No profile data',
              style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16.sp),
            ),
          );
        }

        /// Fields from commented-out code
        final name =
            profile.applicant.name ??
            profile.applicant.name ??
            profile.applicant.email;
        final location =
            '${profile.applicant.country?.name ?? 'Unknown'}, ${profile.applicant.city ?? 'Unknown'}';
        final jobRole =
            profile.applicant.skills != null &&
                    profile.applicant.skills!.isNotEmpty
                ? profile.applicant.skills!
                    .map((skill) => skill.name)
                    .join(', ')
                : 'N/A';

        final expLevel = profile.experienceLevel.name ?? 'N/A';
        final yearsExp = '${profile.yearsOfExperience ?? 'N/A'} Years';
        final expectedSalary = '\$${profile.expectedSalary ?? 'N/A'}';
        final jobType = profile.jobType.name ?? 'N/A';
        final resume = profile.applicant.resumeUrl ?? '';

        return Stack(
          children: [
            /// Cover/Profile Image
            Positioned(
              top: 102.h,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 300.h,
                width: double.infinity,
                child: Image.network(
                  profile.applicant.profileImage ?? AppAssets.nullProfile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppAssets.nullProfile,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            /// User Details Container
            Positioned(
              top: 360.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.colorFF8600,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
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
                      topLeft: Radius.circular(18.r),
                      topRight: Radius.circular(18.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Name & Location
                        CustomText(
                          title: name,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFFFFFF,
                        ),
                        CustomText(
                          title: location,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFF8600,
                        ),
                        SizedBox(height: 25.h),

                        /// Info Rows
                        Column(
                          spacing: 1.5.h,
                          children: [
                            _infoRow('Job Role', jobRole),
                            _infoRow('Experience Level', expLevel),
                            _infoRow('Years Of Experience', yearsExp),
                            _infoRow('Expected Salary', expectedSalary),
                            _infoRow('Job Type', jobType),
                            _resumeRow(resume),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        /// Send Message Button
                        CustomButton(
                          onTap: () {
                            Get.toNamed(
                              Routes.chatScreen,
                              arguments: {'otherUserID': profile.applicant.uid},
                            );
                          },
                          buttonText: 'Send Message',
                          buttonWidth: double.infinity,
                          buttonColor: AppColors.colorFF8600,
                          textColor: AppColors.colorFFFFFF,
                          buttonHeight: 55.h,
                          buttonTextSize: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Info Row
  Widget _infoRow(String label, String value) {
    return Row(
      spacing: 1.5.w,
      children: [
        Expanded(child: _infoTile(label, AppColors.colorFFFFFF, false)),
        Expanded(child: _infoTile(value, AppColors.colorFFFFFF, true)),
      ],
    );
  }

  Widget _resumeRow(String value) {
    return Row(
      spacing: 1.5.w,
      children: [
        Expanded(
          child: _infoTile(
            "Resume/Certification",
            AppColors.colorFFFFFF,
            false,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (value.isNotEmpty) {
                Get.to(() => CustomPdfView(pdfUrl: value));
              } else {
                Utilities.showSnackBar(
                  title: 'Error',
                  message: 'No Resume Available',
                  isSuccess: false,
                );
              }
            },
            child: _infoTile("Click View", AppColors.color8690FF, true),
          ),
        ),
      ],
    );
  }

  /// Info Tile
  Widget _infoTile(String text, Color color, bool isLeftAligned) {
    return Container(
      alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.only(
        left: isLeftAligned ? 35.w : 0,
        right: isLeftAligned ? 0 : 35.w,
      ),
      height: 50.h,
      color: AppColors.color111111,
      child: CustomText(
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
        title: text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

/*class ApplicantProfileScreen extends GetView<ApplicantProfileController> {
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.colorFF8600),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
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
                  // onTap:
                  //     () => controller.fetchProfile(
                  //       Get.arguments?['userId'] ?? 38,
                  //     ),
                  buttonWidth: 100.w,
                  buttonColor: AppColors.colorFF8600,
                  buttonHeight: 40.h,
                  buttonTextSize: 16.sp,
                ),
              ],
            ),
          );
        }

        */ /*  final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Text(
              'No profile data',
              style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16.sp),
            ),
          );
        }

        /// ---------------------------
        /// Correct field mappings
        /// ---------------------------
        final name =
            profile.employee?.name ??
            profile.employer?.businessName ??
            profile.email;

        final location =
            profile.employee != null
                ? '${profile.employee!.country?.name ?? 'Unknown'}, ${profile.employee!.state?.name ?? 'Unknown'}, ${profile.employee!.city ?? 'Unknown'}'
                : '${profile.employer?.country ?? 'Unknown'}, ${profile.employer?.state ?? 'Unknown'}, ${profile.employer?.city ?? 'Unknown'}';

        final jobRole =
            profile.employee?.gender ??
            profile.employer?.skills?.map((s) => s.name).join(', ') ??
            "N/A";

        final expLevel = profile.employee?.experienceYears?.toString() ?? "N/A";
        final yearsExp = profile.employee?.experienceYears?.toString() ?? "N/A";
        final expectedSalary = profile.employee?.height?.toString() ?? "N/A";
        final jobType = profile.employee?.eyeColor?.name ?? "N/A";*/ /*

        final profile = controller.profile.value;
        if (profile == null) {
          return Center(
            child: Text(
              'No profile data',
              style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16.sp),
            ),
          );
        }

        final name = profile.applicant.name ?? profile.applicant.email;
        final location =
            '${profile.applicant.country?.name ?? 'Unknown'}, ${profile.applicant.city ?? 'Unknown'}';
        final jobRole = profile.applicant.skills?.name ?? 'N/A';
        final jobType = profile.jobType.name;
        final yearsExp = '${profile.yearsOfExperience} Years';
        final expectedSalary = '\$${profile.expectedSalary}';
        final expLevel = profile.experienceLevel.name;

        return Stack(
          children: [
            // Cover Image / Carousel
            // Cover / Profile Image
            Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              child: profile.applicant.profileImage != null &&
                  profile.applicant.profileImage!.isNotEmpty
                  ? Image.network(
                profile.applicant.profileImage!,
                height: 250.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppAssets.profileImage,
                    height: 250.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              )
                  : Image.asset(
                AppAssets.profileImage,
                height: 250.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),


            // Profile Info Container
            // Profile Info Container (fills from top of black container to bottom)
            Positioned(
              top: 320.h, // start just below the profile image
              bottom: 0,   // fill to the bottom of screen
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(top: 3.h), // orange strip
                decoration: BoxDecoration(
                  color: AppColors.color000000,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.r),
                        topRight: Radius.circular(18.r),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & Location
                        CustomText(
                          title: name,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFFFFFF,
                        ),
                        CustomText(
                          title: location,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFF8600,
                        ),
                        SizedBox(height: 25.h),

                        // Info Rows
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _infoRow(context, 'Job Role', jobRole),
                            _infoRow(context, 'Experience Level', expLevel),
                            _infoRow(context, 'Years Of Experience', yearsExp),
                            _infoRow(context, 'Expected Salary', expectedSalary),
                            _infoRow(context, 'Job Type', jobType),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Send Message Button
                        CustomButton(
                          buttonText: 'Send Message',
                          buttonWidth: double.infinity,
                          buttonColor: AppColors.colorFF8600,
                          textColor: AppColors.colorFFFFFF,
                          buttonHeight: 55.h,
                          buttonTextSize: 16.sp,
                          onTap: () {
                            print('Send Message to: ${profile.id}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            */ /*       Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorFF8600,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
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
                        topRight: Radius.circular(18.r),
                        topLeft: Radius.circular(18.r),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: name,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFFFFFF,
                        ),
                        CustomText(
                          title: location,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFF8600,
                        ),
                        SizedBox(height: 25.h),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _infoRow(context, 'Job Role', jobRole),
                            _infoRow(context, 'Experience Level', expLevel),
                            _infoRow(context, 'Years Of Experience', yearsExp),
                            _infoRow(
                              context,
                              'Expected Salary',
                              expectedSalary,
                            ),
                            _infoRow(context, 'Job Type', jobType),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          buttonText: 'Send Message',
                          buttonWidth: double.infinity,
                          buttonColor: AppColors.colorFF8600,
                          textColor: AppColors.colorFFFFFF,
                          buttonHeight: 55.h,
                          buttonTextSize: 16.sp,
                          onTap: () {
                            print('Send Message to: ${profile.id}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),*/ /*
          ],
        );
      }),
    );
  }

  // Info Row Widget
  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _infoTile(context, label, AppColors.colorFFFFFF, false),
        ),
        Expanded(child: _infoTile(context, value, AppColors.color5E5E5E, true)),
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
}*/
