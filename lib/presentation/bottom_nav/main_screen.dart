import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/find_job/find_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/custom_appbar.dart';
import 'dashboard/dashboard_screen.dart';
import 'message/message_screen.dart';
import 'pricing_plans/pricing_plans_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentBottomIndex = 0;

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Dashboard";
      case 1:
        return "Messages";
      case 2:
        return "Find Jobs";
      case 3:
        return "Pricing Plans";
      default:
        return "";
    }
  }

  final List<Widget> screens = [
    DashboardScreen(),
    MessageScreen(),
    FindJobScreen(),
    PricingPlansScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      currentBottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          widget.onMenuPressed();
        },
        // currentBottomIndex: 1,
        title: _getAppBarTitle(currentBottomIndex),
        showActions: true,
        leadingIconPath: AppAssets.menuIcon,
        actions:
            currentBottomIndex != 1 && currentBottomIndex != 3
                ? [
                  _buildSvgPicture(
                    iconPath: AppAssets.bellIcon,
                    iconHeight: 24.h,
                    iconWidth: 24.w,
                  ),
                  currentBottomIndex != 2 ? SizedBox(width: 10.w) : SizedBox(),
                  currentBottomIndex != 2
                      ? _buildSvgPicture(
                        iconPath: AppAssets.filterIcon,
                        iconHeight: 24.h,
                        iconWidth: 24.w,
                      )
                      : SizedBox(),
                ]
                : null,
      ),

      // appBar: appBarSection(
      //   context: context,
      //   onMenuPressed: widget.onMenuPressed,
      //   currentBottomIndex: currentBottomIndex,
      // ),
      backgroundColor: Colors.black,
      body: screens[currentBottomIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentBottomIndex,
        onTap: onItemTapped,
      ),
    );
  }

  // PreferredSize appBarSection({
  //   required BuildContext context,
  //   required VoidCallback onMenuPressed,
  //   required int currentBottomIndex,
  // }) {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(100.h),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(25.r),
  //         bottomRight: Radius.circular(25.r),
  //       ),
  //       child: AppBar(
  //         backgroundColor: AppColors.color101010,
  //         toolbarHeight: 100.h,
  //         elevation: 0,
  //
  //         title: Row(
  //           children: [
  //             GestureDetector(
  //               onTap: onMenuPressed,
  //               child: _buildSvgPicture(
  //                 iconPath: AppAssets.menuIcon,
  //                 iconHeight: 18.h,
  //                 iconWidth: 18.w,
  //               ),
  //             ),
  //             SizedBox(width: 10.w),
  //             HexagonAvatar(
  //               imagePath: AppAssets.profileImage,
  //               width: 55.w,
  //               height: 65.h,
  //             ),
  //             Expanded(
  //               child: Center(
  //                 child: Text(
  //                   _getAppBarTitle(currentBottomIndex),
  //                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //                     color: AppColors.white,
  //                     fontSize: 25.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             if (currentBottomIndex != 1) // Hide icons on message screen
  //               Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   _buildSvgPicture(
  //                     iconPath: AppAssets.bellIcon,
  //                     iconHeight: 24.h,
  //                     iconWidth: 24.w,
  //                   ),
  //                   SizedBox(width: 10.w),
  //                   _buildSvgPicture(
  //                     iconPath: AppAssets.filterIcon,
  //                     iconHeight: 24.h,
  //                     iconWidth: 24.w,
  //                   ),
  //                 ],
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
}
