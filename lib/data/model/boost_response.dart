class BoostResponse {
  final bool status;
  final String message;
  final BoostData? data;

  BoostResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BoostResponse.fromJson(Map<String, dynamic> json) {
    return BoostResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] is Map<String, dynamic>
              ? BoostData.fromJson(json['data'] as Map<String, dynamic>)
              : null,
    );
  }
}

class BoostData {
  final bool paymentRequired;
  final String? clientSecret;
  final String? paymentIntentId;
  final double? amount;
  final String? currency;
  final String? infoMessage;

  BoostData({
    required this.paymentRequired,
    this.clientSecret,
    this.paymentIntentId,
    this.amount,
    this.currency,
    this.infoMessage,
  });

  factory BoostData.fromJson(Map<String, dynamic> json) {
    return BoostData(
      paymentRequired: json['payment_required'] ?? false,
      clientSecret: json['client_secret'],
      paymentIntentId: json['payment_intent_id'],
      amount:
          json['amount'] != null
              ? double.tryParse(json['amount'].toString())
              : null,
      currency: json['currency'],
      infoMessage: json['message'],
    );
  }
}
