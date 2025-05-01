import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_textfield.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_appbar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        currentBottomIndex: 1,
        title: "Kyle Crane",
        showActions: false,
        leadingIconPath: AppAssets.backIcon,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text('Sat, Feb 28, 9:41', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              children: [
                _buildSenderBubble(
                  message: 'Hey, what time are we meeting today?',
                  time: '16:20',
                  context: context,
                ),
                SizedBox(height: 20.h),
                _buildReceiverBubble(
                  name: 'Kyle Crane',
                  message: 'Around 6 PM, does that work for you?',
                  time: '16:20',
                  context: context,
                ),
                SizedBox(height: 20.h),
                _buildSenderBubble(
                  message: 'Cool, I’ll text you when I get there.',
                  time: '16:20',
                  context: context,
                ),
                SizedBox(height: 20.h),
                _buildReceiverBubble(
                  name: 'Kyle Crane',
                  message: 'Around 6 PM, does that work for you?',
                  time: '16:20',
                  context: context,
                ),
                SizedBox(height: 20.h),
                _buildSenderBubble(
                  message: 'Cool, I’ll text you when I get there.',
                  time: '16:20',
                  context: context,
                ),
              ],
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildSenderBubble({
    required String message,
    required String time,
    required BuildContext context,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 280.w,
        // margin: const EdgeInsets.only(top: 8),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5.h,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: AppColors.white.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverBubble({
    required String name,
    required String message,
    required String time,
    required BuildContext context,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2.w,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          HexagonAvatar(
            imagePath: AppAssets.profileImage,
            width: 40.w,
            height: 50.h,
          ),
          Container(
            width: 280.w,
            // margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.color27272A,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return CustomTextField(
      maxLines: 3,
      enabledBorderColor: AppColors.color545458,
      hintText: "Send Message",
      suffixIcon: Container(
        margin: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
        // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_forward, color: AppColors.white),
      ),
    ).paddingSymmetric(horizontal: 15.w);
  }
}
