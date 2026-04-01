class StoreInAppPurchaseResponse {
  final bool status;
  final String message;
  final StoreInAppPurchaseData? data;

  StoreInAppPurchaseResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory StoreInAppPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return StoreInAppPurchaseResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StoreInAppPurchaseData.fromJson(json['data'])
          : null,
    );
  }
}

class StoreInAppPurchaseData {
  final int id;
  final int userId;
  final String productId;
  final String transactionId;
  final String purchaseToken;
  final String platform;
  final String status;
  final bool isActive;
  final String expiresAt;
  final String purchasedAt;
  final String createdAt;
  final String updatedAt;

  StoreInAppPurchaseData({
    required this.id,
    required this.userId,
    required this.productId,
    required this.transactionId,
    required this.purchaseToken,
    required this.platform,
    required this.status,
    required this.isActive,
    required this.expiresAt,
    required this.purchasedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreInAppPurchaseData.fromJson(Map<String, dynamic> json) {
    return StoreInAppPurchaseData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      purchaseToken: json['purchase_token'] ?? '',
      platform: json['platform'] ?? '',
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
      expiresAt: json['expires_at'] ?? '',
      purchasedAt: json['purchased_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
