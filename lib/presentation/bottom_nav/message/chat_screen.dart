import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    return FutureBuilder<List<dynamic>>(
      // future: chatController.otherUserLiveData(otherUserId),
      future: Future.wait([
        chatController.currentUserLiveData(chatController.currentUserId.value),
        // CURRENT USER
        chatController.otherUserLiveData(otherUserId),
        // OTHER USER
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentUser = snapshot.data![0] as Map<String, dynamic>;
        final currentUserRole = currentUser["role"] ?? 0;

        final otherUser = snapshot.data![1] as Map<String, dynamic>;
        final otherUserName = otherUser["name"] ?? "User";
        final otherUserImage = otherUser["profileImage"] ?? "";
        final otherUserRole = otherUser["role"] ?? 0;

        final chatId = chatController.generateChatId(
          chatController.currentUserId.value,
          otherUserId,
        );

        // Mark chat as read when opening
        chatController.markChatAsRead(chatId);

        log("CURRENT USER ROLE: $currentUserRole");
        log("OTHER USER ROLE: $otherUserRole");

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
            final blockedBy = chatData["blockedBy"];
            final isBlocked = blockedBy != null;

            final amIEmployer = chatController.isEmployer.value;
            final canBlock = amIEmployer && otherUserRole != 2; // FIXED

            return Scaffold(
              backgroundColor: Colors.black,
              appBar: customAppbar(
                profileImagePath: otherUserImage,
                context: context,
                leadingTapFunction: () => Get.back(),
                title: otherUserName,
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
                                chatController.blockEmployee(chatId);
                              } else {
                                chatController.unblockEmployee(chatId);
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
                  // Banner Ad at top
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    child: const ChatBannerAdWidget(),
                  ),
                  // messages
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(chatId)
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
                              final msg = messages[index].data() as Map<String, dynamic>;
                              final isMe = msg["senderId"] == chatController.currentUserId.value;

                              return Row(
                                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!isMe) ...[
                                    HexagonAvatar(
                                      imagePath: otherUserImage,
                                      width: 50.w,
                                      height: 60.h,
                                    ),
                                    SizedBox(width: 5.w),
                                  ],

                                  // This ensures the bubble takes only necessary width
                                  IntrinsicWidth(
                                    stepWidth: 0,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.6, // max 70% width
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isMe ? AppColors.colorFF8600 : AppColors.color27272A,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!isMe)
                                              CustomText(
                                                title: otherUserName,
                                                color: AppColors.colorFF8600,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            SizedBox(height: 3.h),
                                            CustomText(
                                              title: msg["text"] ?? "",
                                              color: Colors.white,
                                              fontSize: 15,
                                              maxLines: null,
                                              softWrap: true,
                                            ),
                                            SizedBox(height: 5.h),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomText(
                                                title: msg["timestamp"] != null
                                                    ? formatTimestamp(msg["timestamp"])
                                                    : "",
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              /*        return Row(
                                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!isMe) ...[
                                    HexagonAvatar(
                                      imagePath: otherUserImage,
                                      width: 50.w,
                                      height: 60.h,
                                    ),
                                    SizedBox(width: 5.w),
                                  ],
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMe ? 10.w : 20.w, // Add more padding on left for "me"
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe ? AppColors.colorFF8600 : AppColors.color27272A,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (!isMe)
                                          CustomText(
                                            title: otherUserName,
                                            color: AppColors.colorFF8600,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        // Align text to the left for "me" messages
                                        Align(
                                          alignment: isMe ? Alignment.centerLeft : Alignment.centerLeft, // Align to left for both cases
                                          child: CustomText(
                                            title: msg["text"] ?? "",
                                            color: Colors.white,
                                            fontSize: 15,
                                            softWrap: true,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),

                                        // Align timestamp to the right for "me" messages
                                        Align(
                                          alignment: isMe ? Alignment.centerRight : Alignment.centerRight, // Align timestamp to the right
                                          child: CustomText(
                                            title: msg["timestamp"] != null
                                                ? formatTimestamp(msg["timestamp"])
                                                : "",
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );*/
                            }


                        );
                      },
                    ),
                  ),

                  /// SHOW BLOCK CHAT STATUS
                  if (isBlocked)
                    CustomText(
                      title:
                          currentUserRole == 'employee'
                              ? "The messages have been disabled by the employer"
                              : "You cannot send a message to this user.",
                      color: AppColors.expiredBannerColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ).paddingSymmetric(vertical: 25.h)
                  /// SHOW MESSAGE FIELD
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
                                      chatId,
                                      text,
                                      {
                                        "uid": otherUserId,
                                        "name": otherUser["name"] ?? "",
                                        "profileImage":
                                            otherUser["profileImage"] ?? "",
                                        "role": otherUser["role"] ?? "",
                                      },
                                      "${currentUserRole}_$otherUserRole",
                                      // chatType, // same as old code
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

class ChatBannerAdWidget extends StatefulWidget {
  const ChatBannerAdWidget({super.key});

  @override
  State<ChatBannerAdWidget> createState() => _ChatBannerAdWidgetState();
}

class _ChatBannerAdWidgetState extends State<ChatBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    AdsHelper().loadBannerAd(
      onAdLoaded: (ad) {
        if (!mounted) return;
        setState(() {
          _bannerAd = ad;
          _isLoaded = true;
        });
      },
      onAdFailed: () {
        if (!mounted) return;
        setState(() {
          _isLoaded = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
