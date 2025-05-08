import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/custom_text_field.dart';
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
            child: Container(
              //height: 200.h,
              child: Image.asset(AppAssets.backgroundLogo, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              spacing: 15.h,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Text(
                    'Login to\nBarBee Hive',
                    style: TextStyle(fontSize: 36, color: AppColors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: AppColors.white),
                      children: [
                        TextSpan(
                          text: 'Welcome back to  ',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Barbee Hive,',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  /*// Open YouTube URL
                              const url = 'https://www.youtube.com';
                              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);*/
                                },
                        ),
                        TextSpan(
                          text:
                              ' Find the Hottest Bars. Join the Coolest Crowds.',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10.h,
                        children: [
                          SizedBox(height: 10.h),
                          CustomTextField(
                            hint: 'Username or Email',
                            icon: AppAssets.nameLogo,
                            controller: controller.nameController,
                          ),
                          /*CustomTextField(
                            isPassword: true,
                            isObscured: true,
                            hint: 'Password',
                            icon: AppAssets.nameLogo,
                            controller: controller.passwordController,
                          ),*/
                          Obx(() => CustomTextField(
                            isPassword: true,
                            isObscured: controller.isObscured.value, // Reactive state
                            hint: 'Password',
                            icon: AppAssets.nameLogo,
                            controller: controller.passwordController,
                            onToggleVisibility: controller.togglePasswordVisibility, // Toggle callback
                          )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 120.h),

                          /*CustomBtn(
                            buttonHeight: 50,
                            btnTitle: 'Sign In',
                            btnBackgroundColor: AppColors.primary,
                            btnTxtColor: Colors.white,
                            onPressed: () => controller.login(),
                          ),*/
                          Obx(
                                () => CustomBtn(
                              buttonHeight: 50,
                              btnTitle: 'Sign In',
                              btnBackgroundColor: AppColors.primary,
                              btnTxtColor: AppColors.white,
                              onPressed: () => controller.login(),
                              isLoading: controller.isLoading.value, // Pass reactive isLoading value
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 12, color: AppColors.white),
                              children: [
                                TextSpan(
                                  text: "Dont't have an account?",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13.0.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
}
