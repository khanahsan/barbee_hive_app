// import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
// import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
// import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
// import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
// import 'package:barbee_hive_app/presentation/bottom_nav/bottom_nav_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:my_responsive_ui/my_responsive_ui.dart';
//
// import '../../presentation/auth/controllers/auth.controller.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_images.dart';
// import '../navigation/routes.dart';
//
// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({super.key});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _drawerScaleAnimation;
//   late Animation<double> _dashboardStackScaleAnimation;
//
//   bool _isDrawerOpen = false;
//   int selectedIndex = 0;
//
//   String userName = '';
//   String userProfileImage = '';
//
//   void toggleDrawer() {
//     if (_isDrawerOpen) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//     setState(() {
//       _isDrawerOpen = !_isDrawerOpen;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//
//     _offsetAnimation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _drawerScaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _dashboardStackScaleAnimation = Tween<double>(
//       begin: 0.9,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _loadUserData();
//   }
//
//   void _loadUserData() async {
//     final currentUserName = SharedPreferenceHelper.getString(
//       SharedPrefKeys.userName,
//     );
//     final currentProfileImage = SharedPreferenceHelper.getString(
//       SharedPrefKeys.userProfileImage,
//     );
//     setState(() {
//       userName = currentUserName ?? "";
//       userProfileImage = currentProfileImage ?? "";
//     });
//   }
//
//   void onItemTapped(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           if (_isDrawerOpen)
//             Container(
//               color: AppColors.black,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: 25.w,
//                     top: 80.h,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: ScaleTransition(
//                         scale: _drawerScaleAnimation,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             /// CLOSE OPTION
//                             InkWell(
//                               onTap: toggleDrawer,
//                               child: SvgPicture.asset(
//                                 AppAssets.closeIcon,
//                                 width: 15.w,
//                                 height: 15.h,
//                                 color: AppColors.white,
//                                 fit: BoxFit.cover,
//                               ).paddingSymmetric(horizontal: 5.w),
//                             ),
//                             SizedBox(height: 30.h),
//
//                             /// USER PROFILE IMAGE
//                             HexagonAvatar(
//                               imagePath: userProfileImage,
//                               width: 60.w,
//                               height: 70.h,
//                               borderColor: AppColors.primary,
//                             ),
//
//                             /// LABEL
//                             CustomText(
//                               title: "Welcome",
//                               fontSize: 19,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w600,
//                             ),
//
//                             /// USER NAME
//                             CustomText(
//                               title: userName,
//                               fontSize: 30,
//                               color: AppColors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             SizedBox(height: 60.h),
//
//                             /// EDIT PROFILE OPTION
//                             drawerMenuTile(
//                               title: "Edit Profile",
//                               iconPath: AppAssets.editIcon,
//                               onTap: () {
//                                 Get.toNamed(Routes.PROFILE_SCREEN);
//                               },
//                             ),
//                             SizedBox(height: 25.h),
//
//                             /// MY JOBS OPTION
//                             drawerMenuTile(
//                               title: "My Jobs",
//                               iconPath: AppAssets.jobIcon,
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 25.h),
//
//                             /// SETTINGS OPTION
//                             drawerMenuTile(
//                               title: "Setting",
//                               iconPath: AppAssets.settingIcon,
//                               onTap: () {
//                                 Get.toNamed(Routes.settingsScreen);
//                               },
//                             ),
//                             SizedBox(height: 25.h),
//
//                             /// LOGOUT OPTION
//                             drawerMenuTile(
//                               title: "Logout",
//                               iconPath: AppAssets.exitIcon,
//                               onTap: () {
//                                 print('Logout tap');
//                                 Get.find<AuthController>().logout();
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           else
//             BottomNavScreen(onMenuPressed: toggleDrawer),
//
//           // screens[selectedIndex],
//
//           // Red Container animating in from right
//           IgnorePointer(
//             ignoring: _isDrawerOpen,
//             child: SlideTransition(
//               position: _offsetAnimation,
//               child: GestureDetector(
//                 onTap: toggleDrawer, // close drawer when tapping overlay
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: ScaleTransition(
//                     scale: _dashboardStackScaleAnimation,
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       alignment: Alignment.center,
//                       children: [
//                         SizedBox(height: 700.h, width: 150.w),
//                         Positioned(
//                           left: -15.w,
//                           child: Container(
//                             height: 500.h,
//                             width: 250.w,
//                             decoration: BoxDecoration(
//                               color: AppColors.color151515,
//                               borderRadius: BorderRadius.circular(30.r),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: 10.w,
//                           child: Container(
//                             height: 600.h,
//                             width: 250.w,
//                             decoration: BoxDecoration(
//                               color: AppColors.color1F1F1F,
//                               borderRadius: BorderRadius.circular(30.r),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: 40.w,
//                           child: Container(
//                             height: 700.h,
//                             width: 250.w,
//                             decoration: BoxDecoration(
//                               color: Colors.orange,
//                               borderRadius: BorderRadius.circular(30.r),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(30.r),
//                               child: BottomNavScreen(
//                                 onMenuPressed: toggleDrawer,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   Widget drawerMenuTile({
//     required String title,
//     required String iconPath,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         spacing: 12.w,
//         children: [
//           SvgPicture.asset(
//             iconPath,
//             width: 22.w,
//             height: 22.h,
//             fit: BoxFit.cover,
//           ),
//           CustomText(
//             title: title,
//             fontSize: 20,
//             color: AppColors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//

// import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
// import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
// import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
// import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
// import 'package:barbee_hive_app/presentation/bottom_nav/bottom_nav_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:my_responsive_ui/my_responsive_ui.dart';
//
// import '../../../presentation/auth/controllers/auth.controller.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/app_images.dart';
// import '../../navigation/routes.dart';
//
// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({super.key});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _drawerScaleAnimation;
//   late Animation<double> _dashboardStackScaleAnimation;
//
//   bool _isDrawerOpen = false;
//
//   String userName = '';
//   String userProfileImage = '';
//
//   void toggleDrawer() {
//     if (_isDrawerOpen) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//     setState(() {
//       _isDrawerOpen = !_isDrawerOpen;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 280), // faster & smoother
//       vsync: this,
//     );
//
//     _offsetAnimation = Tween<Offset>(
//       begin: const Offset(1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _drawerScaleAnimation = Tween<double>(
//       begin: 0.92,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _dashboardStackScaleAnimation = Tween<double>(
//       begin: 0.97,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//
//     _loadUserData();
//   }
//
//   void _loadUserData() async {
//     final currentUserName =
//     SharedPreferenceHelper.getString(SharedPrefKeys.userName);
//     final currentProfileImage =
//     SharedPreferenceHelper.getString(SharedPrefKeys.userProfileImage);
//
//     setState(() {
//       userName = currentUserName ?? "";
//       userProfileImage = currentProfileImage ?? "";
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           /// Drawer background (only visible when open)
//           if (_isDrawerOpen)
//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: Container(
//                 color: AppColors.black,
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 25.w, top: 80.h),
//                   child: ScaleTransition(
//                     scale: _drawerScaleAnimation,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         InkWell(
//                           onTap: toggleDrawer,
//                           child: SvgPicture.asset(
//                             AppAssets.closeIcon,
//                             width: 15.w,
//                             height: 15.h,
//                             color: AppColors.white,
//                           ).paddingSymmetric(horizontal: 5.w),
//                         ),
//                         SizedBox(height: 30.h),
//
//                         HexagonAvatar(
//                           imagePath: userProfileImage,
//                           width: 60.w,
//                           height: 70.h,
//                           borderColor: AppColors.primary,
//                         ),
//
//                         CustomText(
//                           title: "Welcome",
//                           fontSize: 19,
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         CustomText(
//                           title: userName,
//                           fontSize: 30,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         SizedBox(height: 60.h),
//
//                         drawerMenuTile(
//                           title: "Edit Profile",
//                           iconPath: AppAssets.editIcon,
//                           onTap: () {
//                             Get.toNamed(Routes.PROFILE_SCREEN);
//                           },
//                         ),
//                         SizedBox(height: 25.h),
//
//                         drawerMenuTile(
//                           title: "My Jobs",
//                           iconPath: AppAssets.jobIcon,
//                           onTap: () {},
//                         ),
//                         SizedBox(height: 25.h),
//
//                         drawerMenuTile(
//                           title: "Setting",
//                           iconPath: AppAssets.settingIcon,
//                           onTap: () {
//                             Get.toNamed(Routes.settingsScreen);
//                           },
//                         ),
//                         SizedBox(height: 25.h),
//
//                         drawerMenuTile(
//                           title: "Logout",
//                           iconPath: AppAssets.exitIcon,
//                           onTap: () {
//                             Get.find<AuthController>().logout();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           else
//             BottomNavScreen(onMenuPressed: toggleDrawer),
//
//           /// Foreground content (kept outside animation rebuild)
//           IgnorePointer(
//             ignoring: _isDrawerOpen,
//             child: SlideTransition(
//               position: _offsetAnimation,
//               child: GestureDetector(
//                 onTap: toggleDrawer,
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: ScaleTransition(
//                     scale: _dashboardStackScaleAnimation,
//                     child: _buildDashboardStack(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDashboardStack() {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.center,
//       children: [
//         SizedBox(height: 700.h, width: 150.w),
//         Positioned(
//           left: -15.w,
//           child: Container(
//             height: 500.h,
//             width: 250.w,
//             decoration: BoxDecoration(
//               color: AppColors.color151515,
//               borderRadius: BorderRadius.circular(30.r),
//             ),
//           ),
//         ),
//         Positioned(
//           left: 10.w,
//           child: Container(
//             height: 600.h,
//             width: 250.w,
//             decoration: BoxDecoration(
//               color: AppColors.color1F1F1F,
//               borderRadius: BorderRadius.circular(30.r),
//             ),
//           ),
//         ),
//         Positioned(
//           left: 40.w,
//           child: Container(
//             height: 700.h,
//             width: 250.w,
//             decoration: BoxDecoration(
//               color: Colors.orange,
//               borderRadius: BorderRadius.circular(30.r),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30.r),
//               child: BottomNavScreen(
//                 onMenuPressed: toggleDrawer,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget drawerMenuTile({
//     required String title,
//     required String iconPath,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         spacing: 12.w,
//         children: [
//           SvgPicture.asset(
//             iconPath,
//             width: 22.w,
//             height: 22.h,
//           ),
//           CustomText(
//             title: title,
//             fontSize: 20,
//             color: AppColors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../presentation/auth/controllers/auth.controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../navigation/routes.dart';
import 'controller/custom_drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomDrawerController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            /// Drawer background (only visible when open)
            if (controller.isDrawerOpen.value)
              FadeTransition(
                opacity: controller.fadeAnimation,
                child: Container(
                  color: AppColors.black,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.w, top: 80.h),
                    child: ScaleTransition(
                      scale: controller.drawerScaleAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: controller.toggleDrawer,
                            child: SvgPicture.asset(
                              AppAssets.closeIcon,
                              width: 15.w,
                              height: 15.h,
                              color: AppColors.white,
                            ).paddingSymmetric(horizontal: 5.w),
                          ),
                          SizedBox(height: 30.h),

                          HexagonAvatar(
                            imagePath: controller.userProfileImage.value,
                            width: 60.w,
                            height: 70.h,
                            borderColor: AppColors.primary,
                          ),

                          CustomText(
                            title: "Welcome",
                            fontSize: 19,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            title: controller.userName.value,
                            fontSize: 30,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 60.h),

                          drawerMenuTile(
                            title: "Edit Profile",
                            iconPath: AppAssets.editIcon,
                            onTap: () {
                              Get.toNamed(Routes.PROFILE_SCREEN);
                            },
                          ),
                          SizedBox(height: 25.h),

                          drawerMenuTile(
                            title:
                                controller.role == 2
                                    ? "My Jobs"
                                    : "My Applications",
                            iconPath: AppAssets.jobIcon,
                            onTap: () {
                              controller.role == 2
                                  ? Get.toNamed(Routes.jobs)
                                  : Get.toNamed(Routes.myJobs);
                            },
                          ),

                          SizedBox(height: 25.h),

                          drawerMenuTile(
                            title: "Setting",
                            iconPath: AppAssets.settingIcon,
                            onTap: () {
                              Get.toNamed(Routes.settingsScreen);
                            },
                          ),
                          SizedBox(height: 25.h),

                          drawerMenuTile(
                            title: "Logout",
                            iconPath: AppAssets.exitIcon,
                            onTap: () {
                              Get.find<AuthController>().logout();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              BottomNavScreen(onMenuPressed: controller.toggleDrawer),

            /// Foreground content
            IgnorePointer(
              ignoring: controller.isDrawerOpen.value,
              child: SlideTransition(
                position: controller.offsetAnimation,
                child: GestureDetector(
                  onTap: controller.toggleDrawer,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ScaleTransition(
                      scale: controller.dashboardStackScaleAnimation,
                      child: _buildDashboardStack(controller),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardStack(CustomDrawerController controller) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(height: 700.h, width: 150.w),
        Positioned(
          left: -15.w,
          child: Container(
            height: 500.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: AppColors.color151515,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ),
        Positioned(
          left: 10.w,
          child: Container(
            height: 600.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: AppColors.color1F1F1F,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ),
        Positioned(
          left: 40.w,
          child: Container(
            height: 700.h,
            width: 250.w,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: BottomNavScreen(onMenuPressed: controller.toggleDrawer),
            ),
          ),
        ),
      ],
    );
  }

  Widget drawerMenuTile({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12.w,
        children: [
          SvgPicture.asset(iconPath, width: 22.w, height: 22.h),
          CustomText(
            title: title,
            fontSize: 21,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
