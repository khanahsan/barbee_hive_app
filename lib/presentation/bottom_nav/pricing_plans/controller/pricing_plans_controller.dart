import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:get/get.dart';

import '../../../../data/api/subscription/subscription_api.dart';
import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';
import '../../../../infrastructure/services/stripe_service.dart';
import '../model/pricing_plans_model.dart';

class PricingPlansController extends GetxController {
  /// Observable list of subscription plans
  var plans = <SubscriptionPlan>[].obs;

  RxInt activePlanId = 0.obs;

  // Future<void> loadActivePlan() async {
  //   final savedId = SharedPreferenceHelper.getInt(
  //     SharedPrefKeys.activatedSubscriptionId,
  //   );
  //
  //   log("SAVED ID: $savedId");
  //
  //   activePlanId.value = savedId ?? 0;
  // }

  /// Loading state
  RxBool isLoading = true.obs;
  RxBool isEmployer = false.obs;

  /// Error message
  RxString errorMessage = ''.obs;

  RxBool isApplying = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.wait([loadRoleAsync(), fetchSubscriptionPlans()]);
  }

  /// Fetch Role Value From Local Storage
  Future<void> loadRoleAsync() async {
    final role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    isEmployer.value = role == 2;
  }

  /// Fetch subscription plans from API
  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoading.value = true;
      final response = await SubscriptionApi.getSubscriptionPlans();

      if (response.status) {
        plans.value = response.data.plans;

        // Update active plan from current_membership
        final membership = response.data.currentMembership;
        if (membership != null && membership.status == 'active') {
          activePlanId.value = membership.planId;
        }

        log("ACTIVE PLAN ID: ${activePlanId.value}");
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Apply for subscription
  Future<void> applySubscription({required int planId}) async {
    try {
      isApplying.value = true;

      // 1️⃣ Call backend to create subscription / payment intent
      final response = await SubscriptionApi.applySubscription(planID: planId);

      if (!(response.status && response.data != null)) {
        errorMessage.value = response.message;
        Utilities.showSnackBar(
          title: 'Error',
          message: response.message,
          isSuccess: false,
        );
        return;
      }

      final data = response.data!;
      String? paymentIntentID;

      if (data.paymentRequired) {
        // 🔹 Paid plan → Stripe Payment Sheet
        final clientSecret = data.clientSecret;

        try {
          // Initialize PaymentSheet

          if (Platform.isIOS) {
            await StripeService.instance.initPaymentSheetIOS(
              clientSecret: clientSecret ?? '',
              merchantDisplayName: 'Barbee Hive',
            );
          }

          if (Platform.isAndroid) {
            await StripeService.instance.initPaymentSheetAndroid(
              clientSecret: clientSecret ?? '',
            );
          }

          // Present PaymentSheet
          bool paymentSuccess =
              await StripeService.instance.presentPaymentSheet();

          if (!paymentSuccess) return;

          paymentIntentID = data.paymentIntentId;

          /*    Utilities.showSnackBar(
            title: 'Success',
            message: 'Payment completed successfully',
            isSuccess: true,
          );*/
        } catch (e) {
          Utilities.showSnackBar(
            title: 'Error',
            message: e.toString(),
            isSuccess: false,
          );
          return; // Exit early if payment failed
        }
      } else {
        // Free plan activated
        Utilities.showSnackBar(
          title: 'Success',
          message: 'Free plan activated successfully!',
          isSuccess: true,
        );
      }

      // 2️⃣ Finalize subscription
      await finalizeSubscription(
        planId: planId,
        paymentIntentID: paymentIntentID,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Utilities.showSnackBar(
        title: 'Error',
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      isApplying.value = false;
    }
  }

  /// Finalize Subscription
  Future<void> finalizeSubscription({
    required int planId,
    String? paymentIntentID,
  }) async {
    try {
      final finalizeResponse = await SubscriptionApi.finalizeSubscription(
        planID: planId,
        paymentIntentID: paymentIntentID,
      );

      if (finalizeResponse.status) {
        final membershipId = finalizeResponse.data?.planId;

        if (membershipId != null) {
          await SharedPreferenceHelper.saveInt(
            SharedPrefKeys.activatedSubscriptionId,
            membershipId,
          );

          activePlanId.value = membershipId; // ← update instantly
        }

        // Now refresh plans
        await fetchSubscriptionPlans();

        Get.close(1);

        Utilities.showSnackBar(
          title: 'Success',
          message: finalizeResponse.message,
          isSuccess: true,
        );
      } else {
        Utilities.showSnackBar(
          title: 'Error',
          message: finalizeResponse.message,
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to finalize subscription: $e',
        isSuccess: false,
      );
    }
  }
}
