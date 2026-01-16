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
            indexToPass = 2;

            await goto(indexToPass);
          }
          if (type == 'new_application') {
            indexToPass = 2;

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
            indexToPass = 2;

            await goto(indexToPass);

          }
          if (type == 'new_application') {
            indexToPass = 2;

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

  // goto(int index) async {
  //   final isRememberMe =
  //       SharedPreferenceHelper.getBool(SharedPrefKeys.isRememberMe) ?? false;
  //
  //   log(
  //     "IS REMEMBER ME : AND ${isRememberMe} and token ${await TokenStorage.getToken()}",
  //   );
  //
  //   if (isRememberMe && await TokenStorage.getToken() != null) {
  //     Get.offAllNamed(Routes.CUSTOMDRAWER, arguments: {
  //       'index': index,
  //     });
  //   } else {
  //     Get.offAllNamed(Routes.SIGN_IN_VIEW);
  //   }
  // }

  Future<void> goto(int index, {int? jobId}) async {
    final isRememberMe =
        SharedPreferenceHelper.getBool(SharedPrefKeys.isRememberMe) ?? false;

    log(
      "IS REMEMBER ME : $isRememberMe | jobId: $jobId | token: ${await TokenStorage.getToken()}",
    );

    if (isRememberMe && await TokenStorage.getToken() != null) {
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



  void increment() => count.value++;

  Future<void> _handleNotificationNavigation(
    Map<String, dynamic>? data,
  ) async {
    if (data == null || data.isEmpty) return;

    try {
      await NotificationService.clearAppBadge();
    } catch (e) {
      log('Failed to clear badge on splash navigation: $e');
    }

    final type = data['type']?.toString();
    if (type == null) return;

    if (type == 'new_job') {
      try {
        Get.find<BottomNavController>().tabChangeForEmployeeNotifications(2);
      } catch (e) {
        log('Error switching tab for new_job: $e');
      }
      return;
    }

    if (type == 'new_application') {
      try {
        final bottomNavController = Get.find<BottomNavController>();
        bottomNavController.tabChangeForEmployeeNotifications(2);

        // Allow tab change to settle before navigating to applications
        await Future.delayed(const Duration(milliseconds: 200));

        final jobId = int.tryParse(data['job_id']?.toString() ?? '') ?? 0;
        Get.toNamed(Routes.applicationsScreen, arguments: {'jobId': jobId});
      } catch (e) {
        log('Error handling new_application navigation: $e');
      }
      return;
    }
  }
}
