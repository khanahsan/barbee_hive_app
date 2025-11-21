import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/presentation/signUp/component/agree_terms_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/custom_dropdown.dart';
import '../../infrastructure/widgets/custom_profile_image.dart';
import 'controllers/sign_up_employer_controller.dart';

class SignUpEmployerScreen extends GetView<SignUpEmployerController> {
  const SignUpEmployerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Hero(
          tag: 'gold_line',
          child: Material(
            color: Colors.transparent,
            child: Container(
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
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18.0),
                    topLeft: Radius.circular(18.0),
                  ),
                ),
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 20.h,
                            ),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 15.h,
                                children: [
                                  Row(
                                    spacing: 30.w,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => Get.back(),
                                      ),
                                      Text(
                                        'Sign Up as Employer',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// PROFILE IMAGE
                                  CustomProfileImage(
                                    imagePath:
                                        controller.selectedImage.value?.path ??
                                        '',
                                    width: 130,
                                    height: 140,
                                    testIcon: AppAssets.cameraIcon,
                                    text: "Upload Photo",
                                    showFullText: true,
                                    // Only edit icon is clickable
                                    onImagePicked: (file) {
                                      controller.selectedImage.value = file;
                                    },
                                  ),

                                  /// Business Name Field
                                  _buildTextField(
                                    hint: 'Business Name',
                                    controller: controller.nameController,
                                    icon: AppAssets.personIcon,
                                    validator:
                                        (value) =>
                                            FormValidators.validateName(value),
                                  ),

                                  /// Email Address Field
                                  _buildTextField(
                                    keyboardType: TextInputType.emailAddress,
                                    hint: 'Email Address',
                                    controller: controller.emailController,
                                    icon: AppAssets.emailIcon,
                                    validator:
                                        (value) =>
                                            FormValidators.validateEmail(value),
                                  ),

                                  /// Password Field
                                  Obx(
                                    () => _buildTextField(
                                      hint: 'Password',
                                      controller: controller.passwordController,
                                      icon: AppAssets.lockIcon,
                                      obscure:
                                          !controller.isPasswordVisible.value,
                                      suffix: GestureDetector(
                                        onTap:
                                            controller.togglePasswordVisibility,
                                        child: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                      validator:
                                          (value) =>
                                              FormValidators.validatePassword(
                                                value,
                                              ),
                                    ),
                                  ),

                                  /// Confirm Password Field
                                  Obx(
                                    () => _buildTextField(
                                      hint: 'Confirm Password',
                                      controller:
                                          controller.confirmPasswordController,
                                      icon: AppAssets.lockIcon,
                                      obscure:
                                          !controller
                                              .isConfirmPasswordVisible
                                              .value,
                                      suffix: GestureDetector(
                                        onTap:
                                            controller
                                                .toggleConfirmPasswordVisibility,
                                        child: Icon(
                                          controller
                                                  .isConfirmPasswordVisible
                                                  .value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                      validator:
                                          (value) =>
                                              FormValidators.validateConfirmPassword(
                                                value,
                                                controller
                                                    .passwordController
                                                    .text,
                                              ),
                                    ),
                                  ),

                                  /// Country Field
                                  _buildTextField(
                                    hint: 'Country',
                                    controller: controller.countryController,
                                    icon: AppAssets.countryIcon,
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              "Country",
                                            ),
                                  ),

                                  /// State and City Field
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          hint: 'State',
                                          controller:
                                              controller.stateController,
                                          icon: AppAssets.stateIcon,
                                          validator:
                                              (value) =>
                                                  FormValidators.validateRequired(
                                                    value,
                                                    "State",
                                                  ),
                                        ),
                                      ),

                                      Expanded(
                                        child: _buildTextField(
                                          hint: 'City',
                                          controller: controller.cityController,
                                          icon: AppAssets.cityIcon,
                                          validator:
                                              (value) =>
                                                  FormValidators.validateRequired(
                                                    value,
                                                    "City",
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Position Seeking Field
                                  CustomDropdown(
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              "Position Seeking",
                                            ),
                                    hint: 'Position Seeking',
                                    iconPath: AppAssets.experienceLogo,
                                    selectedValue: controller.selectedSkill,
                                    onChanged: controller.updateSkill,
                                    items:
                                        controller.skills
                                            .asMap()
                                            .entries
                                            .where(
                                              (entry) =>
                                                  !controller.skills
                                                      .sublist(0, entry.key)
                                                      .map((e) => e.name)
                                                      .contains(
                                                        entry.value.name,
                                                      ),
                                            )
                                            .map(
                                              (entry) => DropdownMenuItem(
                                                value: entry.value.name,
                                                child: Text(
                                                  entry.value.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),

                                  /// TERMS SECTION
                                  AgreeTermsTile(
                                    onTap: controller.toggleCheckbox,
                                    isChecked: controller.isChecked,
                                  ),
                                  SizedBox(height: 20.h),

                                  /// Create Account Option
                                  CustomBtn(
                                    btnTitle: 'Create Account',
                                    buttonHeight: 55.h,
                                    btnBackgroundColor: AppColors.colorFF8600,
                                    btnTxtColor: Colors.white,
                                    buttonWidth: double.infinity,
                                    onPressed: () {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        controller.registerEmployer();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required String icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return AppTextField(
      keyboardType: keyboardType,
      validator: validator,
      hintText: hint,
      controller: controller,
      isObscuredText: obscure,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      prefixIcon: SvgPicture.asset(
        icon,
        color: AppColors.textFieldTextColor,
        fit: BoxFit.scaleDown,
      ),
      suffixIcon: suffix,
    );
  }
}
