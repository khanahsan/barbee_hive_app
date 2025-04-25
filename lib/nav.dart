// import 'package:barbee_hive_app/custom_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:flutter_svg/svg.dart';
//
// import 'package:barbee_hive_app/presentation/dashboard/dashboard_screen.dart';
// import 'package:my_responsive_ui/my_responsive_ui.dart';
// import 'infrastructure/constants/app_colors.dart';
// import 'infrastructure/constants/app_images.dart';
// import 'infrastructure/widgets/cutom_bottom_nav_bar.dart';
// import 'infrastructure/widgets/hexagon_clipper.dart';
//
// class MainDrawer extends StatefulWidget {
//   const MainDrawer({super.key});
//
//   @override
//   _MainDrawerState createState() => _MainDrawerState();
// }
//
// class _MainDrawerState extends State<MainDrawer> {
//   final GlobalKey<CustomDrawerState> customDrawerKey = GlobalKey<CustomDrawerState>();
//
//   final PageController _pageController = PageController();
//   int _selectedPageIndex = 0;
//
//   final List<Widget> screens = [
//     DashboardScreen(),
//     // 0
//     Center(
//       child: Text("Location Screen", style: TextStyle(color: Colors.black)),
//     ),
//     // 1
//     Center(child: Text("Menu Screen", style: TextStyle(color: Colors.white))),
//     // 2
//     Center(child: Text("Bakery Screen", style: TextStyle(color: Colors.white))),
//     // 3
//     Center(
//       child: Text("User List Page", style: TextStyle(color: Colors.white)),
//     ),
//     // 4
//     Center(child: Text("Profile Page", style: TextStyle(color: Colors.white))),
//     // 5
//     Center(child: Text("Help Page", style: TextStyle(color: Colors.white))),
//     // 6
//   ];
//
//   void _changePage(int index) {
//     _pageController.jumpToPage(index);
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }
//
//   void _navigateToPage(int pageIndex) {
//     customDrawerKey.currentState?.toggleDrawer();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _changePage(pageIndex);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return CustomDrawer(
//       key: customDrawerKey,
//       animationCurve: Curves.easeInOut,
//       // animateChildDecoration: true,
//       disabledGestures: false,
//       openRatio: 0.65,
//       openScale: 0.80,
//       animationDuration: const Duration(milliseconds: 300),
//       drawer: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 70,
//               width: 70,
//               decoration: const BoxDecoration(shape: BoxShape.circle),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(45),
//                 child: Image.network(
//                   "",
//                   fit: BoxFit.fill,
//                   errorBuilder:
//                       (context, error, stackTrace) => const Icon(Icons.person),
//                 ),
//               ),
//             ),
//             Text("IBee", style: theme.textTheme.bodyMedium),
//             Text(
//               "UI UX Designer",
//               style: theme.textTheme.titleSmall!.copyWith(
//                 color:
//                     theme.brightness == Brightness.dark
//                         ? AppColors.primary
//                         : Colors.black,
//               ),
//             ),
//             const SizedBox(height: 20),
//             DrawerItem(
//               icon: AppAssets.findIcon,
//               title: 'Home',
//               index: 0,
//               selectedIndex: _selectedPageIndex,
//               onTap: _navigateToPage,
//             ),
//             DrawerItem(
//               icon: AppAssets.beeIcon,
//               title: 'User List',
//               index: 4,
//               selectedIndex: _selectedPageIndex,
//               onTap: _navigateToPage,
//             ),
//             DrawerItem(
//               icon: AppAssets.menuIcon,
//               title: 'Profile',
//               index: 5,
//               selectedIndex: _selectedPageIndex,
//               onTap: _navigateToPage,
//             ),
//             DrawerItem(
//               icon: AppAssets.bellIcon,
//               title: 'Help',
//               index: 6,
//               selectedIndex: _selectedPageIndex,
//               onTap: _navigateToPage,
//             ),
//             ListTile(
//               leading: SvgPicture.asset(
//                 AppAssets.chatIcon,
//                 color: theme.iconTheme.color,
//                 height: 21,
//               ),
//               title: Text('Logout', style: theme.textTheme.titleSmall),
//             ),
//           ],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.black,
//         appBar: appBarSection(context: context),
//
//         body: PageView(
//           controller: _pageController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: screens,
//         ),
//         bottomNavigationBar: CustomBottomNavBar(
//           currentIndex: _selectedPageIndex > 3 ? 0 : _selectedPageIndex,
//           onTap: _changePage,
//         ),
//       ),
//     );
//   }
//
//   PreferredSize appBarSection({required BuildContext context}) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(100.h),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(25.r),
//           bottomRight: Radius.circular(25.r),
//         ),
//         child: AppBar(
//           backgroundColor: AppColors.color101010,
//           toolbarHeight: 100.h,
//           elevation: 0,
//
//           title: Row(
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   GestureDetector(
//                     onTap: () => customDrawerKey.currentState?.toggleDrawer(),
//
//                     child: _buildSvgPicture(
//                       iconPath: AppAssets.menuIcon,
//                       iconHeight: 20.h,
//                       iconWidth: 20.w,
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   HexagonAvatar(
//                     imagePath: AppAssets.profileImage,
//                     width: 60.w,
//                     height: 70.h,
//                   ),
//                 ],
//               ),
//               SizedBox(width: 50.w),
//               Text(
//                 'Dashboard',
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AppColors.white,
//                   fontSize: 30.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Spacer(),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildSvgPicture(
//                     iconPath: AppAssets.bellIcon,
//                     iconHeight: 26.h,
//                     iconWidth: 26.w,
//                   ),
//                   SizedBox(width: 10.w),
//                   _buildSvgPicture(
//                     iconPath: AppAssets.filterIcon,
//                     iconHeight: 26.h,
//                     iconWidth: 26.w,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSvgPicture({
//     required String iconPath,
//     required double iconHeight,
//     required double iconWidth,
//   }) {
//     return SvgPicture.asset(
//       iconPath,
//       fit: BoxFit.cover,
//       height: iconHeight,
//       width: iconWidth,
//     );
//   }
// }
//
// class DrawerItem extends StatelessWidget {
//   final String icon;
//   final String title;
//   final int index;
//   final int selectedIndex;
//   final Function(int) onTap;
//
//   const DrawerItem({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.index,
//     required this.selectedIndex,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: SvgPicture.asset(
//         icon,
//         color:
//             Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.primary
//                 : Colors.black,
//         height: 20,
//       ),
//       title: Text(title, style: Theme.of(context).textTheme.titleSmall),
//       onTap: () => onTap(index),
//     );
//   }
// }

import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/dashboard/dashboard_screen.dart';
import 'package:barbee_hive_app/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'infrastructure/constants/app_colors.dart';
import 'infrastructure/constants/app_images.dart';
import 'infrastructure/widgets/cutom_bottom_nav_bar.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer>
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

    // final List<Widget> screens = [
    //   MainScreen(onMenuPressed: toggleDrawer),
    //   const Center(
    //     child: Text("Location Screen", style: TextStyle(color: Colors.white)),
    //   ),
    //   const Center(
    //     child: Text("Menu Screen", style: TextStyle(color: Colors.white)),
    //   ),
    //   const Center(
    //     child: Text("Bakery Screen", style: TextStyle(color: Colors.white)),
    //   ),
    // ];

    return Scaffold(
      // appBar:
      //     !_isDrawerOpen
      //         ? AppBar(
      //       backgroundColor: AppColors.black,
      //           title: const Text("Right Drawer Demo"),
      //           leading: IconButton(
      //             icon: const Icon(Icons.menu),
      //             onPressed: _toggleDrawer,
      //           ),
      //         )
      //         : null,
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
                          height: 400.h,
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
                          height: 500.h,
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
                          height: 600.h,
                          width: 250.w,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child:  MainScreen(onMenuPressed: toggleDrawer),
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
      // bottomNavigationBar: CustomBottomNavBar(
      //   currentIndex: selectedIndex,
      //   onTap: onItemTapped,
      // ),
      backgroundColor: Colors.transparent,
    );
  }
}
