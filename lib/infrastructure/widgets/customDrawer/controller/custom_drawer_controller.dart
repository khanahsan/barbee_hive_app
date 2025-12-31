import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../presentation/bottom_nav/controller/bottom_nav_controller.dart';

class CustomDrawerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> drawerScaleAnimation;
  late Animation<double> dashboardStackScaleAnimation;

  final isDrawerOpen = false.obs;
  final isAnimated = false.obs;
  final userName = ''.obs;
  final userProfileImage = ''.obs;
  int? role;
  RxInt currentIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    if(Get.arguments != null){
      currentIndex.value = Get.arguments;
    }

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 600),
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),  // Off-screen right
      end: Offset.zero,  // Center
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: isDrawerOpen.value ? Curves.easeIn : Curves.easeInOut,
      ),
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

    loadUserData();
  }

  Future<void> toggleDrawer() async {
     // Toggle drawer state
    if (isDrawerOpen.value) {
      animationController.duration = const Duration(
        milliseconds: 600,
      ); // faster close
      animationController.reverse();
    } else {
      animationController.duration = const Duration(
        milliseconds: 600,
      ); // normal open
      animationController.forward();
    }

    if(isDrawerOpen.value){
      await Future.delayed(Duration(milliseconds: 600));
    }
    isDrawerOpen.value = !isDrawerOpen.value;
    //isAnimated.value = !isAnimated.value;  // Toggle drawer state
  }

  Future<void> loadUserData() async {
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
    userName.value = '';
    userProfileImage.value = '';
    animationController.dispose();
    super.onClose();
  }
}
