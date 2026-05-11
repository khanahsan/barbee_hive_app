import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._privateConstructor();

  static final StripeService instance = StripeService._privateConstructor();

  /// Initialize Stripe Payment Sheet (iOS).
  ///
  /// Apple Pay is intentionally NOT passed unless [enableApplePay] is true.
  /// Passing `applePay` requires the Apple Pay capability in the Xcode
  /// entitlements file AND a verified Apple Pay certificate uploaded to the
  /// Stripe Dashboard for the configured merchantIdentifier. When either is
  /// missing, the sheet initialises silently but never presents — which is
  /// what we were hitting on iOS.
  Future<void> initPaymentSheetIOS({
    required String clientSecret,
    String? customerId,
    String? ephemeralKey,
    String merchantDisplayName = 'Barbee Hive',
    bool enableApplePay = false,
  }) async {
    try {
      log("CLIENT SECRET (iOS): $clientSecret");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          merchantDisplayName: merchantDisplayName,
          allowsDelayedPaymentMethods: true,
          applePay: enableApplePay
              ? const PaymentSheetApplePay(merchantCountryCode: 'US')
              : null,
          style: ThemeMode.dark,
        ),
      );

      log('✅ Stripe PaymentSheet initialized (iOS)');
    } catch (e) {
      log('Stripe initPaymentSheet error (iOS): $e');
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
      log("CLIENT SECRET (Android): $clientSecret");
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
      log('✅ Stripe PaymentSheet initialized (Android)');
    } catch (e) {
      log('Stripe initPaymentSheet error (Android): $e');
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
