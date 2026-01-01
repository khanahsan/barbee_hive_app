import 'dart:io';

import 'package:barbee_hive_app/push_notifications/push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // To load environment variables
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'data/api/api_service.dart';
import 'data/firebase/firebase_notificaton_service.dart';
import 'firebase_options.dart';
import 'infrastructure/helpers/shared_preference_helper.dart';
import 'infrastructure/navigation/bindings/initial_binding.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart'; // Adjust based on your bindings

// Uncomment the following lines if you want to include test devices for ads
// List<String> testDeviceIds = ["7FB2D56DF5DB4A39C7C2D399D8D0E758"];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (if you're using .env file for sensitive keys)
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  /// ------------- STRIPE INITIALIZATION (APPLE PAY FIX) ---------------
  if(Platform.isIOS){

    // Set Apple Pay merchant ID
    Stripe.merchantIdentifier = 'merchant.app.barbeeinc';

    // Required for redirect handling
    Stripe.urlScheme = 'stripe';

    // Apply Stripe settings
    await Stripe.instance.applySettings();
  }

  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.initialize();

  // Initialize Firebase Messaging
//  await NotificationService().initNotification();

  // Request Notification permissions (iOS)
  await FirebaseMessaging.instance.requestPermission();

  // Get the FCM token (ensure it's available after permissions)
  // String? token = await FirebaseMessaging.instance.getToken();
  // if (token != null) {
  //   print("FCM Token: $token");
  // } else {
  //   print("Failed to get FCM Token.");
  // }

  // Initialize other services
  await ApiService.initToken();
  await SharedPreferenceHelper.init();

  // Optionally, handle test device configuration for ads
  // RequestConfiguration configuration = RequestConfiguration(
  //   testDeviceIds: testDeviceIds,
  // );
  // MobileAds.instance.updateRequestConfiguration(configuration);

  // Load the initial route (for navigation)
  var initialRoute = await Routes.initialRoute;

  // Run the app
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main(initialRoute)));

  // Set the device orientation (optional)
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInitializer(
      baseHeight: 956,
      baseWidth: 440,
      child: GetMaterialApp(
        builder: (context, child) {
          return SafeArea(
            top: false,
            right: false,
            left: false,
            bottom: true,
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 16.0),
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontSize: 16.0),
          ),
        ),
        initialRoute: initialRoute,
        getPages: Nav.routes,
        initialBinding: InitialBindings(),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
