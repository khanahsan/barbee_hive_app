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
    controller.emailController.text = "employee11@gmail.com";
    controller.passwordController.text = "12345678";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.color000000,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Image.asset(AppAssets.backgroundLogo, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 15.h,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15.h,
              children: [
                /// LABEL
                // CustomText(
                //   title: '${AppStrings.loginTo}\n${AppStrings.appName}',
                //   fontSize: 36,
                //   color: AppColors.colorFFFFFF,
                // ).paddingSymmetric(horizontal: 20.w),

                /// SUB LABEL
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.colorFFFFFF,
                    ),
                    children: [
                      TextSpan(
                        text: '${AppStrings.welcomeBackTo} ',
                        style: TextStyle(
                          color: AppColors.colorFFFFFF,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Bar',
                        style: TextStyle(
                          color: AppColors.colorFFFFFF,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Bee ',
                        style: TextStyle(
                          color: AppColors.colorFF8600,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Inc. ',
                        style: TextStyle(
                          color: AppColors.colorFFFFFF,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: AppStrings.backAtIt,
                        style: TextStyle(
                          color: AppColors.colorFFFFFF,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 20.w),

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
                              validator: FormValidators.validateEmail,
                              filled: true,
                              fillColor: AppColors.color101010,
                              enabledBorderColor: Colors.transparent,
                              hintText: 'Username or Email',
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
                                validator: FormValidators.validatePassword,
                                filled: true,
                                fillColor: AppColors.color101010,
                                enabledBorderColor: Colors.transparent,
                                isObscuredText: controller.isObscured.value,
                                hintText: AppStrings.password,
                                textInputAction: TextInputAction.done,
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

                            /// FORGET PASSWORD OPTION
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.FORGOT_PASSWORD);
                                },
                                child: CustomText(
                                  title: 'Forgot Password?',
                                  fontSize: 15,
                                  color: AppColors.colorFF8600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),

                            /// REMEMBER ME OPTION
                            Obx(
                              () => Row(
                                children: [
                                  Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity(
                                      horizontal: -3.w,
                                      vertical: -4.h,
                                    ),
                                    value: controller.rememberMe.value,
                                    onChanged:
                                        (v) => controller.toggleRememberMe(v!),
                                    activeColor: AppColors.colorFF8600,
                                  ),
                                  CustomText(
                                    title: "Remember Me",
                                    color: AppColors.colorFFFFFF,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),

                            /// SIGN IN OPTION
                            Obx(
                              () => CustomBtn(
                                buttonHeight: 55.h,
                                btnTitle: AppStrings.signIn,
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

                            /// OR DIVIDER
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.color4C4C4C,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: CustomText(
                                    title: "OR",
                                    fontSize: 14,
                                    color: AppColors.color4C4C4C,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.color4C4C4C,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),

                            /// CONTINUE WITH GOOGLE BUTTON
                         /*   Obx(
                              () => CustomBtn(
                                buttonHeight: 55.h,
                                btnTitle: "Continue with Google",
                                btnBackgroundColor: AppColors.colorFFFFFF,
                                btnTxtColor: AppColors.color000000,
                                onPressed: controller.signInWithGoogle,
                                isLoading: controller.isGoogleSignInLoading.value,
                                iconPath: AppAssets.googleLogo,
                              ),
                            ),*/

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
                                      fontSize: 15.sp,
                                      color: AppColors.colorFFFFFF,
                                    ),
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                    text: AppStrings.signUp,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontSize: 15.sp,
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
                          ],
                        ),
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
