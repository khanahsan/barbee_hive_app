import 'package:barbee_hive_app/infrastructure/constants/app_strings.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/app_text_field.dart';
import '../auth/controllers/auth.controller.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
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
                CustomText(
                  title: '${AppStrings.loginTo}\n${AppStrings.appName}',
                  fontSize: 36,
                  color: AppColors.colorFFFFFF,
                ).paddingSymmetric(horizontal: 20.w),

                /// SUB LABEL
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: AppColors.colorFFFFFF),
                    children: [
                      TextSpan(
                        text: '${AppStrings.welcomeBackTo} ',
                        style: TextStyle(
                          color: AppColors.colorFFFFFF,
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '${AppStrings.appName}, ',
                        style: TextStyle(
                          color: AppColors.colorFF8600,
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: AppStrings.findHottestBar,
                        style: TextStyle(
                          color: AppColors.colorFFFFFF,
                          fontSize: 20.0.sp,
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
                          spacing: 15.h,
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
                              controller: controller.nameController,
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
                                child: Text(
                                  'Forgot Password?',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontSize: 15.sp,
                                    color: AppColors.colorFF8600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),

                            /// SIGN IN OPTION
                            Obx(
                              () => CustomBtn(
                                buttonHeight: 55.h,
                                btnTitle: AppStrings.signIn,
                                btnBackgroundColor: AppColors.colorFF8600,
                                btnTxtColor: AppColors.colorFFFFFF,
                                onPressed: () {
                                  if (controller.formKey.currentState!.validate()) {
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
