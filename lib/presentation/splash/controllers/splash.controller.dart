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


  void increment() => count.value++;
}
