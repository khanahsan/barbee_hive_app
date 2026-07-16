import 'dart:async';
import 'dart:io';

import 'package:barbee_hive_app/push_notifications/push_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // To load environment variables
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'data/api/api_service.dart';
import 'data/api/firebase/firebase_service.dart';
import 'firebase_options.dart';
import 'infrastructure/helpers/ads_services.dart';
import 'infrastructure/helpers/shared_preference_helper.dart';
import 'infrastructure/utils/utilities.dart';
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
  if (Platform.isIOS) {
    // Set Apple Pay merchant ID
    Stripe.merchantIdentifier = 'merchant.app.barbeeinc';

    // Required for redirect handling
    Stripe.urlScheme = 'stripe';

    // Apply Stripe settings
    await Stripe.instance.applySettings();
  }

  /// Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint(
    'running environment: ${FirebaseService.isStagingEnvironment ? 'staging' : 'production'}',
  );
  await ApiService.initToken();
  await SharedPreferenceHelper.init();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  // Optionally, handle test device configuration for ads
  // RequestConfiguration configuration = RequestConfiguration(
  //   testDeviceIds: testDeviceIds,
  // );
  // MobileAds.instance.updateRequestConfiguration(configuration);

  // Load the initial route (for navigation)
  final initialRoute = Routes.initialRoute;

  // Run the app
  runApp(Main(initialRoute));

  unawaited(_initializeRuntimeServices());
}

Future<void> _initializeRuntimeServices() async {
  try {
    await NotificationService.instance.initialize();
  } catch (e, stackTrace) {
    debugPrint("NotificationService initialization failed: $e");
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await AdsHelper.initialize();
  } catch (e, stackTrace) {
    debugPrint("AdsHelper initialization failed: $e");
    debugPrintStack(stackTrace: stackTrace);
  }
}

// Future<void> getToken() async {
//   try {
//     // Load the JSON file from assets
//     final jsonKey = await rootBundle.loadString('assets/service-account.json');
//
//     // Parse the JSON content
//     final accountCredentials = ServiceAccountCredentials.fromJson(jsonKey);
//
//     final scopes = [
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];
//
//     final client = await clientViaServiceAccount(
//       accountCredentials,
//       scopes,
//     );
//
//     print('Test Token: ${client.credentials.accessToken.data}');
//
//     SharedPreferenceHelper.saveString(
//       SharedPrefKeys.testToken,
//       client.credentials.accessToken.data ?? '',
//     );
//   } catch (e) {
//     log('TOKEN ERROR: ${e.toString()}');
//   }
// }

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    // getToken();
    return ResponsiveInitializer(
      baseHeight: 956,
      baseWidth: 440,
      child: GetMaterialApp(
        scaffoldMessengerKey: Utilities.messengerKey,
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
