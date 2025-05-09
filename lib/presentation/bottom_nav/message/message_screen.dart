import 'package:barbee_hive_app/data/firebase/firebase_chat_service.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

/*class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        separatorBuilder: (context, index) => SizedBox(height: 15.h),
        itemCount: 3,
        itemBuilder: (context, index) {
          return messageTile(context);
        },
      ),
    );
  }

  Widget messageTile(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.chatScreen);
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
              imagePath: AppAssets.profileImage,
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
                    "Kyle Crane",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    "Hey, I saw your profile and found you suitable for this position",
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
}*/

import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_screen.dart';

class MessageScreen extends StatelessWidget {
  final String currentUserID;
  final int role; // 'employee' or 'employer'

  MessageScreen({required this.currentUserID, required this.role});

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getChatRooms(currentUserID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return Center(child: Text('No chats yet.'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              String otherUserID = chat['participants']
                  .firstWhere((id) => id != currentUserID);

              return ListTile(
                title: Text(otherUserID),
                subtitle: Text(chat['lastMessage'] ?? 'No messages yet'),
                trailing: Text(
                  _formatTimestamp(chat['lastMessageTime']),
                  style: TextStyle(fontSize: 12.sp),
                ),
                onTap: () async {
                  String chatID = await _chatService.getChatRoomID(currentUserID, otherUserID);
                  Get.to(() => ChatScreen(
                    chatID: chatID,
                    otherUserID: otherUserID,
                    currentUserID: currentUserID,
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    return '${date.hour}:${date.minute} ${date.day}/${date.month}';
  }
}
