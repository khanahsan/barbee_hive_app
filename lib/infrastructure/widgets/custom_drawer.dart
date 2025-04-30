import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _drawerScaleAnimation;
  late Animation<double> _dashboardStackScaleAnimation;

  bool _isDrawerOpen = false;
  int selectedIndex = 0;

  void toggleDrawer() {
    if (_isDrawerOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _drawerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _dashboardStackScaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isDrawerOpen)
            Container(
              color: AppColors.black,
              child: Stack(
                children: [
                  Positioned(
                    left: 25.w,
                    top: 80.h,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _drawerScaleAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HexagonAvatar(
                              imagePath: AppAssets.profileImage,
                              width: 60.w,
                              height: 70.h,
                              borderColor: AppColors.primary,
                            ),
                            Text(
                              "Welcome",
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "John William",
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                fontSize: 30.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 60.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12.w,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.editIcon,
                                  width: 22.w,
                                  height: 22.h,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Edit Profile",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 20.sp,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12.w,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.jobIcon,
                                  width: 22.w,
                                  height: 22.h,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "My Jobs",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 20.sp,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12.w,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.settingIcon,
                                  width: 22.w,
                                  height: 22.h,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Setting",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 20.sp,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12.w,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.exitIcon,
                                  width: 22.w,
                                  height: 22.h,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Logout",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 20.sp,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            MainScreen(onMenuPressed: toggleDrawer),

          // screens[selectedIndex],

          // Red Container animating in from right
          SlideTransition(
            position: _offsetAnimation,
            child: GestureDetector(
              onTap: toggleDrawer,
              child: Align(
                alignment: Alignment.centerRight,
                child: ScaleTransition(
                  scale: _dashboardStackScaleAnimation,
                  child: Stack(
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
                            color: Colors.blue,
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
                            color: Colors.brown,
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
                            child: MainScreen(onMenuPressed: toggleDrawer),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
