import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

/* 
class ChatScreen extends StatelessWidget {
  final String chatId;
  final String otherName;
  final String otherImage;
  final Map<String, dynamic>? employeeData;

  ChatScreen({
    super.key,
    required this.chatId,
    required this.otherName,
    required this.otherImage,
    this.employeeData,
  });

  final ChatController chatController = Get.find();
  final TextEditingController _messageController = TextEditingController();

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("chats")
              .doc(chatId)
              .snapshots(),
      builder: (context, chatSnapshot) {
        if (!chatSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final chatData =
            chatSnapshot.data!.data() as Map<String, dynamic>? ?? {};
        final blockedBy = chatData['blockedBy'];

        final isBlocked = blockedBy != null;
        final amIEmployer = chatController.isEmployer.value;

        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: customAppbar(
            profileImagePath: otherImage.isNotEmpty ? otherImage : '',
            context: context,
            leadingTapFunction: () => Get.back(),
            title: otherName,
            showActions: amIEmployer,
            leadingIconPath: AppAssets.backIcon,
            actions:
                amIEmployer
                    ? [
                      Switch(
                        value: isBlocked,
                        onChanged: (value) {
                          if (value) {
                            chatController.blockEmployee(chatId);
                          } else {
                            chatController.unblockEmployee(chatId);
                          }
                        },
                        activeColor: AppColors.primary,
                        inactiveThumbColor: AppColors.grey,
                        inactiveTrackColor: AppColors.grey.withOpacity(0.5),
                      ),
                    ]
                    : null,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// messages
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatController.getMessagesStream(chatId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!.docs;

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "No messages yet",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      separatorBuilder: (_, __) => SizedBox(height: 15.h),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            messages[index].data() as Map<String, dynamic>;
                        final isMe =
                            message['senderId'] ==
                            chatController.currentUserId.value;

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
                                imagePath: otherImage,
                                width: 35.w,
                                height: 45.h,
                              ),
                            ],
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
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
                                    if (!isMe)
                                      Text(
                                        otherName,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    Text(
                                      message['text'] ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        message['timestamp'] != null
                                            ? formatTimestamp(
                                              message['timestamp'],
                                            )
                                            : "",
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
              SizedBox(height: 12.h),

              /// input field
              if (!(isBlocked &&
                  !amIEmployer)) // if blocked and current user is employee → hide input
                Container(
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
                          onTap: () {
                            final text = _messageController.text.trim();
                            if (text.isNotEmpty) {
                              chatController.sendMessage(
                                chatId,
                                text,
                                employeeData,
                              );
                              _messageController.clear();
                            }
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
              if (isBlocked && !amIEmployer)
                Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: Text(
                    "You can't send messages. Employer has blocked you.",
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ),
            ],
          ).paddingSymmetric(horizontal: 15.w, vertical: 22.h),
        );
      },
    );
  }
}
 */

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String otherName;
  final String otherImage;
  final Map<String, dynamic>? employeeData;
  final String chatType;
  ChatScreen({
    super.key,
    required this.chatId,
    required this.otherName,
    required this.otherImage,
    this.employeeData,
    this.chatType = 'employer_employee',
  });
  final ChatController chatController = Get.find();
  final TextEditingController _messageController = TextEditingController();

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("chats")
              .doc(chatId)
              .snapshots(),
      builder: (context, chatSnapshot) {
        if (!chatSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final chatData =
            chatSnapshot.data!.data() as Map<String, dynamic>? ?? {};
        final blockedBy = chatData['blockedBy'];
        final isBlocked = blockedBy != null;
        final amIEmployer = chatController.isEmployer.value;
        final showBlockSwitch = amIEmployer && employeeData!['role'] != 2;

        print('data ${employeeData!['role']}');
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: customAppbar(
            profileImagePath: otherImage.isNotEmpty ? otherImage : '',
            context: context,
            leadingTapFunction: () => Get.back(),
            title: otherName,
            showActions: showBlockSwitch,
            leadingIconPath: AppAssets.backIcon,
            actions:
                showBlockSwitch
                    ? [
                      Switch(
                        value: isBlocked,
                        onChanged: (value) {
                          if (value) {
                            chatController.blockEmployee(chatId);
                          } else {
                            chatController.unblockEmployee(chatId);
                          }
                        },
                        activeColor: AppColors.primary,
                        inactiveThumbColor: AppColors.grey,
                        inactiveTrackColor: AppColors.grey.withOpacity(0.5),
                      ),
                    ]
                    : null,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// messages
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatController.getMessagesStream(chatId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!.docs;
                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "No messages yet",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      separatorBuilder: (_, __) => SizedBox(height: 15.h),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            messages[index].data() as Map<String, dynamic>;
                        final isMe =
                            message['senderId'] ==
                            chatController.currentUserId.value;
                        return Row(
                          mainAxisAlignment:
                              isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isMe) ...[
                              HexagonAvatar(
                                imagePath: otherImage,
                                width: 35.w,
                                height: 45.h,
                              ),
                              SizedBox(width: 5.w),
                            ],
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!isMe)
                                      Text(
                                        otherName,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    Text(
                                      message['text'] ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        message['timestamp'] != null
                                            ? formatTimestamp(
                                              message['timestamp'],
                                            )
                                            : "",
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
              SizedBox(height: 12.h),

              /// input field
              if (!(isBlocked &&
                  chatType == 'employer_employee' &&
                  !amIEmployer))
                Container(
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
                          contentPadding: EdgeInsets.only(right: 90.w),
                        ),
                      ),
                      Positioned(
                        bottom: 1.h,
                        right: 1.w,
                        child: GestureDetector(
                          onTap: () {
                            final text = _messageController.text.trim();
                            if (text.isNotEmpty) {
                              chatController.sendMessage(
                                chatId,
                                text,
                                employeeData,
                                chatType,
                              );
                              _messageController.clear();
                            }
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
              if (isBlocked && chatType == 'employer_employee' && !amIEmployer)
                Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: Text(
                    "You can't send messages. Employer has blocked you.",
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ),
            ],
          ).paddingSymmetric(horizontal: 15.w, vertical: 22.h),
        );
      },
    );
  }
}
