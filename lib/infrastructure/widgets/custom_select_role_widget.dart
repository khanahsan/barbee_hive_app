import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';
import 'custom_button.dart';

class CustomSelectRoleWidget extends StatelessWidget {
  final String? iconPath;
  final String? btnText;
  final VoidCallback onTap;

  const CustomSelectRoleWidget({
    super.key,
    required this.iconPath,
    required this.onTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 170.w,
        height: 170.h,
        decoration: BoxDecoration(
          color: AppColors.boxBackground,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: AppColors.boxBorder, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath!, width: 70.w, height: 70.h),
              CustomButton(
                btnTitle: btnText!,
                onPressed: () {},
                width: 95.0.w,
                height: 22.0.h,
                borderRadius: 4.0.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
