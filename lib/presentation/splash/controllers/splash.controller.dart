import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

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
          if (type == 'chat_message') {
            // The chat screen sits on top of the drawer, so put the normal
            // first route in place first and then push the chat.
            await goto(0);
            await _openChatFromPayload(initialMessage.data);
          }
          if (type != 'new_job' &&
              type != 'new_application' &&
              type != 'chat_message') {
            // Unknown type: fall back to the normal flow rather than sitting
            // on the splash screen forever.
            await goto(0);
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

      // The payload of the notification that launched the app, when a tap is
      // what started it. On Android the chat push is data-only, so the tray
      // notification is one the app drew itself; this is the only place its tap
      // can be read -- FirebaseMessaging.getInitialMessage() stays null for it.
      Map<String, dynamic>? payload;
      if ((details?.didNotificationLaunchApp ?? false) &&
          (details?.notificationResponse?.payload?.isNotEmpty ?? false)) {
        try {
          payload = Map<String, dynamic>.from(
            jsonDecode(details!.notificationResponse!.payload!) as Map,
          );
          log("Android Notification Payload: $payload");
        } catch (e) {
          log("Android payload parse error: $e");
        }
      }

      final type = payload?['type']?.toString();
      final jobId = int.tryParse(payload?['job_id']?.toString() ?? '');

      if (type == 'new_job' || type == 'new_application') {
        indexToPass = 1;
      }

      // Exactly one goto: it calls Get.offAllNamed, so calling it twice used to
      // rebuild the first route and throw away whatever was pushed on top.
      await goto(
        indexToPass,
        jobId: type == 'new_application' ? jobId : null,
      );

      if (type == 'chat_message') {
        await _openChatFromPayload(payload!);
      }
      // await _handleNotificationNavigation(notificationData);
    }
  }


  /// Opens the chat a tapped chat notification points at.
  ///
  /// Only runs once [goto] has put the first route in place, and only for a
  /// logged-in user -- a tap while logged out lands on sign-in instead.
  Future<void> _openChatFromPayload(Map<String, dynamic> payload) async {
    final senderUid = payload['sender_uid']?.toString() ?? '';
    final token = SharedPreferenceHelper.getString(SharedPrefKeys.authToken);

    if (senderUid.isEmpty) {
      log('chat notification without sender_uid, staying on the dashboard');
      return;
    }
    if (token == null || token.isEmpty) {
      log('chat notification tapped while logged out, staying on sign-in');
      return;
    }

    await NotificationService.openChatWith(senderUid);
  }

  Future<void> goto(int index, {int? jobId}) async {
    final token = SharedPreferenceHelper.getString(SharedPrefKeys.authToken);

    log(
      "jobId: $jobId | token: $token",
    );

    if (token != null && token.isNotEmpty) {
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
