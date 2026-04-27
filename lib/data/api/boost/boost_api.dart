import 'package:barbee_hive_app/data/model/boost_response.dart';

import '../api_service.dart';
import '../endpoint_constants.dart';

class BoostApi {
  static Future<BoostResponse> activateBoost() async {
    final data = await ApiService.post(
      ApiEndPoints.activateBoost,
      <String, dynamic>{},
      auth: true,
    );

    return BoostResponse.fromJson(data);
  }

  static Future<BoostResponse> finalizeBoost({
    required String paymentIntentId,
  }) async {
    final data = await ApiService.post(
      ApiEndPoints.finalizeBoost,
      {'payment_intent_id': paymentIntentId},
      auth: true,
    );

    return BoostResponse.fromJson(data);
  }
}
