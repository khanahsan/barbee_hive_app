import 'package:barbee_hive_app/infrastructure/constants/app_strings.dart';
import 'package:barbee_hive_app/presentation/changePassword/controller/change_password_controller.dart';
import 'package:flutter/material.dart';
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
                AppTextField(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  validator: FormValidators.validatePassword,
                  filled: true,
                  fillColor: AppColors.color101010,
                  enabledBorderColor: Colors.transparent,
                  hintText: AppStrings.currentPassword,
                  textInputAction: TextInputAction.done,
                  controller: controller.currentPassController,
                ),
            
                /// NEW PASSWORD FIELD
                AppTextField(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  validator: FormValidators.validatePassword,
                  filled: true,
                  fillColor: AppColors.color101010,
                  enabledBorderColor: Colors.transparent,
                  hintText: AppStrings.newPassword,
                  textInputAction: TextInputAction.done,
                  controller: controller.newPassController,
                ),
            
                /// CONFIRM PASSWORD FIELD
                AppTextField(
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
                  hintText: AppStrings.confirmPassword,
                  textInputAction: TextInputAction.done,
                  controller: controller.confirmPassController,
                ),
            
                /// CHANGE PASS OPTION
                Obx(
                  () => CustomBtn(
                    buttonHeight: 55.h,
                    btnTitle: AppStrings.changePassword,
                    btnBackgroundColor: AppColors.colorFF8600,
                    btnTxtColor: AppColors.colorFFFFFF,
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.changePassword();
                      }
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
