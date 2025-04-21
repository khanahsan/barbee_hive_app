import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomTxtBtn extends StatelessWidget {
  const CustomTxtBtn(
      {super.key,
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
      required this.onPressed});

  final String title;
  final Color color;
  final double fontSize, letterSpacing, wordSpacing, height;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final Color decorationColor;
  final TextAlign textAlign;
  final FontStyle fontStyle;
  final String fontFamily;
  final VoidCallback onPressed;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: CustomText(
        title: title,
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: height,
        fontWeight: fontWeight,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
        textAlign: textAlign,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        maxLines: maxLines,
      ),
    );
  }
}
