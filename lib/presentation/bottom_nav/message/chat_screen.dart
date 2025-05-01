// import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../infrastructure/widgets/custom_appbar.dart';
//
//
// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppbar(
//         context: context,
//         leadingTapFunction: () {
//           Get.back();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Menu pressed')),
//           );
//         },
//         currentBottomIndex: 1, // Assuming 1 is for chat/messages
//         title: "Kyle Crane",
//         showActions: false,
//         leadingIconPath: AppAssets.backIcon,
//       ),
//       body: Center(
//         child: Text("Chat screen content goes here"),
//       ),
//     );
//   }
// }

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text_field.dart';
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
      backgroundColor: Colors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Menu pressed')));
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSenderBubble(
                  message: 'Hey, what time are we meeting today?',
                  time: '16:20',
                  context: context,
                ),
                _buildReceiverBubble(
                  name: 'Kyle Crane',
                  message: 'Around 6 PM, does that work for you?',
                  time: '16:20',
                  context: context,
                ),
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
        margin: const EdgeInsets.only(top: 8),
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
            margin: const EdgeInsets.only(top: 8),
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
      hint: "Send Message",
      icon: AppAssets.bagTwoIcon,
      controller: TextEditingController(),
    );
  }

  // Widget _buildInputField() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     color: Colors.black,
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             decoration: BoxDecoration(
  //               color: Colors.grey.shade900,
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: const TextField(
  //               style: TextStyle(color: Colors.white),
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 hintText: 'That works great for me. See you then!',
  //                 hintStyle: TextStyle(color: Colors.white70),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         CircleAvatar(
  //           radius: 18,
  //           backgroundColor: Colors.orange,
  //           child: Icon(Icons.arrow_upward, color: Colors.white),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
