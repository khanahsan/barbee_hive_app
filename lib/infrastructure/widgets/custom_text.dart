import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';

//usable
class CustomText extends StatelessWidget {
  const CustomText({
    required this.title,
    this.color = AppColors.grey,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.textDecoration = TextDecoration.none,
    this.decorationColor = AppColors.grey,
    this.textAlign = TextAlign.start,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.height = 0.0,
    this.fontStyle = FontStyle.normal,
    this.fontFamily = 'Poppins',
    this.maxLines = 1,
    this.textOverflow,
    super.key,
  });

  final String title;
  final Color color;
  final double fontSize, letterSpacing, wordSpacing, height;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final Color decorationColor;
  final TextAlign textAlign;
  final FontStyle fontStyle;
  final String fontFamily;

  final int maxLines;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {

    // Shared text style
    final TextStyle textStyle = TextStyle(
      fontSize: fontSize.sp,
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight,
      decoration: textDecoration,
      height: height.h,
      fontStyle: fontStyle,
      decorationColor: decorationColor,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );

    return Text(
            title,
            textAlign: textAlign,
            style: textStyle,
            maxLines: maxLines,
            overflow: textOverflow,
          );
  }
}
