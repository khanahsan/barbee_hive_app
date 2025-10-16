import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> drawerScaleAnimation;
  late Animation<double> dashboardStackScaleAnimation;

  final isDrawerOpen = false.obs;
  final userName = ''.obs;
  final userProfileImage = ''.obs;
  int? role;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    drawerScaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    dashboardStackScaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    _loadUserData();
  }

  void toggleDrawer() {
    if (isDrawerOpen.value) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  Future<void> _loadUserData() async {
    final currentUserName = SharedPreferenceHelper.getString(
      SharedPrefKeys.userName,
    );
    final currentProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );
    role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);

    userName.value = currentUserName ?? "";
    userProfileImage.value = currentProfileImage ?? "";
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
