import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  //TODO: Implement SplashController

  Rx<String> splashLottie = AppAssets.splashLottie.obs;

  late final AnimationController animationController;

  RxString payloadText = 'No Payload'.obs;

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

    // await _readPayload();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When Lottie finishes, navigate based on subscription
        _checkNotificationNavigation();
      }
    });
  }

  Future<void> _readPayload() async {
    if (Platform.isIOS) {
      final RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();

      if (message != null && message.data.isNotEmpty) {
        payloadText.value = jsonEncode(message.data);
        return;
      }
    }

    if (Platform.isAndroid) {
      final plugin = FlutterLocalNotificationsPlugin();
      final details = await plugin.getNotificationAppLaunchDetails();

      if (details?.didNotificationLaunchApp ??
          false && details?.notificationResponse?.payload != null) {
        payloadText.value = details!.notificationResponse!.payload!;
        return;
      }
    }

    payloadText.value = "No notification payload";
  }

  // Future<void> _checkNotificationNavigation() async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   FlutterLocalNotificationsPlugin();
  //
  //   NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //
  //   bool didNotificationLaunchApp =
  //       notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  //
  //   NotificationResponse? notificationResponse =
  //       notificationAppLaunchDetails?.notificationResponse;
  //
  //   if (didNotificationLaunchApp && notificationResponse?.payload != null) {
  //     try {
  //       await goto(2);
  //     } catch (e) {
  //       log("Error parsing notification payload: $e");
  //       debugPrint("Error parsing notification payload: $e");
  //     }
  //   } else {
  //
  //
  //     await goto(0);
  //     log("Login Function is Called");
  //     debugPrint("Login Function is Called");
  //   }
  // }

  Future<void> _checkNotificationNavigation() async {
    int indexToPass = 0;

    /// =========================
    /// ✅ iOS LOGIC
    /// =========================
    if (Platform.isIOS) {
      Future.delayed(Duration.zero, () async {
        log("Running iOS notification check");

        final RemoteMessage? initialMessage =
            await FirebaseMessaging.instance.getInitialMessage();

        if (initialMessage != null && initialMessage.data.isNotEmpty) {
          final type = initialMessage.data['type'];

          payloadText.value = 'TYPE $type';

          log("iOS Initial Message Payload: ${initialMessage.data}");

          if (type == 'new_job') {
            indexToPass = 2;
          }

          await goto(indexToPass);
          return;
        }

        // No notification → normal flow
        await goto(0);
        return;
      });
    }

    /// =========================
    /// ✅ ANDROID LOGIC
    /// =========================
    if (Platform.isAndroid) {
      log("Running Android notification check");

      final plugin = FlutterLocalNotificationsPlugin();
      final details = await plugin.getNotificationAppLaunchDetails();

      if (details?.didNotificationLaunchApp ??
          false && details?.notificationResponse?.payload != null) {
        try {
          final payload = jsonDecode(details!.notificationResponse!.payload!);

          final type = payload['type'];

          log("Android Notification Payload: $payload");

          if (type == 'new_job') {
            indexToPass = 2;
          }
        } catch (e) {
          log("Android payload parse error: $e");
        }
      }

      await goto(indexToPass);
    }
  }

  /*  Future<void> _checkNotificationNavigation() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final NotificationAppLaunchDetails? details =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    final bool launchedFromNotification =
        details?.didNotificationLaunchApp ?? false;

    final NotificationResponse? response = details?.notificationResponse;

    int indexToPass = 0; // default

    if (launchedFromNotification && response?.payload != null) {
      try {
        // 🔹 Decode payload (this is message.data)
        final Map<String, dynamic> payload =
        jsonDecode(response!.payload!);

        final String? type = payload['type'] as String?;
        final String? employerName = payload['employer_name'] as String?;

        log("Notification TYPE: $type");
        log("Employer Name: $employerName");

        // 🔹 Decision logic
        if (type == 'new_job') {
          indexToPass = 2;
        } else {
          indexToPass = 0;
        }
      } catch (e) {
        log("Error parsing notification payload: $e");
        indexToPass = 0;
      }
    }

    await goto(indexToPass);
  }*/

  goto(int index) async {
    final isRememberMe =
        SharedPreferenceHelper.getBool(SharedPrefKeys.isRememberMe) ?? false;

    log(
      "IS REMEMBER ME : AND ${isRememberMe} and token ${await TokenStorage.getToken()}",
    );

    if (isRememberMe && await TokenStorage.getToken() != null) {
      Get.offAllNamed(Routes.CUSTOMDRAWER, arguments: index);
    } else {
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
