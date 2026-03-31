import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../../../data/api/subscription/subscription_api.dart';
import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';
// import '../../../../infrastructure/services/stripe_service.dart';
import '../model/pricing_plans_model.dart';

class PricingPlansController extends GetxController {
  /// Observable list of subscription plans
  var plans = <SubscriptionPlan>[].obs;

  RxInt activePlanId = 0.obs;

  // In-app purchase
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchasesSubscription;
  bool _isRestoredProcessed = false;
  int? _pendingPlanId;
  String? _pendingProductId;


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
  void onClose() {
    _purchasesSubscription?.cancel();
    super.onClose();
  }

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
  // Future<void> applySubscription({required int planId}) async {
  //   try {
  //     isApplying.value = true;
  //
  //     // 1️⃣ Call backend to create subscription / payment intent
  //     final response = await SubscriptionApi.applySubscription(planID: planId);
  //
  //     if (!(response.status && response.data != null)) {
  //       errorMessage.value = response.message;
  //       Utilities.showSnackBar(
  //         title: 'Error',
  //         message: response.message,
  //         isSuccess: false,
  //       );
  //       return;
  //     }
  //
  //     final data = response.data!;
  //     String? paymentIntentID;
  //
  //     if (data.paymentRequired) {
  //       // 🔹 Paid plan → Stripe Payment Sheet
  //       final clientSecret = data.clientSecret;
  //
  //       try {
  //         // Initialize PaymentSheet
  //
  //         if (Platform.isIOS) {
  //           await StripeService.instance.initPaymentSheetIOS(
  //             clientSecret: clientSecret ?? '',
  //             merchantDisplayName: 'Barbee Hive',
  //           );
  //         }
  //
  //         if (Platform.isAndroid) {
  //           await StripeService.instance.initPaymentSheetAndroid(
  //             clientSecret: clientSecret ?? '',
  //           );
  //         }
  //
  //         // Present PaymentSheet
  //         bool paymentSuccess =
  //             await StripeService.instance.presentPaymentSheet();
  //
  //         if (!paymentSuccess) return;
  //
  //         paymentIntentID = data.paymentIntentId;
  //
  //         /*    Utilities.showSnackBar(
  //           title: 'Success',
  //           message: 'Payment completed successfully',
  //           isSuccess: true,
  //         );*/
  //       } catch (e) {
  //         Utilities.showSnackBar(
  //           title: 'Error',
  //           message: e.toString(),
  //           isSuccess: false,
  //         );
  //         return; // Exit early if payment failed
  //       }
  //     } else {
  //       // Free plan activated
  //       Utilities.showSnackBar(
  //         title: 'Success',
  //         message: 'Free plan activated successfully!',
  //         isSuccess: true,
  //       );
  //     }
  //
  //     // 2️⃣ Finalize subscription
  //     await finalizeSubscription(
  //       planId: planId,
  //       paymentIntentID: paymentIntentID,
  //     );
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     Utilities.showSnackBar(
  //       title: 'Error',
  //       message: e.toString(),
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isApplying.value = false;
  //   }
  // }

  /// Start listening to purchase updates only when the user initiates a purchase
  void startListeningToPurchases() {
    _purchasesSubscription?.cancel();
    _purchasesSubscription = _iap.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        handlePurchaseUpdates(purchaseDetailsList);
      },
      onError: (Object error) {
        Utilities.showSnackBar(
          title: 'Error',
          message: error.toString(),
          isSuccess: false,
        );
      },
    );
  }

  void handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      final purchaseStatus = purchaseDetails.status;
      log('Purchase Status: $purchaseStatus');
      log('PURCHASE DETAILS: $purchaseDetails');

      if (purchaseStatus == PurchaseStatus.restored && !_isRestoredProcessed) {
        onPurchaseSuccess(purchaseDetails);
        _isRestoredProcessed = true;
      }

      if (purchaseStatus == PurchaseStatus.purchased) {
        onPurchaseSuccess(purchaseDetails);
      }

      if (purchaseStatus == PurchaseStatus.error) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'An error occurred during the purchase. Please try again.',
          isSuccess: false,
        );
      }

      if (purchaseStatus == PurchaseStatus.canceled) {
        Utilities.showSnackBar(
          title: 'Purchase Canceled',
          message: 'The purchase was canceled.',
          isSuccess: false,
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _iap.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> onPurchaseSuccess(PurchaseDetails purchaseDetails) async {
    log('ON PURCHASE SUCCESS CALLED');

    if (_pendingPlanId == null) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Missing plan information. Please try again.',
        isSuccess: false,
      );
      return;
    }

    String purchaseToken = '';
    String source = '';

    if (Platform.isAndroid) {
      final androidPurchase = purchaseDetails as GooglePlayPurchaseDetails;
      purchaseToken = androidPurchase.billingClientPurchase.purchaseToken;
      source = 'play_store';
    } else if (Platform.isIOS) {
      final String? purchaseId =
          purchaseDetails.verificationData.serverVerificationData;
      purchaseToken = purchaseId ?? '';
      source = 'app_store';
    }

    final String? localData =
        purchaseDetails.verificationData.localVerificationData;
    if (localData != null && localData.isNotEmpty) {
      final Map<String, dynamic> data = jsonDecode(localData);
      log('transactionId: ${data['transactionId']}');
      log('originalTransactionId: ${data['originalTransactionId']}');
      log('webOrderLineItemId: ${data['webOrderLineItemId']}');
      log('bundleId: ${data['bundleId']}');
      log('productId: ${data['productId']}');
      log('subscriptionGroupIdentifier: ${data['subscriptionGroupIdentifier']}');
      log('purchaseDate: ${data['purchaseDate']}');
      log('originalPurchaseDate: ${data['originalPurchaseDate']}');
      log('expiresDate: ${data['expiresDate']}');
      log('quantity: ${data['quantity']}');
      log('type: ${data['type']}');
      log('deviceVerificationNonce: ${data['deviceVerificationNonce']}');
      log('inAppOwnershipType: ${data['inAppOwnershipType']}');
      log('deviceVerification: ${data['deviceVerification']}');
      log('signedDate: ${data['signedDate']}');
      log('environment: ${data['environment']}');
      log('transactionReason: ${data['transactionReason']}');
      log('storefront: ${data['storefront']}');
      log('storefrontId: ${data['storefrontId']}');
      log('price: ${data['price']}');
      log('currency: ${data['currency']}');
      log('appTransactionId: ${data['appTransactionId']}');
    }

    log('purchaseDetails.purchaseID ${purchaseDetails.purchaseID}');
    log(
      'purchaseDetails.verificationData.serverVerificationData ${purchaseDetails.verificationData.serverVerificationData}',
    );
    log('SOURCE: $source');
    log('PURCHASE TOKEN: $purchaseToken');

    await finalizeSubscription(
      planId: _pendingPlanId!,
      purchaseToken: purchaseToken,
      source: source,
      productId: _pendingProductId,
    );
  }

  /// Method to initiate purchase for a specific subscription plan
  Future<void> purchaseSubscription({required SubscriptionPlan plan}) async {
    if (isApplying.value) return;
    isApplying.value = true;

    try {
      if (plan.price == 0) {
        await finalizeSubscription(planId: plan.id);
        return;
      }

      final bool available = await _iap.isAvailable();
      if (!available) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'In-app purchases are not available on this device.',
          isSuccess: false,
        );
        return;
      }

      final String? productId = plan.productID;
      if (productId == null || productId.isEmpty) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Missing product id for this plan.',
          isSuccess: false,
        );
        return;
      }

      _pendingPlanId = plan.id;
      _pendingProductId = productId;

      final Set<String> productIds = {productId};
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty ||
          response.productDetails.isEmpty) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Product not found in store.',
          isSuccess: false,
        );
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);

      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      startListeningToPurchases();
    } catch (e) {
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
    String? purchaseToken,
    String? source,
    String? productId,
  }) async {
    try {
      final finalizeResponse = await SubscriptionApi.finalizeSubscription(
        planID: planId,
        purchaseToken: purchaseToken,
        source: source,
        productId: productId,
      );

      if (finalizeResponse.status) {
        final membershipId = finalizeResponse.data?.planId;

        if (membershipId != null) {
          await SharedPreferenceHelper.saveInt(
            SharedPrefKeys.activatedSubscriptionId,
            membershipId,
          );

          activePlanId.value = membershipId;
        }

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
