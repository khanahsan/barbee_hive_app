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
    Map<String, dynamic>? notificationData;

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

          final jobId =
          int.tryParse(initialMessage.data['job_id']?.toString() ?? '');

          payloadText.value = 'TYPE $type';

          log("iOS Initial Message Payload: ${initialMessage.data}");

          if (type == 'new_job') {
            indexToPass = 1;

            await goto(indexToPass);
          }
          if (type == 'new_application') {
            indexToPass = 1;

            await goto(indexToPass, jobId: jobId);
          }

          // notificationData = initialMessage.data;

          // await _handleNotificationNavigation(notificationData);
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
          final jobId =
          int.tryParse(payload['job_id']?.toString() ?? '');

          log("Android Notification Payload: $payload");

          if (type == 'new_job') {
            indexToPass = 1;

            await goto(indexToPass);

          }
          if (type == 'new_application') {
            indexToPass = 1;

            await goto(indexToPass, jobId: jobId);
          }

          // notificationData = Map<String, dynamic>.from(payload);
        } catch (e) {
          log("Android payload parse error: $e");
        }
      }

      await goto(indexToPass);
      // await _handleNotificationNavigation(notificationData);
    }
  }


  Future<void> goto(int index, {int? jobId}) async {
    final isRememberMe =
        SharedPreferenceHelper.getString(SharedPrefKeys.authToken) ?? false;

    log(
      "IS REMEMBER ME : $isRememberMe | jobId: $jobId | token: ${await TokenStorage.getToken()}",
    );

    if (TokenStorage.getToken() != null) {
      Get.offAllNamed(
        Routes.CUSTOMDRAWER,
        arguments: {
          'index': index,
          'jobId': jobId, // ✅ nullable
        },
      );
    } else {
      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    }
  }

}
