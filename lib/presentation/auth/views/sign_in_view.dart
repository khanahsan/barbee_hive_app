import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/custom_textfield.dart';
import '../controllers/auth.controller.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Text(
                  'Login to\nBarBee Hive',
                  style: TextStyle(fontSize: 36, color: AppColors.white),
                ).paddingSymmetric(horizontal: 20.w),
                RichText(
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
                ).paddingSymmetric(horizontal: 20.w),

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
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 30.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        spacing: 15.h,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Email Field
                          CustomTextField(
                            validate: FormValidators.validateEmail,
                            fontColor: AppColors.color4C4C4C,
                            filled: true,
                            fillColor: AppColors.color101010,
                            enabledBorderColor: Colors.transparent,
                            hintText: 'Username or Email',
                            prefixIcon: SvgPicture.asset(
                              AppAssets.personIcon,
                              fit: BoxFit.scaleDown,
                              color: AppColors.color4C4C4C,
                            ),
                            // icon: AppAssets.nameLogo,
                            controller: controller.nameController,
                          ),

                          //Password Field
                          Obx(
                            () => CustomTextField(
                              validate: FormValidators.validatePassword,
                              fontColor: AppColors.color4C4C4C,
                              filled: true,
                              fillColor: AppColors.color101010,
                              enabledBorderColor: Colors.transparent,
                              obscureText: controller.isObscured.value,
                              hintText: 'Password',
                              prefixIcon: SvgPicture.asset(
                                AppAssets.lockIcon,
                                fit: BoxFit.scaleDown,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: controller.togglePasswordVisibility,
                                child: Icon(
                                  controller.isObscured.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 25.sp,
                                  color: AppColors.color4C4C4C,
                                ),
                              ),
                              controller: controller.passwordController,
                            ),
                          ),

                          //Forget Password Field
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),

                          //Sign In Button
                          SizedBox(height: 30.h),
                          Obx(
                            () => CustomBtn(
                              buttonHeight: 55.h,
                              btnTitle: 'Sign In',
                              btnBackgroundColor: AppColors.primary,
                              btnTxtColor: AppColors.white,
                              onPressed: () {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  controller.login();
                                }
                              },
                              isLoading:
                                  controller
                                      .isLoading
                                      .value, // Pass reactive isLoading value
                            ),
                          ),

                          //Sign Up Option
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: "Don't have an account?",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 15.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 15.sp,
                                    color: AppColors.primary,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()..onTap = () {},
                                ),
                              ],
                            ),
                          ),
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
