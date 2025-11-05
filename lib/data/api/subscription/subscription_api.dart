import '../../../presentation/bottom_nav/pricing_plans/model/pricing_plans_model.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class SubscriptionApi {
  /// GET SUBSCRIPTION PLANS API
  static Future<PricingPlansModel> getSubscriptionPlans() async {
    final data = await ApiService.get(ApiEndPoints.subscriptionPlans);
    return PricingPlansModel.fromJson(data);
  }
}
