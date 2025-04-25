import 'package:barbee_hive_app/nav.dart';
import 'package:barbee_hive_app/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../infrastructure/constants/app_colors.dart';
import '../infrastructure/constants/app_images.dart';
import '../infrastructure/widgets/hexagon_clipper.dart'; // Check spelling: "cutom" -> maybe should be "custom"?

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    DashboardScreen(),
    Center(
      child: Text("Location Screen", style: TextStyle(color: Colors.white)),
    ),
    Center(child: Text("Menu Screen", style: TextStyle(color: Colors.white))),
    Center(child: Text("Bakery Screen", style: TextStyle(color: Colors.white))),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSection(
        context: context,
        onMenuPressed: widget.onMenuPressed,
      ),

      // appBar: AppBar(
      //   backgroundColor: AppColors.black,
      //   title: const Text("Right Drawer Demo"),
      //   leading: IconButton(
      //     icon: const Icon(Icons.menu),
      //     onPressed: widget.onMenuPressed,
      //   ),
      // ),
      backgroundColor: Colors.black,
      body: screens[selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

  PreferredSize appBarSection({
    required BuildContext context,
    required VoidCallback onMenuPressed,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onMenuPressed,
                    child: _buildSvgPicture(
                      iconPath: AppAssets.menuIcon,
                      iconHeight: 18.h,
                      iconWidth: 18.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  HexagonAvatar(
                    imagePath: AppAssets.profileImage,
                    width: 55.w,
                    height: 65.h,
                  ),
                ],
              ),
              // SizedBox(width: 40.w),
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSvgPicture(
                    iconPath: AppAssets.bellIcon,
                    iconHeight: 24.h,
                    iconWidth: 24.w,
                  ),
                  SizedBox(width: 10.w),
                  _buildSvgPicture(
                    iconPath: AppAssets.filterIcon,
                    iconHeight: 24.h,
                    iconWidth: 24.w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
