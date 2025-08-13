import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_appbar.dart';
import '../../../infrastructure/widgets/hexagon_clipper.dart';

class ChatScreen extends StatelessWidget {
  final String chatID;
  final String otherUserID;
  final String currentUserID;

  ChatScreen({
    super.key,
    required this.chatID,
    required this.otherUserID,
    required this.currentUserID,
  });

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String formatTimestamp(Timestamp timestamp) {
      final dateTime = timestamp.toDate();
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        profileImagePath: '',
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        title: '',
        showActions: false,
        leadingIconPath: AppAssets.backIcon,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatID)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No messages yet"));
                }

                final chatData = snapshot.data!.data() as Map<String, dynamic>;
                final messages = List<Map<String, dynamic>>.from(
                  chatData['messages'] ?? [],
                );

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (__, _) => SizedBox(height: 15.h),
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isMe = message['senderId'] == currentUserID;

                    return Row(
                      spacing: 5.w,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment:
                          isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        if (!isMe) ...[
                          HexagonAvatar(
                            imagePath: chatData['receiverProfileImage'] ?? '',
                            width: 35.w,
                            height: 45.h,
                          ),
                        ],
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMe
                                      ? AppColors.primary
                                      : AppColors.color27272A,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              spacing: 1.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isMe) // Show name only for the other person's messages
                                  Text(
                                    chatData['receiverName'] ?? 'Unknown User',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                Text(
                                  message['text'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    formatTimestamp(message['timestamp']),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          Container(
            // width: 350,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.color545458),
            ),
            child: Stack(
              children: [
                TextFormField(
                  controller: _messageController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type here...',
                    hintStyle: TextStyle(
                      color: AppColors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.only(right: 90),
                  ),
                ),
                Positioned(
                  bottom: 1.h,
                  right: 1.w,
                  child: GestureDetector(
                    onTap: () async {
                      if (_messageController.text.trim().isEmpty) return;

                      await FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatID)
                          .update({
                            'messages': FieldValue.arrayUnion([
                              {
                                'senderId': currentUserID,
                                'text': _messageController.text.trim(),
                                'timestamp': Timestamp.now(),
                              },
                            ]),
                            'updatedAt': Timestamp.now(),
                          });

                      _messageController.clear();
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.white,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 15.w, vertical: 15.h),
    );
  }
}
