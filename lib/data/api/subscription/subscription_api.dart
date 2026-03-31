import '../../../presentation/bottom_nav/pricing_plans/model/apply_subscription_model.dart';
import '../../../presentation/bottom_nav/pricing_plans/model/pricing_plans_model.dart';
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
}
