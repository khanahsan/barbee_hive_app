

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class ChatScreen extends StatelessWidget {
  // final String? chatId;
  final String otherUserId;
  final String chatType;

  ChatScreen({
    super.key,
    // this.chatId = '',
    required this.otherUserId,
    this.chatType = 'employer_employee',
  });

  final ChatController chatController = Get.find();
  final TextEditingController messageController = TextEditingController();

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: chatController.fetchUserLiveData(otherUserId),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final otherUser = userSnapshot.data!;
        final otherName = otherUser["name"] ?? "User";
        final otherImage = otherUser["profileImage"] ?? "";
        final otherRole = otherUser["role"] ?? 0;

        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection("chats")
                  .doc("${chatController.currentUserId.value}-$otherUserId")
                  .snapshots(),
          builder: (context, chatSnapshot) {
            if (!chatSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final chatData =
                chatSnapshot.data!.data() as Map<String, dynamic>? ?? {};
            final blockedBy = chatData["blockedBy"];
            final isBlocked = blockedBy != null;

            final amIEmployer = chatController.isEmployer.value;
            final canBlock = amIEmployer && otherRole != 2; // FIXED

            return Scaffold(
              backgroundColor: Colors.black,
              appBar: customAppbar(
                profileImagePath: otherImage,
                context: context,
                leadingTapFunction: () => Get.back(),
                title: otherName,
                showActions: canBlock,
                // FIXED
                leadingIconPath: AppAssets.backIcon,
                actions:
                    canBlock
                        ? [
                          Switch(
                            value: isBlocked,
                            onChanged: (value) {
                              if (value) {
                                chatController.blockEmployee("${chatController.currentUserId.value}-$otherUserId");
                              } else {
                                chatController.unblockEmployee("${chatController.currentUserId.value}-$otherUserId");
                              }
                            },
                            activeColor: AppColors.colorFF8600,
                            inactiveThumbColor: AppColors.grey,
                            inactiveTrackColor: AppColors.grey.withOpacity(0.5),
                          ),
                        ]
                        : null,
              ),

              body: Column(
                children: [
                  // messages
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc("${chatController.currentUserId.value}-$otherUserId")
                              .collection("messages")
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                      builder: (context, messageSnapshot) {
                        if (!messageSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.color4C4C4C,
                            ),
                          );
                        }

                        final messages = messageSnapshot.data!.docs;

                        if (messages.isEmpty) {
                          return const Center(
                            child: Text(
                              "No messages yet",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.only(top: 10, bottom: 15),
                          reverse: true,
                          separatorBuilder: (_, __) => SizedBox(height: 15.h),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg =
                                messages[index].data() as Map<String, dynamic>;
                            final isMe =
                                msg["senderId"] ==
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
                                    width: 50.w,
                                    height: 60.h,
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
                                              ? AppColors.colorFF8600
                                              : AppColors.color27272A,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (!isMe)
                                          Text(
                                            otherName,
                                            style: TextStyle(
                                              color: AppColors.colorFF8600,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        Text(
                                          msg["text"] ?? "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            msg["timestamp"] != null
                                                ? formatTimestamp(
                                                  msg["timestamp"],
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

                  // message input
                  if (isBlocked)
                    Container(
                      padding: EdgeInsets.all(15),
                      child: const Text(
                        "You cannot send a message to this user.",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  else
                    SafeArea(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.color545458),
                        ),
                        child: Stack(
                          children: [
                            AppTextField(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 5.h,
                              ),
                              fillColor: AppColors.color000000,
                              filled: true,
                              enabledBorderColor: Colors.transparent,
                              hintText: 'Type here...',
                              controller: messageController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              maxLines: 3,
                            ),

                            Positioned(
                              bottom: 1.h,
                              right: 1.w,
                              child: GestureDetector(
                                onTap: () {
                                  final text = messageController.text.trim();
                                  if (text.isNotEmpty) {
                                    chatController.sendMessage(
                                      "${chatController.currentUserId.value}-$otherUserId",
                                      text,
                                      {
                                        "uid": otherUserId,
                                        "name": otherUser["name"] ?? "",
                                        "profileImage":
                                            otherUser["profileImage"] ?? "",
                                        "role": otherUser["role"] ?? "",
                                      },
                                      chatType, // same as old code
                                    );
                                    messageController.clear();
                                  }
                                },
                                child: Container(
                                  width: 30.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.colorFF8600,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.colorFFFFFF,
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
