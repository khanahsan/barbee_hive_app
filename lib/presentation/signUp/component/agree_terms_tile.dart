import 'package:barbee_hive_app/infrastructure/constants/app_strings.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/api/endpoint_constants.dart';
import '../../../infrastructure/constants/app_colors.dart';

class AgreeTermsTile extends StatelessWidget {
  const AgreeTermsTile({
    super.key,
    required this.onTap,
    required this.isChecked,
    this.onTermsTap,
    this.onPrivacyTap,
    this.titleText,
  });

  final VoidCallback onTap;
  final RxBool isChecked;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final String? titleText;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10.w,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 23.w,
              height: 23.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey, width: 2.w),
                color:
                    isChecked.value
                        ? AppColors.colorFF8600
                        : Colors.transparent,
              ),
              child:
                  isChecked.value
                      ? Icon(Icons.check, size: 15.sp, color: Colors.white)
                      : null,
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "I agree to the ",
                    style: TextStyle(
                      color: AppColors.colorFFFFFF,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "Terms of Service",
                    style: TextStyle(
                      color: AppColors.colorFF8600,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = onTermsTap ?? _openTerms,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTerms() async {
    final uri = Uri.parse(
      '${ApiEndPoints.basePoint}${AppStrings.termsConditions}',
    );

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Could not launch the Terms of Service',
        isSuccess: false,
      );
    }
  }

}
