import '../../data/model/user_profile_response.dart' as profile_model;

enum ResumeAdMode { interstitial, banner, none }

class SubscriptionFeatureGuard {
  static const int limitedEmployerDailyRecipientLimit = 20;
  static const int limitedEmployerDailyMessagesPerRecipient = 3;

  final profile_model.Subscription? subscription;
  final int userRole;

  const SubscriptionFeatureGuard({
    required this.subscription,
    required this.userRole,
  });

  bool get isEmployer => userRole == 2;
  bool get isEmployee => userRole == 3;
  bool get isSupportedSubscriptionRole => isEmployer || isEmployee;

  bool get hasActiveSubscription =>
      isSupportedSubscriptionRole &&
      subscription != null &&
      subscription!.isActive &&
      !subscription!.isExpired;

  bool get isFreePlan {
    if (!hasActiveSubscription) return true;

    final normalizedPlanName = subscription!.planName.trim().toLowerCase();
    final normalizedPlanType = subscription!.planType.trim().toLowerCase();
    final amountPaid =
        double.tryParse(subscription!.amountPaid.toString()) ?? 0;

    return normalizedPlanName.contains('free') ||
        normalizedPlanType.contains('free') ||
        amountPaid <= 0.0;
  }

  bool get isEmployerOnFreePlan => isEmployer && isFreePlan;
  bool get isEmployeeOnFreePlan => isEmployee && isFreePlan;

  String get normalizedPlanName =>
      subscription?.planName.trim().toLowerCase() ?? '';

  bool get hasLimitedMessaging => isSupportedSubscriptionRole && isFreePlan;

  // Employer-facing hook for premium-gated employer features.
  bool get canEmployerUsePremiumFeatures => !isEmployerOnFreePlan;

  // Employee-facing hook for future role-3 premium feature gates.
  bool get canEmployeeUsePremiumFeatures => !isEmployeeOnFreePlan;

  bool get shouldShowProfileVisitAds {
    if (isEmployer) {
      return isFreePlan || normalizedPlanName.contains('starter');
    }

    if (isEmployee) {
      return isFreePlan || normalizedPlanName.contains('bronze');
    }

    return false;
  }

  ResumeAdMode get resumeAdMode {
    if (normalizedPlanName.contains('starter')) {
      return ResumeAdMode.interstitial;
    }

    if (normalizedPlanName.contains('essential')) {
      return ResumeAdMode.banner;
    }

    if (normalizedPlanName.contains('business') ||
        normalizedPlanName.contains('premium')) {
      return ResumeAdMode.none;
    }

    return ResumeAdMode.none;
  }

  String get messageQuotaKey {
    final sub = subscription;
    if (sub == null) {
      return 'limited_no_subscription';
    }

    return [
      'limited',
      sub.id,
      sub.planId,
      sub.startDate,
      sub.endDate,
      sub.status,
      sub.isActive,
      sub.isExpired,
    ].join('_');
  }

  bool canSendLimitedMessage({required int sentMessageCount}) {
    if (!isSupportedSubscriptionRole) return true;
    if (!isFreePlan) return true;

    return sentMessageCount < limitedEmployerDailyMessagesPerRecipient;
  }
}
