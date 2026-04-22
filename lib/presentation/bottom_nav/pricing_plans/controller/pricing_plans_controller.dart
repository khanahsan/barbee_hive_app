import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:intl/intl.dart';

import '../../../../data/api/subscription/subscription_api.dart';
import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';
import '../../../../infrastructure/services/current_user_subscription_controller.dart';
// import '../../../../infrastructure/services/stripe_service.dart';
import '../model/pricing_plans_model.dart';

class PricingPlansController extends GetxController {
  final CurrentUserSubscriptionController currentUserSubscriptionController =
      Get.find<CurrentUserSubscriptionController>();

  /// Observable list of subscription plans
  var plans = <SubscriptionPlan>[].obs;

  RxInt activePlanId = 0.obs;

  // In-app purchase
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchasesSubscription;
  bool _isRestoredProcessed = false;
  final Set<String> _processedPurchaseKeys = <String>{};
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

  Future<void> handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      final purchaseStatus = purchaseDetails.status;
      final String eventProductId = _extractPurchaseProductId(purchaseDetails);
      log('Purchase Status: $purchaseStatus');
      log('PURCHASE DETAILS: $purchaseDetails');
      log('EVENT PRODUCT ID: $eventProductId');

      if (_pendingProductId != null && eventProductId != _pendingProductId) {
        log(
          'Ignoring purchase update for product $eventProductId while pending product is $_pendingProductId',
        );

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
        continue;
      }

      if (purchaseStatus == PurchaseStatus.restored && !_isRestoredProcessed) {
        final String purchaseKey = _buildPurchaseKey(purchaseDetails);
        if (_processedPurchaseKeys.add(purchaseKey)) {
          await onPurchaseSuccess(purchaseDetails);
        } else {
          log('Skipping duplicate restored purchase: $purchaseKey');
        }
        _isRestoredProcessed = true;
      }

      if (purchaseStatus == PurchaseStatus.purchased) {
        final String purchaseKey = _buildPurchaseKey(purchaseDetails);
        if (_processedPurchaseKeys.add(purchaseKey)) {
          await onPurchaseSuccess(purchaseDetails);
        } else {
          log('Skipping duplicate purchased event: $purchaseKey');
        }
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
        await _iap.completePurchase(purchaseDetails);
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

    String platformReceipt = '';
    String platform = '';
    String transactionId = purchaseDetails.purchaseID ?? '';
    String? purchasedAt;
    String? expiresAt;
    Map<String, dynamic> localDataMap = const {};

    if (Platform.isAndroid) {
      final androidPurchase = purchaseDetails as GooglePlayPurchaseDetails;
      platformReceipt = androidPurchase.billingClientPurchase.purchaseToken;
      platform = 'android';
      transactionId = androidPurchase.billingClientPurchase.orderId;
      purchasedAt = _formatPurchaseDate(purchaseDetails.transactionDate);
      localDataMap = _decodeLocalVerificationData(
        purchaseDetails.verificationData.localVerificationData,
      );
    } else if (Platform.isIOS) {
      platformReceipt = purchaseDetails.verificationData.serverVerificationData;
      platform = 'ios';
      localDataMap = _decodeLocalVerificationData(
        purchaseDetails.verificationData.localVerificationData,
      );
      transactionId =
          (localDataMap['transactionId'] ?? purchaseDetails.purchaseID ?? '')
              .toString();
      purchasedAt =
          _parseAndFormatDate(localDataMap['purchaseDate']) ??
          _formatPurchaseDate(purchaseDetails.transactionDate);
      expiresAt = _parseAndFormatDate(localDataMap['expiresDate']);

      if (localDataMap.isNotEmpty) {
        log('transactionId: ${localDataMap['transactionId']}');
        log('originalTransactionId: ${localDataMap['originalTransactionId']}');
        log('webOrderLineItemId: ${localDataMap['webOrderLineItemId']}');
        log('bundleId: ${localDataMap['bundleId']}');
        log('productId: ${localDataMap['productId']}');
        log(
          'subscriptionGroupIdentifier: ${localDataMap['subscriptionGroupIdentifier']}',
        );
        log('purchaseDate: ${localDataMap['purchaseDate']}');
        log('originalPurchaseDate: ${localDataMap['originalPurchaseDate']}');
        log('expiresDate: ${localDataMap['expiresDate']}');
        log('quantity: ${localDataMap['quantity']}');
        log('type: ${localDataMap['type']}');
        log(
          'deviceVerificationNonce: ${localDataMap['deviceVerificationNonce']}',
        );
        log('inAppOwnershipType: ${localDataMap['inAppOwnershipType']}');
        log('deviceVerification: ${localDataMap['deviceVerification']}');
        log('signedDate: ${localDataMap['signedDate']}');
        log('environment: ${localDataMap['environment']}');
        log('transactionReason: ${localDataMap['transactionReason']}');
        log('storefront: ${localDataMap['storefront']}');
        log('storefrontId: ${localDataMap['storefrontId']}');
        log('price: ${localDataMap['price']}');
        log('currency: ${localDataMap['currency']}');
        log('appTransactionId: ${localDataMap['appTransactionId']}');
      }
    }

    final String? transactionReason =
        localDataMap['transactionReason']?.toString();
    if (Platform.isIOS && transactionReason == 'RENEWAL') {
      log('Skipping renewal transaction: $transactionId');
      return;
    }

    final SubscriptionPlan? plan = _getPendingPlan();
    purchasedAt ??=
        _formatPurchaseDate(purchaseDetails.transactionDate) ??
        _formatDateTime(DateTime.now().toUtc());
    expiresAt ??= _buildFallbackExpiryDate(plan, purchasedAt);
    final String resolvedPurchasedAt = purchasedAt;
    final String resolvedExpiresAt = expiresAt;

    log('purchaseDetails.purchaseID ${purchaseDetails.purchaseID}');
    log(
      'purchaseDetails.verificationData.serverVerificationData ${purchaseDetails.verificationData.serverVerificationData}',
    );
    log('PLATFORM: $platform');
    log('TRANSACTION ID: $transactionId');
    log('PURCHASED AT: $resolvedPurchasedAt');
    log('EXPIRES AT: $resolvedExpiresAt');
    log('PLATFORM RECEIPT: $platformReceipt');

    await storeInAppPurchase(
      planId: _pendingPlanId!,
      productId: _pendingProductId ?? purchaseDetails.productID,
      platformReceipt: platformReceipt,
      platform: platform,
      transactionId: transactionId,
      purchasedAt: resolvedPurchasedAt,
      expiresAt: resolvedExpiresAt,
    );
  }

  /// Method to initiate purchase for a specific subscription plan
  Future<void> purchaseSubscription({required SubscriptionPlan plan}) async {
    if (isApplying.value) return;
    isApplying.value = true;

    try {
      if (plan.price == 0) {
        // await finalizeSubscription(planId: plan.id);
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
      _processedPurchaseKeys.clear();
      _isRestoredProcessed = false;

      final Set<String> productIds = {productId};
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        productIds,
      );

      if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Product not found in store.',
          isSuccess: false,
        );
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      startListeningToPurchases();
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
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
        await currentUserSubscriptionController.refresh();

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

  Future<void> storeInAppPurchase({
    required int planId,
    required String productId,
    required String platformReceipt,
    required String platform,
    required String transactionId,
    required String purchasedAt,
    required String expiresAt,
  }) async {
    try {
      log('PLATFORM RECEIPT $platformReceipt');
      final response = await SubscriptionApi.storeInAppPurchase(
        productId: productId,
        planId: planId,
        platformReceipt: platformReceipt,
        platform: platform,
        status: 'completed',
        transactionId: transactionId,
        expiresAt: expiresAt,
        purchasedAt: purchasedAt,
      );

      if (response.status) {
        await fetchSubscriptionPlans();
        await currentUserSubscriptionController.refresh();

        Get.close(1);

        Utilities.showSnackBar(
          title: 'Success',
          message: response.message,
          isSuccess: true,
        );
      } else {
        Utilities.showSnackBar(
          title: 'Error',
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to store in-app purchase: $e',
        isSuccess: false,
      );
    }
  }

  SubscriptionPlan? _getPendingPlan() {
    if (_pendingPlanId == null) return null;

    try {
      return plans.firstWhere((plan) => plan.id == _pendingPlanId);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _decodeLocalVerificationData(String? localData) {
    if (localData == null || localData.isEmpty) {
      return const {};
    }

    try {
      final decoded = jsonDecode(localData);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      log('Local verification data is not JSON decodable.');
    }

    return const {};
  }

  String? _formatPurchaseDate(String? transactionDate) {
    if (transactionDate == null || transactionDate.isEmpty) return null;

    final int? milliseconds = int.tryParse(transactionDate);
    if (milliseconds == null) return null;

    return _formatDateTime(
      DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true),
    );
  }

  String? _parseAndFormatDate(dynamic rawValue) {
    if (rawValue == null) return null;

    final String value = rawValue.toString().trim();
    if (value.isEmpty) return null;

    final int? milliseconds = int.tryParse(value);
    if (milliseconds != null) {
      final int normalizedMilliseconds =
          value.length <= 10 ? milliseconds * 1000 : milliseconds;
      return _formatDateTime(
        DateTime.fromMillisecondsSinceEpoch(
          normalizedMilliseconds,
          isUtc: true,
        ),
      );
    }

    try {
      return _formatDateTime(DateTime.parse(value).toUtc());
    } catch (_) {
      return null;
    }
  }

  String _buildFallbackExpiryDate(SubscriptionPlan? plan, String purchasedAt) {
    try {
      final DateTime baseDate =
          DateTime.parse(purchasedAt.replaceFirst(' ', 'T')).toUtc();
      return _formatDateTime(
        baseDate.add(Duration(days: plan?.durationDays ?? 30)),
      );
    } catch (_) {
      return purchasedAt;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  String _buildPurchaseKey(PurchaseDetails purchaseDetails) {
    final Map<String, dynamic> localDataMap = _decodeLocalVerificationData(
      purchaseDetails.verificationData.localVerificationData,
    );
    final String productId = _extractPurchaseProductId(
      purchaseDetails,
      localDataMap: localDataMap,
    );
    final String purchaseId =
        (localDataMap['transactionId'] ??
                purchaseDetails.purchaseID ??
                'no_purchase_id')
            .toString();
    final String transactionDate =
        (localDataMap['purchaseDate'] ??
                purchaseDetails.transactionDate ??
                'no_transaction_date')
            .toString();
    return '$productId|$purchaseId|$transactionDate';
  }

  String _extractPurchaseProductId(
    PurchaseDetails purchaseDetails, {
    Map<String, dynamic>? localDataMap,
  }) {
    final Map<String, dynamic> resolvedLocalDataMap =
        localDataMap ??
        _decodeLocalVerificationData(
          purchaseDetails.verificationData.localVerificationData,
        );

    return (resolvedLocalDataMap['productId'] ?? purchaseDetails.productID)
        .toString();
  }
}
