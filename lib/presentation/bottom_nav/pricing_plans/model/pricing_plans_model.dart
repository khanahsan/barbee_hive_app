class PricingPlansModel {
  final bool status;
  final String message;
  final SubscriptionData data;

  PricingPlansModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PricingPlansModel.fromJson(Map<String, dynamic> json) {
    return PricingPlansModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: SubscriptionData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SubscriptionData {
  final List<SubscriptionPlan> plans;
  final String planType;
  final CurrentMembership? currentMembership;

  SubscriptionData({
    required this.plans,
    required this.planType,
    this.currentMembership,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      plans: (json['plans'] as List<dynamic>)
          .map((plan) => SubscriptionPlan.fromJson(plan))
          .toList(),
      planType: json['plan_type'] ?? '',
      currentMembership: json['current_membership'] != null
          ? CurrentMembership.fromJson(json['current_membership'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plans': plans.map((plan) => plan.toJson()).toList(),
      'plan_type': planType,
      'current_membership': currentMembership?.toJson(),
    };
  }
}

class CurrentMembership {
  final int id;
  final int planId;
  final String planName;
  final String startDate;
  final String endDate;
  final String status;
  final String paymentStatus;

  CurrentMembership({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.paymentStatus,
  });

  factory CurrentMembership.fromJson(Map<String, dynamic> json) {
    return CurrentMembership(
      id: json['id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      planName: json['plan_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'plan_name': planName,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'payment_status': paymentStatus,
    };
  }
}

class SubscriptionPlan {
  final int id;
  final String name;
  final String type;
  final double price;
  final int durationDays;
  final String durationDisplay;
  final List<String> features;
  final int profileViews;
  final int freeJobPosts;
  final double additionalJobCost;
  final int boostCount;
  final double boostCost;
  final String? productID;
  final bool isActive;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.durationDays,
    required this.durationDisplay,
    required this.features,
    required this.profileViews,
    required this.freeJobPosts,
    required this.additionalJobCost,
    required this.boostCount,
    required this.boostCost,
    this.productID,
    required this.isActive,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0).toDouble(),
      durationDays: json['duration_days'] ?? 0,
      durationDisplay: json['duration_display'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      profileViews: json['profile_views'] ?? 0,
      freeJobPosts: json['free_job_posts'] ?? 0,
      additionalJobCost: (json['additional_job_cost'] is int)
          ? (json['additional_job_cost'] as int).toDouble()
          : (json['additional_job_cost'] ?? 0.0).toDouble(),
      boostCount: json['boost_count'] ?? 0,
      boostCost: (json['boost_cost'] is int)
          ? (json['boost_cost'] as int).toDouble()
          : (json['boost_cost'] ?? 0.0).toDouble(),
      productID: json['product_id'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'duration_days': durationDays,
      'duration_display': durationDisplay,
      'features': features,
      'profile_views': profileViews,
      'free_job_posts': freeJobPosts,
      'additional_job_cost': additionalJobCost,
      'boost_count': boostCount,
      'boost_cost': boostCost,
      'product_id': productID,
      'is_active': isActive,
    };
  }
}
