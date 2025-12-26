import 'dart:developer';

import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/b2b/b2b_fading_carousel.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/b2b_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';

class B2BScreen extends GetView<B2BController> {
  const B2BScreen({super.key, required this.currentUser});

  final User currentUser;

  // final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    log("CURRENT CHECK USER: ${currentUser.profileImage}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        showHexagon: false,
        leadingIconPath: AppAssets.backIcon,
        title: "B2B",
      ),
      body: Stack(
        children: [
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


          // Positioned(
          //   top: 102.h,
          //   left: 0,
          //   right: 0,
          //   child:CustomFadingCarousel(
          //       imagePaths: [currentUser.profileImage ?? AppAssets.nullProfile]),
          // ),


          Positioned(
            top: 360.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: 3.h), // top padding for orange strip
              decoration: BoxDecoration(
                color: AppColors.colorFF8600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
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
                  children: [
                    /// EMPLOYER NAME
                    CustomText(
                      title: currentUser.employer?.businessName ?? "",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorFFFFFF,
                    ),

                    /// DISTANCE
                    CustomText(
                      title: "0.6 mi away",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorFF8600,
                    ),
                    SizedBox(height: 40.h),

                    /// Skills
                    _seekingRow(),

                    SizedBox(height: 30.h),

                    /// SEND MESSAGE OPTION
                    if (controller.canSendMessage &&
                        !controller.isSameUser(currentUser.id))
                      CustomButton(
                        onTap: () {
                          Get.toNamed(
                            Routes.chatScreen,
                            arguments: {"otherUserID": currentUser.uid},
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
          )


     /*     Positioned(
            top: 360.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
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
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// EMPLOYER NAME
                        CustomText(
                          title: currentUser.employer?.businessName ?? "",
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFFFFFF,
                        ),

                        /// TOTAL DISTANCE
                        CustomText(
                          title: ".6 mi away",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorFF8600,
                        ),
                        SizedBox(height: 40.h),

                        _seekingRow(),
                        SizedBox(height: 30.h),

                        /// SEND MESSAGE OPTION (SHOW ONLY TO EMPLOYER)
                        if (controller.canSendMessage &&
                            !controller.isSameUser(currentUser.id))
                          CustomButton(
                            onTap: () {
                              Get.toNamed(
                                Routes.chatScreen,
                                arguments: {"otherUserID": currentUser.uid},
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
                    ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  // Widget _seekingRow(BuildContext context) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     spacing: 8.h,
  //     children: [
  //       /// SEEKING LABEL
  //       CustomText(
  //         title: "Seeking",
  //         fontSize: 17,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.colorFF8600,
  //       ),
  //
  //       /// SEEKING OPTIONS
  //       Row(
  //         mainAxisSize: MainAxisSize.min,
  //         spacing: 2.w,
  //         children: [
  //           Expanded(
  //             child: _seekingTabs(context: context, tabTitle: "Bartender"),
  //           ),
  //           Expanded(
  //             child: _seekingTabs(context: context, tabTitle: "Barback"),
  //           ),
  //           Expanded(child: _seekingTabs(context: context, tabTitle: "Host")),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _seekingRow() {
    final skills = currentUser.employer?.skills ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8.h,
      children: [
        /// SEEKING LABEL
        CustomText(
          title: "Seeking",
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.colorFF8600,
        ),

        /// IF NO SKILLS FOUND
        if (skills.isEmpty)
          CustomText(
            title: "No skills listed",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.color5E5E5E,
          ),

        /// SKILLS LIST USING WRAP
        if (skills.isNotEmpty)
          Wrap(
            spacing: 10.w, // horizontal space between chips
            runSpacing: 8.h, // vertical space between lines
            alignment: WrapAlignment.center,
            children: skills.map((skill) => _skillChip(skill.name)).toList(),
          ),
      ],
    );
  }

  Widget _skillChip(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.color111111,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: CustomText(
        title: title,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.color5E5E5E,
      ),
    );
  }
}
