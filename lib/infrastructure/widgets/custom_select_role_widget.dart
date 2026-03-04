import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';

class CustomSelectRoleWidget extends StatelessWidget {
  final String? iconPath;
  final String? btnText;
  final VoidCallback onTap;
  final bool isSelected;

  const CustomSelectRoleWidget({
    super.key,
    required this.iconPath,
    required this.onTap,
    required this.btnText,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 300.w,
        height: 140.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.color101010 : AppColors.boxBackground,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: isSelected ? AppColors.colorFF8600 : AppColors.boxBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Column(
            spacing: 15.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath!, width: 70.w, height: 70.h),

              /// ROLE TYPE
              Container(
                alignment: Alignment.center,
                width: 100.w,
                height: 25.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: AppColors.colorFF8600,
                ),
                child: CustomText(
                  title: btnText ?? '',
                  color: AppColors.colorFFFFFF,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
