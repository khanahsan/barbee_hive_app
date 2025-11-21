import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/hive_profile_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/chat_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
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
    final chatController = Get.find<ChatController>();

    /// Replacing initState()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdsHelper().trackProfileView();
    });

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
          /// USER IMAGE
          Positioned(
            top: 102.h,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300.h,
              width: double.infinity,
              child: Image.network(
                currentUser.profileImage ?? AppAssets.nullProfile,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// USER DETAILS
          Positioned(
            top: 360.h,
            // slightly less than image height for overlap
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 3.h),
              decoration: BoxDecoration(
                color: AppColors.colorFF8600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.r),
                  topRight: Radius.circular(20.0.r),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// USER NAME
                      CustomText(
                        title: currentUser.employee?.name ?? "",
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorFFFFFF,
                      ),

                      /// USER DISTANCE
                      CustomText(
                        title: ".6 mi away",
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
                            "Experience",
                            currentUser.employee?.skill?.name ?? "",
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
                        CustomButton(
                          onTap: () {
                            Get.to(
                              () => ChatScreen(
                                chatId:
                                    "${chatController.currentUserId.value}-${currentUser.uid}",
                                otherName: currentUser.employee!.name,
                                otherImage: currentUser.profileImage!,
                                employeeData: {
                                  'uid': currentUser.uid,
                                  'name': currentUser.employee!.name,
                                  'profileImage': currentUser.profileImage,
                                },
                              ),
                            );
                          },
                          buttonText: "Send Message",
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
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      spacing: 1.5.w,
      children: [
        Expanded(child: _infoTile(label, AppColors.colorFFFFFF, false)),
        Expanded(child: _infoTile(value, AppColors.color5E5E5E, true)),
      ],
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
