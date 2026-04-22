import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/bottom_nav/controller/bottom_nav_controller.dart';
import '../constants/app_colors.dart';
import '../navigation/routes.dart';

class ProfileViewPromptService {
  static const Set<int> promptMilestones = {10, 33};
  static int _sessionProfileViewCount = 0;

  static Future<void> recordVisitAndMaybePrompt() async {
    _sessionProfileViewCount++;
    final nextCount = _sessionProfileViewCount;

    if (!promptMilestones.contains(nextCount)) {
      return;
    }

    if (Get.isDialogOpen ?? false) {
      return;
    }

    await Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.color101010,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.colorFF8600.withValues(alpha: 0.35),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 28,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorFF8600.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.colorFF8600.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.colorFF8600,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Upgrade Prompt',
                        style: TextStyle(
                          color: AppColors.colorFF8600,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Keep Browsing More Profiles',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upgrade your membership to unlock more profile views and premium options without interruptions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.colorC2C2C2,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back<void>(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.color2E2E2E),
                          foregroundColor: AppColors.colorC2C2C2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Not Now',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back<void>();

                          if (Get.currentRoute == Routes.hiveProfileScreen ||
                              Get.currentRoute == Routes.b2bScreen) {
                            Get.back<void>();
                          }

                          if (Get.isRegistered<BottomNavController>()) {
                            Get.find<BottomNavController>().onItemTapped(4);
                          } else {
                            Get.toNamed(
                              Routes.pricingPlansScreen,
                              arguments: {'showBackButton': true},
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorFF8600,
                          foregroundColor: AppColors.colorFFFFFF,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Upgrade',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
