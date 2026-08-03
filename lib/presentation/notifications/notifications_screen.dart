import 'package:barbee_hive_app/data/model/notification_response.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/presentation/notifications/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/custom_appbar.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
          // if (showBackButton == true) {
          //   Get.back();
          // } else {
          //   if (onMenuPressed != null) onMenuPressed!();
          // }
        },
        leadingIconPath: AppAssets.backIcon,
        title: '',
          titleWidget: Image.asset(
            AppAssets.appLogo4,
            width: 195.w,
            height: 54.h,
            fit: BoxFit.cover,
          ),
        // profileImagePath: controller.userProfileImage.value,
        showHexagon: false
      ),

      backgroundColor: AppColors.black,
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () =>
              controller.isLoading.value
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.colorFF8600,
                    ),
                  )
                  : controller.notificationsList.isEmpty
                  ? Center(
                    child: Text(
                      "No Notifications",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                  : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    itemCount: controller.notificationsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      AppNotification notification =
                          controller.notificationsList[index];

                      return Container(
                        //width: Get.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon(
                            //   1 == 1
                            //       ? Icons.message
                            //       : Icons.messenger_outline,
                            //   color: AppColors.colorFF8600,
                            // ),
                            // SizedBox(width: 10),
                            Expanded(
                              flex: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: Get.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,

                                      children: [
                                        Text(
                                          notification.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),

                                        Text(
                                          Utilities.getTime(
                                            notification.createdAt,
                                          ),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    notification.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),

                                  Divider(
                                    thickness: 0.8,
                                    color: AppColors.color262626,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: AppColors.grey.withAlpha(80));
                    },
                  ),
        ),
      ),
    );
  }
}
