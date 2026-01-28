import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/dashboard_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/job_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/message_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/pricing_plans_screen.dart';
import 'package:barbee_hive_app/presentation/favourite/favourite_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'controller/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Screen list
    final List<Widget> screens = [
      DashboardScreen(onMenuPressed: onMenuPressed),
      JobScreen(onMenuPressed: onMenuPressed),
      FavouriteScreen(onMenuPressed: onMenuPressed),
      MessageScreen(onMenuPressed: onMenuPressed),
      PricingPlansScreen(onMenuPressed: onMenuPressed, showBackButton: false),
    ];

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.black,

        body: screens[controller.currentBottomIndex.value],

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentBottomIndex.value,
          onTap: (index) => controller.onItemTapped(index),
        ),
      ),
    );
  }

}
