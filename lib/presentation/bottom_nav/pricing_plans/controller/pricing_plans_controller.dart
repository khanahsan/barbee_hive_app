import 'package:get/get.dart';

import '../../../../data/api/subscription/subscription_api.dart';
import '../../../../infrastructure/constants/shared_pref_keys.dart';
import '../../../../infrastructure/helpers/shared_preference_helper.dart';
import '../model/pricing_plans_model.dart';

class PricingPlansController extends GetxController {
  /// Observable list of subscription plans
  var plans = <SubscriptionPlan>[].obs;

  /// Loading state
  RxBool isLoading = true.obs;
  RxBool isEmployer = false.obs;

  /// Error message
  var errorMessage = ''.obs;

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
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
