import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/services/subscription_feature_guard.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_pdf_view.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/resume_lock_dialog.dart';
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
        title: "",
        titleWidget: Image.asset(
          AppAssets.appLogo4,
          width: 195.w,
          height: 54.h,
          fit: BoxFit.cover,
        ),
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
                CustomBtn(
                  btnTitle: 'Retry',
                  // onPressed: () => controller.fetchProfile(
                  //     Get.arguments?['userId'] ?? 38),
                  buttonWidth: 100.w,
                  btnBackgroundColor: AppColors.colorFF8600,
                  buttonHeight: 40.h,
                  fontSize: 16.sp,
                  onPressed: () {},
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

        final expLevel = profile.experienceLevel.name;
        final yearsExp = '${profile.yearsOfExperience} Years';
        final expectedSalary = '\$${profile.expectedSalary}';
        final jobType = profile.jobType.name;
        final resume = profile.applicant.resumeUrl ?? '';

        return Stack(
          children: [
            /// Cover/Profile Image
            /// Cover/Profile Image
            Positioned(
              top: 102.h,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 300.h,
                width: double.infinity,
                child:
                (profile.applicant.profileImage != null &&
                    profile.applicant.profileImage!.isNotEmpty)
                    ? Image.network(
                  profile.applicant.profileImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.color111111,
                      alignment: Alignment.center,
                      child: CustomText(
                        title: "No Image Found",
                        color: AppColors.colorFFFFFF,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                )
                    : Container(
                  color: AppColors.color111111,
                  alignment: Alignment.center,
                  child: CustomText(
                    title: "No Image Found",
                    color: AppColors.colorFFFFFF,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          /*  Positioned(
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
            ),*/

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
                        CustomBtn(
                          btnTitle: 'Send Message',
                          buttonWidth: double.infinity,
                          btnBackgroundColor: AppColors.colorFF8600,
                          btnTxtColor: AppColors.colorFFFFFF,
                          buttonHeight: 55.h,
                          fontSize: 16.sp,
                          onPressed: () {
                            Get.toNamed(
                              Routes.chatScreen,
                              arguments: {'otherUserID': profile.applicant.uid},
                            );
                          },
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
    final isLocked = !controller.canAccessApplicantResumeForCurrentRole;

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
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (isLocked) {
                resumeLockDialog();
                return;
              }

              if (value.isNotEmpty) {
                switch (controller.resumeAdMode) {
                  case ResumeAdMode.interstitial:
                    AdsHelper().showInterstitialAd(
                      onDismissed: () {
                        Get.to(() => CustomPdfView(pdfUrl: value));
                      },
                      onFailedToShow: () {
                        Get.to(() => CustomPdfView(pdfUrl: value));
                      },
                    );
                    break;
                  case ResumeAdMode.banner:
                    Get.to(
                      () => CustomPdfView(pdfUrl: value, showBannerAd: true),
                    );
                    break;
                  case ResumeAdMode.none:
                    Get.to(() => CustomPdfView(pdfUrl: value));
                    break;
                }
              } else {
                Utilities.showSnackBar(
                  title: 'Error',
                  message: 'No Resume Available',
                  isSuccess: false,
                );
              }
            },
            child: _infoTile(
              isLocked ? "Locked" : "Click View",
              isLocked ? AppColors.expiredBannerColor : AppColors.color8690FF,
              true,
            ),
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
