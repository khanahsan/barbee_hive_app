import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/chat_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class MessageScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
        if (chatController.isEmployer.value) {
          // Employer sees list of employees first
          return StreamBuilder(
            stream: chatController.getAllEmployees(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final employees = snapshot.data!.docs;
              if (employees.isEmpty) {
                return const Center(child: Text("No employees found"));
              }

              return ListView.separated(
                itemCount: employees.length,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemBuilder: (context, index) {
                  final emp = employees[index].data() as Map<String, dynamic>;
                  return messageTile(
                    context,
                    name: emp['name'] ?? "Unknown",
                    message: emp['email'] ?? "",
                    profileImage: emp['profileImage'],
                    onTap: () async {
                      // final chatId = await chatController.startChatWithEmployee(
                      //   emp,
                      // );
                      // Get.to(
                      //   () => ChatScreen(
                      //     chatId: chatId,
                      //     otherName: emp['name'],
                      //     otherImage: emp['profileImage'] ?? "",
                      //   ),
                      // );

                      Get.to(
                        () => ChatScreen(
                          chatId: "${chatController.currentUserId.value}-${emp['uid']}", // Potential chatId
                          otherName: emp['name'],
                          otherImage: emp['profileImage'] ?? "",
                          employeeData: emp,
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
