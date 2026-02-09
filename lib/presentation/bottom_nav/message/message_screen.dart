import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_profile_image.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/widgets/custom_appbar.dart';

class MessageScreen extends GetView<ChatController> {
  const MessageScreen({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        showHexagon: false,
        profileImagePath: controller.userProfileImage.value,
        context: context,
        leadingTapFunction: () {
          if (onMenuPressed != null) onMenuPressed!();
        },
        title: '',
        titleWidget: SvgPicture.asset(
          AppAssets.appIconTwo,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: AppColors.black,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: const MessageBannerAdWidget(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chats.isEmpty) {
          return const Center(
            child: CustomText(
              title: "No chats yet",
              color: AppColors.colorFFFFFF,
              fontSize: 18,
            ),
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
            final readBy = (chat['readBy'] as List?) ?? const [];
            final lastMessageSenderId = chat['lastMessageSenderId'] ?? '';
            final isUnread =
                lastMessage.toString().isNotEmpty &&
                lastMessageSenderId != currentUserId &&
                !readBy.contains(currentUserId);

            // Wrap each tile inside FutureBuilder
            return FutureBuilder(
              future: controller.otherUserLiveData(otherUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return messageTile(
                    name: cachedName,
                    message: lastMessage,
                    profileImage: cachedImage,
                    isUnread: isUnread,
                  );
                }

                final liveData = snapshot.data as Map<String, dynamic>;
                final liveName = liveData['name'] ?? cachedName;
                final liveImage = liveData['profileImage'] ?? cachedImage;

                return messageTile(
                  name: liveName,
                  message: lastMessage,
                  profileImage: liveImage,
                  isUnread: isUnread,
                  onTap: () {
                    Get.toNamed(
                      Routes.chatScreen,
                      arguments: {"otherUserID": otherUserId},
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget messageTile({
    required String name,
    required String message,
    required String profileImage,
    bool isUnread = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.color101010,
          border: Border.all(
            color: isUnread ? AppColors.colorFF8600 : Colors.transparent,
            width: isUnread ? 1.0 : 0,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            /// PROFILE IMAGE
            CustomProfileImage(
              imagePath: profileImage,
              wholeAvatarClickable: false,
              width: 105.w,
              height: 115.h,
              borderColor: AppColors.colorFFFFFF,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// USER NAME
                  CustomText(
                    title: name,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorFFFFFF,
                  ),

                  /// CHAT LAST MESSAGE
                  CustomText(
                    title: message,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey.withOpacity(0.5),
                    textOverflow: TextOverflow.ellipsis,
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

class MessageBannerAdWidget extends StatefulWidget {
  const MessageBannerAdWidget({super.key});

  @override
  State<MessageBannerAdWidget> createState() => _MessageBannerAdWidgetState();
}

class _MessageBannerAdWidgetState extends State<MessageBannerAdWidget> {
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
