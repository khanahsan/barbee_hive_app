import 'package:barbee_hive_app/infrastructure/constants/app_strings.dart';
import 'package:barbee_hive_app/presentation/changePassword/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/utils/form_validators.dart';
import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_appbar.dart';
import '../../infrastructure/widgets/custom_btn.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        title: AppStrings.changePassword,
        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
      ),
      body: Form(
        key: controller.formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              spacing: 20.h,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// CURRENT PASSWORD FIELD
                  Obx(() => AppTextField(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    validator: FormValidators.validatePassword,
                    filled: true,
                    fillColor: AppColors.color101010,
                    focusNode: controller.passFocusNode,
                    enabledBorderColor: Colors.transparent,
                    isObscuredText: controller.isPasswordObscured.value,
                    hintText: AppStrings.currentPassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: SvgPicture.asset(
                      AppAssets.lockIcon,
                      fit: BoxFit.scaleDown,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: controller.oldPasswordToggle,
                      child: Icon(
                        controller.isPasswordObscured.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 25.sp,
                        color: AppColors.color4C4C4C,
                      ),
                    ),
                    controller: controller.currentPassController,
                  ),
                ),
            
                /// NEW PASSWORD FIELD
                  Obx(() => AppTextField(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    validator: FormValidators.validatePassword,
                    filled: true,
                    fillColor: AppColors.color101010,
                    enabledBorderColor: Colors.transparent,
                    focusNode: controller.newPassFocusNode,
                    isObscuredText: controller.isNewPasswordObscured.value,
                    hintText: AppStrings.newPassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: SvgPicture.asset(
                      AppAssets.lockIcon,
                      fit: BoxFit.scaleDown,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: controller.newPasswordToggle,
                      child: Icon(
                        controller.isNewPasswordObscured.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 25.sp,
                        color: AppColors.color4C4C4C,
                      ),
                    ),
                    controller: controller.newPassController,
                  ),
                ),
            
                /// CONFIRM PASSWORD FIELD
                Obx(() => AppTextField(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    validator:
                        (value) => FormValidators.validateConfirmPassword(
                          value,
                          controller.newPassController.text,
                        ),
                    filled: true,
                    fillColor: AppColors.color101010,
                    enabledBorderColor: Colors.transparent,
                  isObscuredText: controller.isConfirmPasswordObscured.value,
                    hintText: AppStrings.confirmPassword,
                  focusNode: controller.confirmPassFocusNode,
                    textInputAction: TextInputAction.done,
                    prefixIcon: SvgPicture.asset(
                      AppAssets.lockIcon,
                      fit: BoxFit.scaleDown,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: controller.confirmPasswordToggle,
                      child: Icon(
                        controller.isConfirmPasswordObscured.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 25.sp,
                        color: AppColors.color4C4C4C,
                      ),
                    ),
                    controller: controller.confirmPassController,
                  ),
                ),
            
                /// CHANGE PASS OPTION
                Obx(
                  () => CustomBtn(
                    buttonHeight: 55.h,
                    btnTitle: AppStrings.changePassword,
                    btnBackgroundColor: AppColors.colorFF8600,
                    btnTxtColor: AppColors.colorFFFFFF,
                    onPressed: () {

                      controller.changePassword();

                    },
                    isLoading: controller.isLoading.value,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 15.w),
          ),
        ),
      ),
    );
  }
}
