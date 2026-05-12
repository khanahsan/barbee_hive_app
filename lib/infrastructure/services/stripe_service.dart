import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._privateConstructor();

  static final StripeService instance = StripeService._privateConstructor();

  /// Initialize Stripe Payment Sheet
  Future<void> initPaymentSheetIOS({
    required String clientSecret,
    String? customerId,
    String? ephemeralKey,
    String merchantDisplayName = 'Barbee Hive',
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,

          // Optional but usually passed by backend
          // customerId: customerId,
          // customerEphemeralKeySecret: ephemeralKey,
          merchantDisplayName: merchantDisplayName,

          /// REQUIRED FOR IOS
          // merchantCountryCode: 'US',

          /// REQUIRED FOR IOS APPLE PAY SUPPORT
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),

          style: ThemeMode.dark,
        ),
      );

      log('✅ Stripe PaymentSheet initialized');
    } catch (e) {
      log('Stripe initPaymentSheet error: $e');
      rethrow;
    }
  }

  Future<void> initPaymentSheetAndroid({
    required String clientSecret,
    String? customerId,
    String? ephemeralKey,
    String merchantDisplayName = 'Barbee Hive',
  }) async {
    try {
      log("CLIENT SECRET: $clientSecret");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          merchantDisplayName: merchantDisplayName,
          allowsDelayedPaymentMethods: true,
          style: ThemeMode.light,
        ),
      );
      log('✅ Stripe PaymentSheet initialized');
    } catch (e) {
      log('Stripe initPaymentSheet error: $e');
      rethrow;
    }
  }

  /// Present Payment Sheet
  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      log('✅ Payment completed successfully');
      return true;
    } on StripeException catch (e) {
      log('CURRENT ERROR: ${e.error.localizedMessage}');
      Utilities.showSnackBar(title: 'Error', message: '${e.error.localizedMessage}', isSuccess: false);
      return false;
    } catch (e) {
      log('Stripe unknown error: $e');
      Utilities.showSnackBar(title: 'Error', message: e.toString(), isSuccess: false);
      return false;
    }
  }
}
