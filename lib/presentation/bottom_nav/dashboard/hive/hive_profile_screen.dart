import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/services/profile_view_prompt_service.dart';
import 'package:barbee_hive_app/infrastructure/services/subscription_feature_guard.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_profile_image.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/hive_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../data/model/dashboard_response.dart' show User;
import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_appbar.dart';
import '../../../../infrastructure/widgets/custom_pdf_view.dart';

class HiveProfileScreen extends StatefulWidget {
  const HiveProfileScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<HiveProfileScreen> createState() => _HiveProfileScreenState();
}

class _HiveProfileScreenState extends State<HiveProfileScreen> {
  final HiveProfileController controller = Get.find<HiveProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.currentUserSubscriptionController.refresh();
      if (controller.shouldShowProfileVisitAds) {
        AdsHelper().trackProfileView();
      }
      await ProfileViewPromptService.recordVisitAndMaybePrompt();
    });
  }

  bool _parseReceiveMessages(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return true;
  }

  Future<bool> _canReceiveMessages(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return true;

    final data = doc.data() ?? {};
    return _parseReceiveMessages(
      data['receiveMessages'] ?? data['receive_messages'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = {
      ...widget.currentUser.toJson(),
      'distance': widget.currentUser.distance,
      'age': widget.currentUser.age,
    };
    log("CURRENT USER: $userData");

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
      body: Obx(() {
        final viewedProfile = controller.viewedUserProfile.value;
        final employee = viewedProfile?.employee;
        final coverPhoto =
            viewedProfile?.coverPhoto ?? widget.currentUser.coverPhoto;
        final profileImage =
            viewedProfile?.profileImage ?? widget.currentUser.profileImage;
        final displayName =
            employee?.name ?? widget.currentUser.employee?.name ?? "";
        final displayUid = viewedProfile?.uid ?? widget.currentUser.uid;

        return Stack(
          children: [
            /// USER IMAGE
            Positioned(
              top: 102.h,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 300.h,
                width: double.infinity,
                child: _buildCoverPhoto(coverPhoto),
              ),
            ),

            /// USER DETAILS
            Positioned(
              top: 360.h,
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
                            CustomText(
                              title: displayName,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorFFFFFF,
                            ),
                            if (widget.currentUser.distance != null)
                              CustomText(
                                title: "${widget.currentUser.distance} mi away",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.colorFF8600,
                              ),
                            SizedBox(height: 25.h),
                            Column(
                              spacing: 1.5.h,
                              children: [
                                _infoRow(
                                  "Skills",
                                  employee?.skills
                                          .map((skill) => skill.name)
                                          .join(', ') ??
                                      widget.currentUser.employee?.skills
                                          .map((skill) => skill.name)
                                          .join(', ') ??
                                      '',
                                ),
                                _infoRow(
                                  "Gender",
                                  employee?.gender ??
                                      widget.currentUser.employee?.gender ??
                                      "",
                                ),
                                _infoRow(
                                  "Eye Color",
                                  employee?.eyeColor?.name ??
                                      widget
                                          .currentUser
                                          .employee
                                          ?.eyeColor
                                          ?.name ??
                                      "",
                                ),
                                _infoRow(
                                  "Hair Color",
                                  employee?.hairColor?.name ??
                                      widget
                                          .currentUser
                                          .employee
                                          ?.hairColor
                                          ?.name ??
                                      "",
                                ),
                                _resumeRow(
                                  employee?.resumePath ??
                                      widget.currentUser.employee?.resumePath,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            if (!controller.isSameUser(widget.currentUser.id))
                              CustomBtn(
                                btnTitle: "Send Message",
                                buttonWidth: double.infinity,
                                btnBackgroundColor: AppColors.colorFF8600,
                                btnTxtColor: AppColors.colorFFFFFF,
                                buttonHeight: 55.h,
                                fontSize: 16,
                                onPressed: () async {
                                  final receiverUid = displayUid.trim();
                                  if (receiverUid.isEmpty) return;

                                  final canReceiveMessages =
                                      await _canReceiveMessages(receiverUid);
                                  if (!canReceiveMessages) {
                                    Utilities.showSnackBar(
                                      title: "Messaging Disabled",
                                      message:
                                          "This user is not accepting messages right now.",
                                      isSuccess: false,
                                    );
                                    return;
                                  }

                                  Get.toNamed(
                                    Routes.chatScreen,
                                    arguments: {'otherUserID': receiverUid},
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
                        imagePath: profileImage ?? '',
                        text: displayName,
                        isEditMode: false,
                        wholeAvatarClickable: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
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

  Widget _resumeRow(String? resumePath) {
    final isLocked = !controller.canAccessHiveResumeForCurrentRole;

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
                Utilities.showSnackBar(
                  title: 'Locked',
                  message:
                      'Resume/Certification is available for upgraded employer plans only.',
                  isSuccess: false,
                );
                return;
              }

              if (resumePath != null && resumePath.isNotEmpty) {
                switch (controller.resumeAdMode) {
                  case ResumeAdMode.interstitial:
                    AdsHelper().showInterstitialAd(
                      onDismissed: () {
                        Get.to(() => CustomPdfView(pdfUrl: resumePath));
                      },
                      onFailedToShow: () {
                        Get.to(() => CustomPdfView(pdfUrl: resumePath));
                      },
                    );
                    break;
                  case ResumeAdMode.banner:
                    Get.to(
                      () =>
                          CustomPdfView(pdfUrl: resumePath, showBannerAd: true),
                    );
                    break;
                  case ResumeAdMode.none:
                    Get.to(() => CustomPdfView(pdfUrl: resumePath));
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
