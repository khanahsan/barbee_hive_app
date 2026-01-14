import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:barbee_hive_app/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../infrastructure/constants/shared_pref_keys.dart';
import '../infrastructure/helpers/shared_preference_helper.dart';
import '../infrastructure/navigation/routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("FIREBASE MESSAGING BACKGROUND HANDLER DATA ${message.data}");
  log(
    "FIREBASE MESSAGING BACKGROUND HANDLER NOTIFICATION ${message.notification?.title}",
  );

  String? notificationType = message.data['notificationType'] as String?;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.instance.setupFlutterNotifications();

  /* if (Platform.isAndroid) {
    await NotificationService.instance.showNotification(message);
  }*/
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //Request Permission
    await _requestPermission();

    //Setup Message Handlers
    await _setupMessageHandlers();

    await setupFlutterNotifications();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Clear any existing badges when app starts
    await _clearBadge();

    // Handle app opened from terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    log("initial message : ${initialMessage?.data}");

    if (initialMessage != null) {
      log("App opened from terminated state via notification");

      await _clearBadge();

      // Handle the notification
      //handleBackgroundMessage(initialMessage);
    }

    //Get FCM Token
    // final token = await _messaging.getToken();
    // log("FCM Token $token");
  }

  // Future<void> _requestPermission() async {
  //   // Request notification permission
  //   PermissionStatus status = await Permission.notification.request();
  //
  //   if (status.isGranted) {
  //     log("Notification permission granted");
  //   } else if (status.isDenied) {
  //     log("Notification permission denied");
  //   } else if (status.isPermanentlyDenied) {
  //     log("Notification permission permanently denied, opening settings...");
  //     openAppSettings(); // Opens settings so the user can enable permission manually
  //   }
  // }

  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      // Request local notifications permissions

      // final iosPlugin =
      //     _localNotifications.resolvePlatformSpecificImplementation<
      //         IOSFlutterLocalNotificationsPlugin>();
      //
      // await iosPlugin?.requestPermissions(
      //   alert: true,
      //   // announcement: true,
      //   badge: true,
      //   // carPlay: true,
      //   // criticalAlert: true,
      //   provisional: false,
      //   sound: true,
      //   critical: true,
      // );
      // // Check permission status
      // final permissionStatus = await iosPlugin?.checkPermissions();
      //
      // log("Notification Permission Status: $permissionStatus");
    }
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    log("Permission status: ${settings.authorizationStatus}");
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    //android setup
    const channel = AndroidNotificationChannel(
      "high_importance_channel_v2",
      "High Importance Notifications",
      importance: Importance.high,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound("notification_sound"),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    var initializationSettingsDarwin = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'notification-action',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              'accepted',
              'Accept',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
            DarwinNotificationAction.plain(
              'declined',
              'Decline',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      // onDidReceiveBackgroundNotificationResponse: (NotificationResponse nor){
      //   //log(nor.data);
      // },
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Clear badge immediately when notification is tapped
        // _clearBadge();

        log(
          "ON DID RECEIVER NOTIFICATION RESPONSE RAW PAYLOAD: ${response.payload}",
        );
        log("SELECTED ACTION ID: ${response.actionId}");

        Map<String, dynamic> messageData = jsonDecode(response.payload!);
        RemoteMessage message = RemoteMessage(data: messageData);

        log("PARSED DATA: ${message.data}");

        String? notificationType = message.data['notificationType'] as String?;

        if (message.data.isNotEmpty && response.actionId != null) {
          log("ON DID RECEIVER NOTIFICATION RESPONSE -------------------");

          if (notificationType == "1") {
            // handleButtonNotificationAction(
            //   response.actionId ?? "",
            //   message,
            //   false,
            // );
          } else {
            handleNotificationAction(
              // response.actionId ?? "",
              message,
              false,
            );
          }
        } else {
          if (notificationType == "1") {
            log("------BBBBBBBBB--------");
            handleBackgroundMessage(message);
          } else {
            handleNotificationAction(
              // response.actionId ?? "",
              message,
              false,
            );
          }
          // _handleBackgroundMessage(message);
          log("Both are null");
          debugPrint("Both are null");
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  // Future foregroundIOSMessage() async {
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }

  Future<void> showNotification(RemoteMessage message) async {
    debugPrint("showNotification ${message.data}");
    log("showNotification ${message.notification?.title}");
    log("showNotification ${message.notification?.body}");
    Map<String, dynamic>? notification = message.data;
    if (notification.isNotEmpty) {
      await _localNotifications.show(
        notification.hashCode,
        notification['title'],
        notification['body'],
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel_v2',
            "High Importance Notification",
            channelDescription:
                "This channel is used for important notifications.",
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            //sound: RawResourceAndroidNotificationSound("notification_sound"),
            icon: '@drawable/ic_notification',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            //sound: "notification_sound.wav",
            // categoryIdentifier: 'notification-action',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> showButtonNotification(RemoteMessage message) async {
    debugPrint("SHOW BUTTON NOTIFICATION DATA ------- ${message.data}");

    var acceptAction = const AndroidNotificationAction(
      'accepted',
      'Accept',
      showsUserInterface: true,
      titleColor: Colors.green,
    );
    var declineAction = const AndroidNotificationAction(
      'declined',
      'Decline',
      showsUserInterface: true,
      titleColor: Colors.red,
    );

    Map<String, dynamic>? notification = message.data;
    if (notification.isNotEmpty) {
      await _localNotifications.show(
        notification.hashCode,
        notification['title'],
        notification['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel_v2',
            "High Importance Notification",
            channelDescription:
                "This channel is used for important notifications.",
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            // sound:
            // const RawResourceAndroidNotificationSound("notification_sound"),
            icon: '@drawable/ic_notification',
            actions: [acceptAction, declineAction],
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: 'notification-action',
            presentBanner: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  static Future<void> handleNotificationAction(
    // String? response,
    RemoteMessage message,
    bool isTerminated,
  ) async {
    // Clear badge count when notification is tapped
    await _clearBadge();
    print(
      "auth token : ${SharedPreferenceHelper.getString(SharedPrefKeys.authToken)}",
    );

    print("message : ${message.data['type']}");
    print("message2 : ${message.data['type'] == 'new_job'}");

    if (message.data['type'] == 'new_job') {
      print("333333");
      var controller = Get.put(BottomNavController());
      controller.tabChangeForEmployeeNotifications(2);
    }

    if (message.data['type'] == 'new_application') {
      print("44444444");
      var controller = Get.put(BottomNavController());
      controller.tabChangeForEmployeeNotifications(2);

      Future.delayed(Duration(seconds: 4), (){
        Get.toNamed(
          Routes.applicationsScreen,
          arguments: {'jobId': message.data['job_id']},
        );
      });
    }

    print("ON NOTIFICATION SELECTED ::: ");

    if (isTerminated) {
      //await deliveryScreenProvider.fetchAllOrders();

      // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => MainScreen(
      //       tabBarIndex: tabBarIndex,
      //       bottomBarIndex: bottomIndex,
      //     ),
      //   ),
      //       (Route route) => false,
      // );
    } else {
      //await deliveryScreenProvider.fetchAllOrders();

      // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => MainScreen(
      //       tabBarIndex: tabBarIndex,
      //       bottomBarIndex: bottomIndex,
      //     ),
      //   ),
      //       (Route route) => false,
      // );
    }
  }

  // RemoteMessage customRemoteMessage = RemoteMessage(
  //   data: {
  //     'title':'Mw title',
  //     'body':'MW BODY',
  //     'employer_name' : 'MW',
  //     'job_title':'Flutter'
  //
  //
  //   }
  // );
  Future<void> _setupMessageHandlers() async {
    //Foreground Message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("MESSAGE DATA ------------ ${message.data}");
      debugPrint(
        "MESSAGE NOTIFICATION ------------ ${message.notification?.title}",
      );
      String? notificationType = message.data['notificationType'] as String?;

      if (Platform.isAndroid) {
        showNotification(message);
        // if (notificationType == "1") {
        //   showButtonNotification(message);
        // } else {
        //   showNotification(message);
        // }
      }
    });

    //Background Message
    //Works on Foreground/Background Tap of System Notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("------CCCCCCCCCCC-------- ${message.data}");
      handleBackgroundMessage(message);
    });

    //Opened App
    // final initialMessage = await _messaging.getInitialMessage();
    // if (initialMessage != null) {
    //   log("------AAAAAAAAA--------");
    //   handleBackgroundMessage(initialMessage);
    // }
  }

  // void handleTerminatedNotification() {
  //   FirebaseMessaging.instance.getInitialMessage().then((message) {
  //     if (message != null) {
  //       Navigator.push(
  //           navigatorKey.currentContext!,
  //           MaterialPageRoute(
  //               builder: (_) =>
  //                   TestingFile(testString: "SSSSSSS", message: message)));
  //     }
  //   });
  // }

  void handleBackgroundMessage(RemoteMessage message) {
    log('handleBackgroundMessage MESSAGE DATA ${message.data}');
    log('handleBackgroundMessage MESSAGE NOTIFICATION TITLE ${message.notification?.title}');
    log('handleBackgroundMessage MESSAGE NOTIFICATION BODY ${message.notification?.body}');
    if (message.data.isNotEmpty) {
      // Clear badge when app is opened from notification
      // _clearBadge();

      //String? notificationType = message.data['notificationType'] as String?;


      handleNotificationAction(message, false);
    }
  }

  /// Helper method to clear app badge count using built-in methods
  static Future<void> _clearBadge() async {
    try {
      final FlutterLocalNotificationsPlugin localNotifications =
          FlutterLocalNotificationsPlugin();

      // Clear all local notifications (removes notification tray items)
      await localNotifications.cancelAll();

      // For iOS: Reset badge using native iOS method through local notifications
      if (Platform.isIOS) {
        const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: true,
          presentSound: false,
          badgeNumber: 0, // Set badge to 0
        );

        // Show a silent notification with badge count 0 to reset the badge
        await localNotifications.show(
          999999, // Use a specific ID for badge clearing
          null,
          null,
          const NotificationDetails(iOS: iOSDetails),
        );

        // Immediately cancel it so it doesn't show in notification center
        await localNotifications.cancel(999999);
      }

      // For Android: Canceling all notifications clears the badge automatically

      log("Badge cleared successfully");
    } catch (e) {
      log("Error clearing badge: $e");
    }
  }

  /// Public method to clear badge (can be called from anywhere in the app)
  static Future<void> clearAppBadge() async {
    await _clearBadge();
  }

  // BUTTON IN NOTIFICATIONS
  //Accept or Decline API Function
  // static Future<void> handleButtonNotificationAction(
  //     // NotificationResponse response,
  //     String response,
  //     RemoteMessage message,
  //     bool isTerminated,
  //     ) async {
  //   // Clear badge count when notification action is tapped
  //   await _clearBadge();
  //
  //   final currentDriverId = await SharedPrefHelper.getInt('driver-id');
  //
  //   final Map<String, dynamic> params = {
  //     "status": response, // accepted or declined
  //     "driver_id": currentDriverId,
  //     "order_id": message.data["orderId"]
  //   };
  //
  //   debugPrint("Params sent to confirmOrder: $params");
  //
  //   try {
  //     final responseData = await ApiService.postApiWithToken(
  //       endpoint: NetworkConstantsUtil.confirmOrder,
  //       body: params,
  //     );
  //
  //     bool isSuccess = responseData['success'];
  //     String message = responseData['message'];
  //
  //     debugPrint('message $message');
  //
  //     EasyLoadingHelper.showToast(message);
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     // final deliveryScreenProvider = Provider.of<OrderProvider>(
  //     //     navigatorKey.currentContext!,
  //     //     listen: false);
  //
  //     if (isSuccess) {
  //       await deliveryScreenProvider.fetchAllOrders();
  //
  //       const bottomIndex = 0;
  //       const tabBarIndex = 1;
  //
  //       if (isTerminated) {
  //         // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
  //         //   MaterialPageRoute(
  //         //       builder: (context) => const MainScreen(
  //         //         tabBarIndex: tabBarIndex,
  //         //         bottomBarIndex: bottomIndex,
  //         //       )),
  //         //       (Route route) => false,
  //         // );
  //       } else {
  //         // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
  //         //   MaterialPageRoute(
  //         //       builder: (context) => const MainScreen(
  //         //         tabBarIndex: tabBarIndex,
  //         //         bottomBarIndex: bottomIndex,
  //         //       )),
  //         //       (Route route) => false,
  //         // );
  //       }
  //     } else {
  //       await deliveryScreenProvider.fetchAllOrders();
  //
  //       const bottomIndex = 0;
  //       const tabBarIndex = 1;
  //
  //       if (isTerminated) {
  //         // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
  //         //   MaterialPageRoute(
  //         //       builder: (context) => const MainScreen(
  //         //         tabBarIndex: tabBarIndex,
  //         //         bottomBarIndex: bottomIndex,
  //         //       )),
  //         //       (Route route) => false,
  //         // );
  //       } else {
  //         // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
  //         //   MaterialPageRoute(
  //         //       builder: (context) => const MainScreen(
  //         //         tabBarIndex: tabBarIndex,
  //         //         bottomBarIndex: bottomIndex,
  //         //       )),
  //         //       (Route route) => false,
  //         // );
  //       }
  //       debugPrint(message);
  //     }
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //   }
  // }
}
