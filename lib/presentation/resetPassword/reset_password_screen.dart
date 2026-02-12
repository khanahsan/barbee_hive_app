import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/utils/form_validators.dart';
import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'controller/reset_password_controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// App Icon
                    SvgPicture.asset(
                      AppAssets.appIcon,
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),

                    SizedBox(height: 30.h),

                    /// Orange Top Border Container
                    Container(
                      padding: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.colorFF8600,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 30.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.r),
                            topLeft: Radius.circular(18.r),
                          ),
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// New Password
                              Obx(
                                () => AppTextField(
                                  validator: FormValidators.validatePassword,
                                  hintText: 'New Password',
                                  focusNode: controller.newPassFocusNode,
                                  isObscuredText:
                                      controller.isNewPasswordObscured.value,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.lockIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: controller.toggleNewPassword,
                                    icon: Icon(
                                      controller.isNewPasswordObscured.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.color4C4C4C,
                                    ),
                                  ),
                                  controller: controller.newPassController,
                                  fillColor: AppColors.color101010,
                                  filled: true,
                                  enabledBorderColor: Colors.transparent,
                                  fontColor: AppColors.color4C4C4C,
                                ),
                              ),
                              SizedBox(height: 30.h),

                              /// Confirm Password
                              Obx(
                                () => AppTextField(
                                  validator:
                                      (value) =>
                                          FormValidators.validateConfirmPassword(
                                            value,
                                            controller.newPassController.text,
                                          ),
                                  hintText: 'Confirm Password',
                                  focusNode: controller.confirmPassFocusNode,
                                  isObscuredText:
                                      controller
                                          .isConfirmPasswordObscured
                                          .value,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.lockIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: controller.toggleConfirmPassword,
                                    icon: Icon(
                                      controller.isConfirmPasswordObscured.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.color4C4C4C,
                                    ),
                                  ),
                                  controller: controller.confirmPassController,
                                  fillColor: AppColors.color101010,
                                  filled: true,
                                  enabledBorderColor: Colors.transparent,
                                  fontColor: AppColors.color4C4C4C,
                                ),
                              ),
                              SizedBox(height: 30.h),

                              /// Button
                              Obx(
                                () => CustomBtn(
                                  buttonHeight: 55.h,
                                  btnTitle: 'Reset',
                                  btnBackgroundColor: AppColors.colorFF8600,
                                  btnTxtColor: AppColors.colorFFFFFF,
                                  onPressed: () {
                                    controller.resetPassword();
                                  },
                                  isLoading: controller.isLoading.value,
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
            );
          },
        ),
      ),
    );
  }
}
