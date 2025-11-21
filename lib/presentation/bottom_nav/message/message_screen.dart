import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/widgets/custom_appbar.dart';

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

        // return ListView.separated(
        //   itemCount: controller.chats.length,
        //   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        //   separatorBuilder: (context, index) => SizedBox(height: 15.h),
        //   itemBuilder: (context, index) {
        //     final chat = controller.chats[index].data() as Map<String, dynamic>;
        //     final participants = chat['participants'] as Map<String, dynamic>;
        //     final currentUserId = controller.currentUserId.value;
        //
        //     final otherEntry = participants.entries.firstWhere(
        //       (entry) => entry.key != currentUserId,
        //     );
        //     final otherUser = otherEntry.value as Map<String, dynamic>;
        //     final name = otherUser['name'] ?? 'User';
        //     final image = otherUser['image'] ?? '';
        //     final role = otherUser['role'] ?? 0;
        //     final otherUserId = otherEntry.key;
        //     final lastMessage = chat['lastMessage'] ?? "";
        //     print(
        //       "currentUserId: $currentUserId, otherUserId: $otherUserId, name: $name, role: $role ",
        //     );
        //     return messageTile(
        //       context,
        //       name: name,
        //       message: lastMessage,
        //       profileImage: image,
        //       onTap: () {
        //         Get.to(
        //           () => ChatScreen(
        //             chatId: chat['chatId'],
        //             otherName: name,
        //             otherImage: image,
        //             employeeData: {
        //               'uid': otherUserId,
        //               'name': name,
        //               'profileImage': image,
        //             },
        //           ),
        //         );
        //       },
        //     );
        //   },
        // );

        return ListView.separated(
          itemCount: controller.chats.length,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          separatorBuilder: (context, index) => SizedBox(height: 15.h),
          itemBuilder: (context, index) {
            final chat = controller.chats[index].data() as Map<String, dynamic>;
            final participants = chat['participants'] as Map<String, dynamic>;
            final currentUserId = controller.currentUserId.value;

            // Extract other user
            final otherEntry = participants.entries.firstWhere(
              (entry) => entry.key != currentUserId,
            );
            final otherUserId = otherEntry.key;
            final otherUser = otherEntry.value as Map<String, dynamic>;

            // Fallback values (old cache)
            final cachedName = otherUser['name'] ?? 'User';
            final cachedImage = otherUser['image'] ?? '';

            final lastMessage = chat['lastMessage'] ?? "";

            // Wrap each tile inside FutureBuilder
            return FutureBuilder(
              future: controller.fetchUserLiveData(otherUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return messageTile(
                    context,
                    name: cachedName,
                    message: lastMessage,
                    profileImage: cachedImage,
                  );
                }

                final liveData = snapshot.data as Map<String, dynamic>;
                final liveName = liveData['name'] ?? cachedName;
                final liveImage = liveData['profileImage'] ?? cachedImage;

                return messageTile(
                  context,
                  name: liveName,
                  message: lastMessage,
                  profileImage: liveImage,
                  onTap: () {
                    Get.toNamed(
                      Routes.chatScreen,
                      arguments: {"otherUserID": otherUserId},
                    );
                  },
                  // onTap: () {
                  //   Get.to(() => ChatScreen(
                  //     chatId: chat['chatId'],
                  //     otherUserId: otherUserId,
                  //     otherName: liveName,
                  //     otherImage: liveImage,
                  //     employeeData: {
                  //       'uid': otherUserId,
                  //       'name': liveName,
                  //       'profileImage': liveImage,
                  //     },
                  //   ));
                  // },
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
              borderColor: AppColors.colorFFFFFF,
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
                      color: AppColors.colorFFFFFF,
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
