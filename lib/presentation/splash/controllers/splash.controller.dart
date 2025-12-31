import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../push_notifications/push_notifications.dart';
import '../../bottom_nav/controller/bottom_nav_controller.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

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

    _checkNotificationNavigation();

    super.onInit();
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
        goto(2);
      } catch (e) {
        log("Error parsing notification payload: $e");
        debugPrint("Error parsing notification payload: $e");
      }
    } else {
      goto(0);
      log("Login Function is Called");
      debugPrint("Login Function is Called");
    }
  }


  goto(int index){
    final isRememberMe = SharedPreferenceHelper.getBool(SharedPrefKeys.isRememberMe) ?? false;

    print("IS REMEMBER ME : ${isRememberMe}");

    if(isRememberMe){
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
