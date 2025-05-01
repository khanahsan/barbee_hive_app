import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/custom_appbar.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/custom_icon_button.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int currentBottomIndex = 0;
    Widget _buildSvgPicture({
      required String iconPath,
      required double iconHeight,
      required double iconWidth,
    }) {
      return SvgPicture.asset(
        iconPath,
        fit: BoxFit.cover,
        height: iconHeight,
        width: iconWidth,
      );
    }

    PreferredSize appBarSection({required BuildContext context}) {
      return PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
          child: AppBar(
            backgroundColor: AppColors.color101010,
            toolbarHeight: 100.h,
            elevation: 0,

            title: Row(
              children: [
                /* GestureDetector(
                  onTap: onMenuPressed,
                  child: _buildSvgPicture(
                    iconPath: AppAssets.menuIcon,
                    iconHeight: 18.h,
                    iconWidth: 18.w,
                  ),
                ),
                SizedBox(width: 10.w),*/
                HexagonAvatar(
                  imagePath: AppAssets.profileImage,
                  width: 55.w,
                  height: 65.h,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildSvgPicture(
                  iconPath: AppAssets.settingIcon,
                  iconHeight: 24.h,
                  iconWidth: 24.w,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // appBar: appBarSection(context: context),
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        currentBottomIndex: 1,
        title: "Profile",
        showActions: true,
        leadingIconPath: AppAssets.backIcon,
        actions: [
          SvgPicture.asset(
            AppAssets.settingIcon,
            fit: BoxFit.cover,
            height: 23.h,
            width: 23.w,
            color: AppColors.white,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              //height: 200.h,
              child: Image.asset(AppAssets.backgroundLogo, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    profileButton(
                      context: context,
                      buttonText: "Profile image",
                      buttonIconPath: AppAssets.bagIcon,
                    ),

                    profileButton(
                      context: context,
                      buttonText: "Cover Photo",
                      buttonIconPath: AppAssets.bagIcon,
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20.w),

                Container(
                  height: 532.h,
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.r),
                      topRight: Radius.circular(20.0.r),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "John William",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Experience",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(text: "  "),
                              TextSpan(
                                text: "Bartender",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        CustomBtn(
                          btnTitle: 'Edit Profile',
                          btnBackgroundColor: AppColors.primary,
                          btnTxtColor: Colors.white,
                          // width: double.infinity,
                          onPressed: () {},
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget profileButton({
  required String buttonText,
  required buttonIconPath,
  required BuildContext context,
}) {
  return InkWell(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.color101010,
        border: Border.all(color: AppColors.boxBorder, width: 2.sp),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            buttonIconPath,
            height: 22.h,
            width: 22.w,
            fit: BoxFit.cover,
          ),
          Text(
            buttonText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget profileButton({required String buttonText, required buttonIconPath}) {
//   return ElevatedButton(
//     onPressed: () {},
//     style: ButtonStyle(
//       backgroundColor: WidgetStateProperty.resolveWith<Color?>((
//         Set<WidgetState> states,
//       ) {
//         if (states.contains(WidgetState.pressed)) {
//           return Colors.grey; // Color when pressed
//         }
//         return Colors.black; // Default color
//       }),
//       shape: WidgetStateProperty.all(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(10.0),
//           ), // Square, no rounded corners
//         ),
//       ),
//       minimumSize: WidgetStateProperty.all(
//         const Size(150, 50),
//       ), // Rectangular size
//     ),
//     child: const Row(
//       mainAxisSize: MainAxisSize.min, // Fit content
//       children: [
//         Icon(Icons.beach_access, color: Colors.white), // Icon
//         SizedBox(width: 8), // Space between icon and text
//         Text(
//           'Profile image',
//           style: TextStyle(color: Colors.white), // Text color
//         ),
//       ],
//     ),
//   );
// }
