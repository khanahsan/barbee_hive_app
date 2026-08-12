import 'dart:io';

import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/signIn/controller/sign_in_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/constants/app_strings.dart';
import '../../infrastructure/navigation/routes.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    // employer
    //controller.emailController.text = "employer5@gmail.com";
    // //employee
    controller.emailController.text = "jack@gmail.com";
    controller.passwordController.text = "12345678";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.color000000,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15.h,
            children: [
              Image.asset(
                AppAssets.appLogo3,
                width: 220.w,
                height: 150.h,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 5.h),

              // Positioned(
              //   left: 0,
              //   right: 0,
              //   top: 0,
              //   child: Image.asset(AppAssets.backgroundLogo, fit: BoxFit.cover),
              // ),

              // /// LABEL
              // CustomText(
              //   title: 'Buzz in or Signup',
              //   fontSize: 22,
              //   fontWeight: FontWeight.w700,
              //   color: AppColors.colorFF8600,
              // ).paddingSymmetric(horizontal: 20.w),

              /// SUB LABEL
              // CustomText(
              //   textAlign: TextAlign.center,
              //   title: AppStrings.welcomeBackTo,
              //   fontSize: 15,
              //   fontWeight: FontWeight.w400,
              //   color: AppColors.colorFFFFFF,
              // ).paddingSymmetric(horizontal: 20.w),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: AppColors.colorFFFFFF),
                  children: [
                    TextSpan(
                      text: 'Buzz in or Sign-up ',
                      style: TextStyle(
                        color: AppColors.colorFF8600,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '${AppStrings.welcomeBackTo} ',
                      style: TextStyle(
                        color: AppColors.colorFFFFFF,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ).paddingSymmetric(horizontal: 20.w),
              SizedBox(height: 10.h),

              Container(
                // height: 532.h,
                margin: EdgeInsets.only(top: 20.h),
                padding: EdgeInsets.only(top: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.colorFF8600,
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
                    color: AppColors.color000000,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18.0),
                      topLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 10.h,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// EMAIL FIELD
                          AppTextField(
                            focusNode: controller.emailFocusNode,
                            validator: FormValidators.validateEmail,
                            filled: false,
                            useUnderlineBorder: true,
                            enabledBorderColor: AppColors.color4C4C4C,
                            focusedBorderColor: AppColors.colorFF8600,
                            fontColor: AppColors.colorFFFFFF,
                            hintText: 'Email',
                            prefixIcon: SvgPicture.asset(
                              AppAssets.personIcon,
                              fit: BoxFit.scaleDown,
                              color: AppColors.color4C4C4C,
                            ),
                            controller: controller.emailController,
                          ),

                          /// PASSWORD FIELD
                          Obx(
                            () => AppTextField(
                              focusNode: controller.passFocusNode,
                              validator: FormValidators.validatePassword,
                              filled: false,
                              useUnderlineBorder: true,
                              enabledBorderColor: AppColors.color4C4C4C,
                              focusedBorderColor: AppColors.colorFF8600,
                              isObscuredText: controller.isObscured.value,
                              hintText: 'Password',
                              fontColor: AppColors.colorFFFFFF,
                              textInputAction: TextInputAction.done,
                              prefixIcon: SvgPicture.asset(
                                AppAssets.lockIcon,
                                fit: BoxFit.scaleDown,
                              ),
                              suffixIcon: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: controller.togglePasswordVisibility,
                                child: Icon(
                                  controller.isObscured.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 24.sp,
                                  color: AppColors.color4C4C4C,
                                ),
                              ),
                              controller: controller.passwordController,
                            ),
                          ),
                          SizedBox(height: 5.h),

                          /// FORGET PASSWORD OPTION
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Row(
                                  children: [
                                    Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity(
                                        horizontal: -3,
                                        vertical: -4,
                                      ),
                                      value: controller.rememberMe.value,
                                      onChanged:
                                          (v) =>
                                              controller.toggleRememberMe(v!),
                                      activeColor: AppColors.colorFF8600,
                                    ),
                                    CustomText(
                                      title: "Remember me",
                                      color: AppColors.colorFFFFFF,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Get.toNamed(Routes.FORGOT_PASSWORD);
                                },
                                child: CustomText(
                                  title: 'Forgot Password?',
                                  fontSize: 15,
                                  color: AppColors.colorFF8600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),

                          /// SIGN IN OPTION
                          Obx(
                            () => CustomBtn(
                              buttonHeight: 55.h,
                              btnTitle: 'Login',
                              btnBackgroundColor: AppColors.colorFF8600,
                              btnTxtColor: AppColors.colorFFFFFF,
                              onPressed: () {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  controller.login();
                                }
                              },
                              isLoading: controller.isLoading.value,
                            ),
                          ),

                          /// SIGN UP OPTION
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.colorFFFFFF,
                              ),
                              children: [
                                TextSpan(
                                  text: AppStrings.noAccount,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.colorFFFFFF,
                                  ),
                                ),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: AppStrings.signUp,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.colorFF8600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(Routes.selectRole);
                                        },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          /// CONTINUE WITH GOOGLE BUTTON
                          Obx(
                            () => CustomBtn(
                              buttonHeight: 55.h,
                              btnTitle: "Continue with Google",
                              btnBackgroundColor: AppColors.color000000,
                              borderColor: AppColors.colorFFFFFF.withValues(
                                alpha: 0.4,
                              ),
                              btnTxtColor: AppColors.colorFFFFFF,
                              onPressed: controller.signInWithGoogle,
                              isLoading: controller.isGoogleSignInLoading.value,
                              iconPath: AppAssets.googleLogo,
                            ),
                          ),
                          if (Platform.isIOS) ...[
                            SizedBox(height: 15.h),

                            // Continue with Apple button
                            Obx(
                              () => CustomBtn(
                                isLoading:
                                    controller.isAppleSignInLoading.value,
                                buttonHeight: 55.h,
                                btnTitle: "Continue With Apple",
                                btnBackgroundColor: AppColors.color000000,
                                borderColor: AppColors.colorFFFFFF,
                                btnTxtColor: AppColors.colorFFFFFF,
                                iconPath: AppAssets.appleLogo,
                                onPressed: controller.signInWithApple,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
