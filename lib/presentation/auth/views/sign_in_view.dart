import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../controllers/auth.controller.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Image.asset(AppAssets.backgroundLogo, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login to BarBee Hive',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  height: 532.h,
                  margin: EdgeInsets.only(top: 20.h),
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.r),
                      topRight: Radius.circular(20.0.r),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.h,
                      children: [
                        SizedBox(height: 10.h),
                        _buildTextField(
                          context,
                          'Username or Email',
                          AppAssets.nameLogo,
                          controller.nameController,
                        ),
                        _buildTextField(
                          context,
                          'Password',
                          AppAssets.passwordLogo,
                          controller.passwordController,
                        ),
                        SizedBox(height: 15.h),

                        CustomBtn(
                          btnTitle: 'Sign In',
                          btnBackgroundColor: AppColors.primary,
                          btnTxtColor: Colors.white,
                          buttonWidth: double.infinity,
                          onPressed: () {},
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String hint,
    String icon,
    TextEditingController textController,
  ) {
    return GetBuilder<AuthController>(
      builder:
          (controller) => TextField(
            controller: textController,
            style: const TextStyle(color: AppColors.textFieldTextColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textFieldTextColor),
              prefixIcon: Image.asset(
                icon,
                color: AppColors.textFieldTextColor,
                scale: 4.0.h,
              ),
              filled: true,
              fillColor: AppColors.textFieldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
    );
  }
}
