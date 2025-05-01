import 'package:barbee_hive_app/infrastructure/widgets/custom_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/navigation/routes.dart';
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

    PreferredSize appBarSection({
      required BuildContext context,
    }) {
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
      appBar: appBarSection(
        context: context,

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

              spacing: 15.h,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomProfileButton(
                      text: 'Profile image',
                      icon: Icons.beach_access,
                      onPressed: () {
                        // Define your on-press action here
                        print('Button pressed!');
                      },
                    ),

                    CustomProfileButton(
                      text: 'Profile image',
                      icon: Icons.beach_access,
                      onPressed: () {
                        // Define your on-press action here
                        print('Button pressed!');
                      },
                    ),

                    profileButton(),

                    profileButton()
                  ],
                ),

                Container(
                  height: 532.h,
                  margin: EdgeInsets.only(top: 20.h),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10.h,
                        children: [


                          SizedBox(height: 120.h),
                          CustomBtn(
                            btnTitle: 'Sign In',
                            btnBackgroundColor: AppColors.primary,
                            btnTxtColor: Colors.white,
                            // width: double.infinity,
                            onPressed: () {},
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 12, color: AppColors.white),
                              children: [
                                TextSpan(
                                  text: "Dont't have an account?",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      /*// Open YouTube URL
                              const url = 'https://www.youtube.com';
                              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);*/
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
}

Widget profileButton() {
  return ElevatedButton(
    onPressed: () {},
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.grey; // Color when pressed
          }
          return Colors.black; // Default color
        },
      ),
      shape: WidgetStateProperty.all(
         RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)), // Square, no rounded corners
        ),
      ),
      minimumSize: WidgetStateProperty.all(const Size(150, 50)), // Rectangular size
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min, // Fit content
      children: [
        Icon(Icons.beach_access, color: Colors.white), // Icon
        SizedBox(width: 8), // Space between icon and text
        Text(
          'Profile image',
          style: TextStyle(color: Colors.white), // Text color
        ),
      ],
    ),
  );
}