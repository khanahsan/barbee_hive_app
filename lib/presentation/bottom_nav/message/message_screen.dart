import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance
            .collection('chats')
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No messages yet",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final messages = List<Map<String, dynamic>>.from(
                chat['messages'] ?? [],
              );
              String lastMessage = '';
              if (messages.isNotEmpty) {
                lastMessage = messages.last['text'] ?? '';
              }
              final userName = chat['name'] ?? 'Unknown';
              final profileImage =
                  chat['profileImage'] ?? AppAssets.profileImage;

              final senderID =
                  chat['senderId'] ?? '';

              final receiverID =
                  chat['receiverId'] ?? '';

              return messageTile(
                context,
                name: userName,
                message: lastMessage,
                profileImage: profileImage,
                senderID: senderID,
                receiverID: receiverID,
              );
            },
          );
        },
      ),
    );
  }

  Widget messageTile(BuildContext context, {
    required String name,
    required String message,
    required String profileImage,
    required String senderID,
    required String receiverID,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.chatScreen, arguments: {
          'chatID': '$senderID-$receiverID',
          'otherUserID': receiverID,
          'currentUserID': senderID,
        });
      },
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
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

