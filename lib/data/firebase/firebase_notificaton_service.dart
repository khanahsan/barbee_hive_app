import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize Notification Settings
  Future<void> initNotification() async {
    // Request permissions for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notification plugin
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification clicks when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('App opened from terminated state: ${message.data}');
      }
    });

    // Handle notification clicks when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notification clicked (background): ${message.data}');
    });
  }

  /// Background Message Handler (must be top-level)
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await FirebaseMessaging.instance;
    debugPrint('Handling a background message: ${message.messageId}');
  }

  /// Foreground message handler
  Future<void> _onMessageHandler(RemoteMessage message) async {
    debugPrint('Message received: ${message.notification?.title}');

    if (message.notification != null) {
      await showNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
      );
    }
  }

  /// Display Local Notification
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await _localNotifications.show(0, title, body, notificationDetails);
  }

  /// Handle notification click
  void _onSelectNotification(NotificationResponse response) {
    debugPrint('Notification clicked: ${response.payload}');
  }

  /// Get FCM Token
  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }
}
