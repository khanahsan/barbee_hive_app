import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/chat_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';
import 'b2b_fading_carousel.dart';

class B2BScreen extends StatelessWidget {
  B2BScreen({super.key, required this.currentUser});

  final User currentUser;
  final ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
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
            top: 100.h,
            left: 0,
            right: 0,
            child: Image.network(
              currentUser.profileImage ?? AppAssets.nullProfile,
            ),
            // child: CustomFadingCarousel(
            //   imagePaths: [
            //     AppAssets.profileImage,
            //     AppAssets.profileImage,
            //     AppAssets.profileImage,
            //   ],
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
                        Text(
                          "${currentUser.employer?.businessName ?? ""}",
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
                        SizedBox(height: 40.h),

                        _seekingRow(context),
                        SizedBox(height: 30.h),

                        CustomButton(
                          onTap: () {
                            Get.to(
                              () => ChatScreen(
                                chatId:
                                    "${chatController.currentUserId.value}-${currentUser.uid}",
                                otherName: currentUser.employer!.businessName,
                                otherImage: currentUser.profileImage ?? '',
                                employeeData: {
                                  'uid': currentUser.uid,
                                  'name': currentUser.employer!.businessName,
                                  'profileImage':
                                      currentUser.profileImage ?? '',
                                  'role': currentUser.role,
                                },
                              ),
                            );
                          },
                          buttonText: "Send Message",
                          buttonWidth: double.infinity,
                          buttonColor: AppColors.primary,
                          textColor: AppColors.white,
                          buttonHeight: 55.h,
                          buttonTextSize: 16.sp,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seekingRow(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8.h,
      children: [
        Text(
          "Seeking",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2.w,
          children: [
            Expanded(
              child: _seekingTabs(context: context, tabTitle: "Bartender"),
            ),
            Expanded(
              child: _seekingTabs(context: context, tabTitle: "Barback"),
            ),
            Expanded(child: _seekingTabs(context: context, tabTitle: "Host")),
          ],
        ),
      ],
    );
  }

  Widget _seekingTabs({
    required BuildContext context,
    required String tabTitle,
  }) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50.h,
      color: AppColors.color111111,
      child: Text(
        tabTitle,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.color5E5E5E,
        ),
      ),
    );
  }
}
