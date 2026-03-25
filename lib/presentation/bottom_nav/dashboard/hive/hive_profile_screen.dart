import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_profile_image.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/hive_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../data/model/dashboard_response.dart';
import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_appbar.dart';
import '../../../../infrastructure/widgets/custom_pdf_view.dart';

class HiveProfileScreen extends GetView<HiveProfileController> {
  const HiveProfileScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    final userData = {
      ...currentUser.toJson(),
      'distance': currentUser.distance,
      'age': currentUser.age,
    };
    log("CURRENT USER: $userData");

    /// Replacing initState()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdsHelper().trackProfileView();
    });

    return Scaffold(
      backgroundColor: AppColors.color000000,
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
          /// USER IMAGE
          Positioned(
            top: 102.h,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300.h,
              width: double.infinity,
              child: _buildCoverPhoto(currentUser.coverPhoto),
            ),
          ),

          /// USER DETAILS
          Positioned(
            top: 360.h,
            // slightly less than image height for overlap
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorFF8600,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.r),
                      topRight: Radius.circular(20.0.r),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 15.w,
                      top: 65.h,
                      bottom: 5.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// USER NAME
                          CustomText(
                            title: currentUser.employee?.name ?? "",
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorFFFFFF,
                          ),

                          /// USER DISTANCE
                          if (currentUser.distance != null)
                            CustomText(
                              title: "${currentUser.distance} mi away",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorFF8600,
                            ),
                          SizedBox(height: 25.h),
                          Column(
                            spacing: 1.5.h,
                            children: [
                              /// USER EXPERIENCE
                              _infoRow(
                                "Skills",
                                currentUser.employee?.skills
                                        .map((skill) => skill.name)
                                        .join(', ') ??
                                    '',
                              ),

                              /// USER GENDER
                              _infoRow(
                                "Gender",
                                currentUser.employee?.gender ?? "",
                              ),

                              /// USER EYE COLOR
                              _infoRow(
                                "Eye Color",
                                currentUser.employee?.eyeColor?.name ?? "",
                              ),

                              /// USER HAIR COLOR
                              _infoRow(
                                "Hair Color",
                                currentUser.employee?.hairColor?.name ?? "",
                              ),

                              /// USER RESUME
                              _resumeRow(currentUser),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          /// CHAT OPTION (SHOW IF THE USER IS DIFFERENT)
                          if (!controller.isSameUser(currentUser.id))
                            CustomBtn(
                              btnTitle: "Send Message",
                              buttonWidth: double.infinity,
                              btnBackgroundColor: AppColors.colorFF8600,
                              btnTxtColor: AppColors.colorFFFFFF,
                              buttonHeight: 55.h,
                              fontSize: 16,
                              onPressed: () {
                                Get.toNamed(
                                  Routes.chatScreen,
                                  arguments: {'otherUserID': currentUser.uid},
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 0,
                  left: 0,
                  top: -80.h,
                  child: Center(
                    child: CustomProfileImage(
                      width: 130,
                      height: 140,
                      imagePath: currentUser.profileImage ?? '',
                      text: currentUser.employee?.name ?? "",
                      isEditMode: false,
                      wholeAvatarClickable: false,
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

  Widget _infoRow(String label, String value) {
    return Row(
      spacing: 1.5.w,
      children: [
        Expanded(child: _infoTile(label, AppColors.colorFFFFFF, false)),
        Expanded(child: _infoTile(value, AppColors.colorFFFFFF, true)),
      ],
    );
  }

  Widget _buildCoverPhoto(String? coverPhoto) {
    final rawUrl = coverPhoto?.trim();
    final normalizedUrl =
        (rawUrl == null || rawUrl.isEmpty || rawUrl.toLowerCase() == 'null')
            ? null
            : rawUrl;
    final uri = normalizedUrl == null ? null : Uri.tryParse(normalizedUrl);
    final isNetwork =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (!isNetwork) {
      return _noCoverPhotoAvailable();
    }

    return CachedNetworkImage(
      imageUrl: normalizedUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => _noCoverPhotoAvailable(),
      errorWidget: (context, url, error) => _noCoverPhotoAvailable(),
    );
  }

  Widget _noCoverPhotoAvailable() {
    return Container(
      color: AppColors.color101010,
      alignment: Alignment.center,
      child: Text(
        'No Cover Photo Available',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _resumeRow(User currentUser) {
    final resumePath = currentUser.employee?.resumePath;

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
              if (resumePath != null && resumePath.isNotEmpty) {
                Get.to(() => CustomPdfView(pdfUrl: resumePath));
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
        title: text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
