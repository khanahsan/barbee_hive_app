import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';
import '../constants/app_font_size.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.btnTitle,
    required this.onPressed,
    this.isLoading = false,
    this.btnBackgroundColor = AppColors.primary,
    this.btnTxtColor = AppColors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.width = double.infinity,
    this.height = 50, // Add height parameter
    this.titlePadding = EdgeInsets.zero,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.iconPath,
    this.borderRadius = 10, // Add borderRadius parameter
  });

  final String btnTitle;
  final double borderWidth;
  final Color borderColor;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final Color btnTxtColor;
  final Color btnBackgroundColor;
  final double? fontSize, width, height, borderRadius; // Add height and borderRadius
  final bool isLoading;
  final EdgeInsets titlePadding;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(width!.w, height!.h),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius!.r), // Use custom borderRadius
        ),
        shadowColor: const Color(0xff000000).withOpacity(0.25),
        elevation: 4,
      ),
      child: Container(
        alignment: Alignment.center,
        padding: titlePadding,
        width: width!.w,
        height: height!.h,
        decoration: BoxDecoration(
          color: btnBackgroundColor,
          border: Border.all(width: borderWidth, color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius!.r), // Use custom borderRadius
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.25),
              blurRadius: 4.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? SizedBox(
          width: 25.w,
          height: 25.h,
          child: const CircularProgressIndicator.adaptive(
            backgroundColor: AppColors.white,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            strokeWidth: 5.0,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              Image.asset(
                iconPath!,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(width: 8.w),
            ],
            CustomText(
              title: btnTitle,
              color: btnTxtColor,
              fontSize: AppFontSize.small,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }
}