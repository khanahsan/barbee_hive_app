import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/chat_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/widgets/custom_appbar.dart';

/* 
 class MessageScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
        if (chatController.isEmployer.value) {
          // Employer sees only chats they started
          return StreamBuilder(
            stream: chatController.getChatsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final chats = snapshot.data!.docs;
              if (chats.isEmpty) {
                return const Center(child: Text("No chats yet"));
              }

              return ListView.separated(
                itemCount: chats.length,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemBuilder: (context, index) {
                  final chat = chats[index].data() as Map<String, dynamic>;
                  return messageTile(
                    context,
                    name: chat['employeeName'] ?? "Employee",
                    message: chat['lastMessage'] ?? "",
                    profileImage: chat['employeeImage'] ?? '',
                    onTap: () {
                      Get.to(
                        () => ChatScreen(
                          chatId: chat['chatId'],
                          otherName: chat['employeeName'] ?? "Employee",
                          otherImage: chat['employeeImage'] ?? "",
                          employeeData: {
                            'uid': chat['employeeId'],
                            'name': chat['employeeName'],
                            'profileImage': chat['employeeImage'],
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        } else {
          // Employee only sees chats where employer initiated
          return StreamBuilder(
            stream: chatController.getChatsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final chats = snapshot.data!.docs;
              if (chats.isEmpty) {
                return const Center(child: Text("No chats yet"));
              }

              return ListView.separated(
                itemCount: chats.length,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                separatorBuilder: (context, index) => SizedBox(height: 15.h),

                itemBuilder: (context, index) {
                  final chat = chats[index].data() as Map<String, dynamic>;
                  return messageTile(
                    context,
                    name: chat['employerName'] ?? "Employer",
                    message: chat['lastMessage'] ?? "",
                    profileImage: chat['employerImage'],
                    onTap: () {
                      Get.to(
                        () => ChatScreen(
                          chatId: chat['chatId'],
                          otherName: chat['employerName'],
                          otherImage: chat['employerImage'],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }
      }),
    );
  }

  Widget messageTile(
    BuildContext context, {
    required String name,
    required String message,
    required String profileImage,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.color101010,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          spacing: 15.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HexagonAvatar(
              imagePath: profileImage,
              width: 80.w,
              height: 90.h,
              borderColor: AppColors.white,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 3.h,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssets.arrowForwardIcon,
              height: 18.h,
              width: 18.w,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
  */
class MessageScreen extends GetView<ChatController> {
  const MessageScreen({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        showHexagon: true,
        profileImagePath: controller.userProfileImage.value,
        context: context,
        leadingTapFunction: () {
          if (onMenuPressed != null) onMenuPressed!();
        },
        title: 'Messages',
      ),
      backgroundColor: AppColors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chats.isEmpty) {
          return const Center(
            child: Text("No chats yet", style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.separated(
          itemCount: controller.chats.length,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          separatorBuilder: (context, index) => SizedBox(height: 15.h),
          itemBuilder: (context, index) {
            final chat = controller.chats[index].data() as Map<String, dynamic>;
            final participants = chat['participants'] as Map<String, dynamic>;
            final currentUserId = controller.currentUserId.value;

            final otherEntry = participants.entries.firstWhere(
              (entry) => entry.key != currentUserId,
            );
            final otherUser = otherEntry.value as Map<String, dynamic>;
            final name = otherUser['name'] ?? 'User';
            final image = otherUser['image'] ?? '';
            final role = otherUser['role'] ?? 0;
            final otherUserId = otherEntry.key;
            final lastMessage = chat['lastMessage'] ?? "";
            print(
              "currentUserId: $currentUserId, otherUserId: $otherUserId, name: $name, role: $role ",
            );
            return messageTile(
              context,
              name: name,
              message: lastMessage,
              profileImage: image,
              onTap: () {
                Get.to(
                  () => ChatScreen(
                    chatId: chat['chatId'],
                    otherName: name,
                    otherImage: image,
                    employeeData: {
                      'uid': otherUserId,
                      'name': name,
                      'profileImage': image,
                    },
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget messageTile(
    BuildContext context, {
    required String name,
    required String message,
    required String profileImage,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.color101010,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            HexagonAvatar(
              imagePath: profileImage,
              width: 80.w,
              height: 90.h,
              borderColor: AppColors.white,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssets.arrowForwardIcon,
              height: 18.h,
              width: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}
