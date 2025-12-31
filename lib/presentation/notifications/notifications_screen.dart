import 'package:barbee_hive_app/data/model/notification_response.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/presentation/notifications/controllers/notifications_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        leadingIconPath:  AppAssets.backIcon,
        title:'Notifications',
        profileImagePath: controller.userProfileImage.value,
      ),

      backgroundColor: AppColors.black,
      body: Container(
        height: Get.height,
        child:


       Obx(() =>

          controller.isLoading.value ? Center(child: CircularProgressIndicator(
            color: AppColors.colorFF8600,

          )) :
              
              controller.notificationsList.isEmpty ? Center(
                child: Text("No Notifications",
                style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ) :

           ListView.separated(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index){

                AppNotification notification = controller.notificationsList[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    //width: Get.width,
                    child: Row(
                      children: [
                        Icon(
                            1 == 1 ?
                            Icons.message
                            : Icons.messenger_outline
                            , color: AppColors.colorFF8600),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                        notification.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),

                                    Text(
                                        Utilities.getTime(notification.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        )),
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
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return Divider(color: AppColors.grey.withAlpha(80));
          },),
        ),
      ),
    );
  }
}
