import 'package:flutter/cupertino.dart';

import '../../../presentation/bottom_nav/pricing_plans/model/apply_subscription_model.dart';
import '../../../presentation/bottom_nav/pricing_plans/model/pricing_plans_model.dart';
import '../../../presentation/bottom_nav/pricing_plans/model/store_in_app_purchase_response.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class SubscriptionApi {
  /// GET SUBSCRIPTION PLANS API
  static Future<PricingPlansModel> getSubscriptionPlans() async {
    final data = await ApiService.get(ApiEndPoints.subscriptionPlans);
    return PricingPlansModel.fromJson(data);
  }

  /// APPLY FOR SUBSCRIPTION
  static Future<ApplySubscriptionResponse> applySubscription({
    required int planID,
  }) async {
    final data = await ApiService.post(ApiEndPoints.applySubscription, {
      "plan_id": planID,
    });
    return ApplySubscriptionResponse.fromJson(data);
  }

  /// FINALIZE SUBSCRIPTION
  static Future<ApplySubscriptionResponse> finalizeSubscription({
    required int planID,
    String? paymentIntentID,
    String? purchaseToken,
    String? source,
    String? productId,
  }) async {
    // Build request body
    final requestData = {
      "plan_id": planID,
      if (paymentIntentID != null) "payment_intent_id": paymentIntentID,
      if (purchaseToken != null) "purchase_token": purchaseToken,
      if (source != null) "source": source,
      if (productId != null) "product_id": productId,
    };

    final data = await ApiService.post(
      ApiEndPoints.finalizeSubscription,
      requestData,
    );
    return ApplySubscriptionResponse.fromJson(data);
  }

  /// STORE IN-APP PURCHASE
  static Future<StoreInAppPurchaseResponse> storeInAppPurchase({
    required String productId,
    required int planId,
    required String platformReceipt,
    required String platform,
    required String status,
    required String transactionId,
    required String expiresAt,
    required String purchasedAt,
  }) async {
    final requestData = {
      'product_id': productId,
      'plan_id': planId,
      'platform': platform,
      'status': status,
      'transaction_id': transactionId,
      'expires_at': expiresAt,
      'purchased_at': purchasedAt,
      if (platform == 'ios')
        'receipt_data': platformReceipt
      else
        'purchase_token': platformReceipt,
    };
    debugPrint('requestData $requestData');
    final data = await ApiService.post(
      ApiEndPoints.storeInAppPurchase,
      requestData,
    );
    return StoreInAppPurchaseResponse.fromJson(data);
  }
}
