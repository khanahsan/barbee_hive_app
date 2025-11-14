import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
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

class HiveProfileScreen extends StatefulWidget {
  const HiveProfileScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<HiveProfileScreen> createState() => _HiveProfileScreenState();
}

class _HiveProfileScreenState extends State<HiveProfileScreen> {
  final ChatController chatController = Get.find();

  @override
  void initState() {
    super.initState();
    AdsHelper().trackProfileView(); // ✅ open hote hi count hoga
  }

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
            child: Image.network(
              widget.currentUser.profileImage ?? AppAssets.nullProfile,
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
                    color: AppColors.colorFF8600,
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
                        /// NAME LABEL
                        CustomText(
                          title: widget.currentUser.employee?.name ?? "",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFFFFFF,
                        ),

                        /// DISTANCE
                        CustomText(
                          title: ".6 mi away",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFF8600,
                        ),
                        SizedBox(height: 25.h),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 1.5.h,
                          children: [
                            /// EXPERIENCE FIELD
                            _infoRow(
                              "Experience",
                              widget.currentUser.employee?.skill?.name ?? "",
                            ),

                            /// AGE FIELD
                            // _infoRow("Age", "${widget.currentUser.employee?.} Yr"),

                            /// GENDER FIELD
                            _infoRow(
                              "Gender",
                              widget.currentUser.employee?.gender ?? "",
                            ),

                            /// EYE COLOR FIELD
                            _infoRow(
                              "Eye Color",
                              widget.currentUser.employee?.eyeColor?.name ?? "",
                            ),

                            /// HAIR COLOR FIELD
                            _infoRow(
                              "Hair Color",
                              widget.currentUser.employee?.hairColor?.name ??
                                  "",
                            ),

                            /// RESUME FIELD
                            _resumeRow(context),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        CustomButton(
                          onTap: () {
                            Get.to(
                              () => ChatScreen(
                                chatId:
                                    "${chatController.currentUserId.value}-${widget.currentUser.uid}",
                                // Potential chatId
                                otherName: widget.currentUser.employee!.name,
                                otherImage: widget.currentUser.profileImage!,
                                employeeData: {
                                  'uid': widget.currentUser.uid,
                                  'name': widget.currentUser.employee!.name,

                                  'profileImage':
                                      widget.currentUser.profileImage,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 1.5.w,
      children: [
        Expanded(child: _infoTile(label, AppColors.colorFFFFFF, false)),
        Expanded(child: _infoTile(value, AppColors.color5E5E5E, true)),
      ],
    );
  }

  Widget _resumeRow(BuildContext context) {
    final resumePath = widget.currentUser.employee?.resumePath;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 1.5.w,
      children: [
        Expanded(
          child: _infoTile("Resume/Certification", AppColors.colorFFFFFF, false),
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
