import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';

class AgreeTermsTile extends StatelessWidget {
  const AgreeTermsTile({
    super.key,
    required this.onTap,
    required this.isChecked,
    this.titleText,
  });

  final VoidCallback onTap;
  final RxBool isChecked;
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
          CustomText(
            title: titleText ?? 'I agree to the Terms of Service',
            color: AppColors.colorFF8600,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
