class ApplySubscriptionResponse {
  final bool status;
  final String message;
  final SubscriptionData? data;

  ApplySubscriptionResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApplySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return ApplySubscriptionResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SubscriptionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SubscriptionData {
  final int planId;
  final String planName;
  final int? membershipId;
  final String? status;
  final bool paymentRequired;
  final double? amount;
  final String? currency;
  final String? clientSecret;
  final String? paymentIntentId;

  SubscriptionData({
    required this.planId,
    required this.planName,
    this.membershipId,
    this.status,
    required this.paymentRequired,
    this.amount,
    this.currency,
    this.clientSecret,
    this.paymentIntentId,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      planId: json['plan_id'] ?? 0,
      planName: json['plan_name'] ?? '',
      membershipId: json['membership_id'],
      status: json['status'],
      paymentRequired: json['payment_required'] ?? false,
      amount: (json['amount'] != null)
          ? double.tryParse(json['amount'].toString())
          : null,
      currency: json['currency'],
      clientSecret: json['client_secret'],
      paymentIntentId: json['payment_intent_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'plan_name': planName,
      'membership_id': membershipId,
      'status': status,
      'payment_required': paymentRequired,
      'amount': amount,
      'currency': currency,
      'client_secret': clientSecret,
      'payment_intent_id': paymentIntentId,
    };
  }
}
