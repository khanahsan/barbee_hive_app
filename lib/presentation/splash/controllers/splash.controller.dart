import 'dart:convert';
import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../../data/api/token_storage.dart';
import '../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../push_notifications/push_notifications.dart';
import '../../bottom_nav/controller/bottom_nav_controller.dart';

class SplashController extends GetxController with SingleGetTickerProviderMixin{
  //TODO: Implement SplashController

  Rx<String> splashLottie = AppAssets.splashLottie.obs;

  late final AnimationController animationController;


  final count = 0.obs;
  @override
  Future<void> onInit() async {

    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    //
    //
    // if (initialMessage != null) {
    //   debugPrint("Initial message received: ${initialMessage.data}");
    //
    //
    // } else {
    //
    //
    //
    //
    // }

    // _checkNotificationNavigation();

    super.onInit();

    animationController = AnimationController(vsync: this);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When Lottie finishes, navigate based on subscription
        _checkNotificationNavigation();
      }
    });
  }


  Future<void> _checkNotificationNavigation() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    bool didNotificationLaunchApp =
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    NotificationResponse? notificationResponse =
        notificationAppLaunchDetails?.notificationResponse;

    if (didNotificationLaunchApp && notificationResponse?.payload != null) {
      try {
        await goto(2);
      } catch (e) {
        log("Error parsing notification payload: $e");
        debugPrint("Error parsing notification payload: $e");
      }
    } else {
      await goto(0);
      log("Login Function is Called");
      debugPrint("Login Function is Called");
    }
  }


  goto(int index) async {
    final isRememberMe = SharedPreferenceHelper.getBool(SharedPrefKeys.isRememberMe) ?? false;

    print("IS REMEMBER ME : AND ${isRememberMe} and token ${await TokenStorage.getToken()}");

    if(isRememberMe && await TokenStorage.getToken() != null){
      Get.offAllNamed(Routes.CUSTOMDRAWER, arguments:index);
    }else{
      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    }
  }


    @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
