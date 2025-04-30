

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';


class CustomTextField extends StatelessWidget {
  final String hint;
  final String icon;
  final TextEditingController controller;
  final double height;
  final bool isPassword;
  final bool isObscured;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.height = 55,
    this.isPassword = false,
    this.isObscured = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscured : false,
        style: const TextStyle(color: AppColors.textFieldTextColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textFieldTextColor),
          prefixIcon: Image.asset(
            icon,
            color: AppColors.textFieldTextColor,
            scale: 4.0,
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textFieldTextColor,
            ),
            onPressed: onToggleVisibility,
          )
              : null,
          filled: true,
          fillColor: AppColors.textFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
      ),
    );
  }
}
