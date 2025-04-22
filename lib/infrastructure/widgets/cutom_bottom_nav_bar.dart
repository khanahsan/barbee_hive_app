import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        height: 90.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.black, AppColors.boxBorder, AppColors.black],
            // Example gradient colors
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.beeIcon,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0 ? AppColors.primary : Colors.white,
                  BlendMode.srcIn,
                ),
                height: 30.h,
                width: 30.w,
                fit: BoxFit.cover,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.chatIcon,
                colorFilter: ColorFilter.mode(
                  currentIndex == 1 ? AppColors.primary : Colors.white,
                  BlendMode.srcIn,
                ),
                height: 25.h,
                width: 25.w,
                fit: BoxFit.cover,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.findIcon,
                colorFilter: ColorFilter.mode(
                  currentIndex == 2 ? AppColors.primary : Colors.white,
                  BlendMode.srcIn,
                ),
                height: 25.h,
                width: 25.w,
                fit: BoxFit.cover,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.crownIcon,
                colorFilter: ColorFilter.mode(
                  currentIndex == 3 ? AppColors.primary : Colors.white,
                  BlendMode.srcIn,
                ),
                height: 20.h,
                width: 20.w,
                fit: BoxFit.cover,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
