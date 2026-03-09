import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/presentation/signUp/component/agree_terms_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_app_shimmer.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/custom_dropdown.dart';
import '../../infrastructure/widgets/custom_multi_select_dropdown.dart';
import '../../infrastructure/widgets/custom_profile_image.dart';
import '../../infrastructure/widgets/custom_text.dart';
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
                              horizontal: 18.w,
                              vertical: 30.h,
                            ),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 15.h,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Back Arrow (Top Left)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: Get.back,
                                            child: SvgPicture.asset(
                                              AppAssets.backIcon,
                                              width: 20.w,
                                              height: 20.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        // Center Title
                                        CustomText(
                                          title: 'Sign-Up as Employer',
                                          color: AppColors.colorFFFFFF,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Row(
                                  //   spacing: 30.w,
                                  //   children: [
                                  //     IconButton(
                                  //       icon: const Icon(
                                  //         Icons.arrow_back,
                                  //         color: Colors.white,
                                  //       ),
                                  //       onPressed: () => Get.back(),
                                  //     ),
                                  //     CustomText(
                                  //       title: 'Sign Up as Employer',
                                  //       color: AppColors.colorFFFFFF,
                                  //       fontSize: 22,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //   ],
                                  // ),

                                  /// PROFILE IMAGE
                                  CustomProfileImage(
                                    imagePath:
                                        controller.selectedImage.value?.path ??
                                        controller.profileImageUrl.value,
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
                                  CustomDropdown(
                                    hint: 'Country',
                                    iconPath: AppAssets.countryIcon,
                                    selectedValue: controller.selectedCountry,
                                    // new RxString
                                    onChanged: (value) {
                                      controller.updateCountry(value);
                                    },
                                    validator:
                                        (v) => FormValidators.validateRequired(
                                          v,
                                          'Country',
                                        ),
                                    items:
                                        controller.countries
                                            .map(
                                              (country) => DropdownMenuItem(
                                                value: country.name,
                                                child: CustomText(
                                                  title: country.name,
                                                  color: AppColors.color4C4C4C,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                  // _buildTextField(
                                  //   hint: 'Country',
                                  //   controller: controller.countryController,
                                  //   icon: AppAssets.countryIcon,
                                  //   validator:
                                  //       (value) =>
                                  //           FormValidators.validateRequired(
                                  //             value,
                                  //             "Country",
                                  //           ),
                                  // ),

                                  /// State and City Field
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      Expanded(
                                        child: CustomDropdown(
                                          hint: 'State',
                                          iconPath: AppAssets.stateIcon,
                                          selectedValue:
                                              controller.selectedState,
                                          // new RxString
                                          onChanged: (value) {
                                            controller.updateState(value);
                                          },
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'State',
                                                  ),
                                          items:
                                              controller.states
                                                  .map(
                                                    (state) => DropdownMenuItem(
                                                      value: state.name,
                                                      child: CustomText(
                                                        title: state.name,
                                                        color:
                                                            AppColors
                                                                .color4C4C4C,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),

                                      // Expanded(
                                      //   child: _buildTextField(
                                      //     hint: 'State',
                                      //     controller:
                                      //         controller.stateController,
                                      //     icon: AppAssets.stateIcon,
                                      //     validator:
                                      //         (value) =>
                                      //             FormValidators.validateRequired(
                                      //               value,
                                      //               "State",
                                      //             ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: Obx(
                                          () =>
                                              controller.isCitiesLoading.value
                                                  ? AppShimmer(
                                                    height: 56,
                                                    width: double.infinity,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  )
                                                  : _buildDropdown(
                                                    hint: 'City',
                                                    iconPath:
                                                        AppAssets.cityIcon,
                                                    selectedValue:
                                                        controller.selectedCity,
                                                    onChanged:
                                                        controller.updateCity,
                                                    validator:
                                                        (v) =>
                                                            FormValidators.validateRequired(
                                                              v,
                                                              'City',
                                                            ),
                                                    items:
                                                        controller.cities
                                                            .map(
                                                              (
                                                                city,
                                                              ) => DropdownMenuItem(
                                                                value:
                                                                    city.name,
                                                                child: CustomText(
                                                                  title:
                                                                      city.name,
                                                                  color:
                                                                      AppColors
                                                                          .color4C4C4C,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            )
                                                            .toList(),
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  _buildTextField(
                                    hint: 'Address',
                                    controller: controller.addressController,
                                    icon: AppAssets.cityIcon,
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              "Address",
                                            ),
                                  ),

                                  CustomMultiSelectDropdown(
                                    hint: "Position Seeking",
                                    iconPath: AppAssets.cardIcon,
                                    selectedValues: controller.selectedSkills,
                                    items:
                                        controller.skills
                                            .map((s) => s.name)
                                            .toList(),
                                    validator: (value) {
                                      if (controller.selectedSkills.isEmpty) {
                                        return "Please select at least one skill";
                                      }
                                      return null;
                                    },
                                  ),

                                  /// Business Name Field
                                  _buildTextField(
                                    hint: 'Business Tax #',
                                    controller:
                                        controller.businessTaxController,
                                    icon: AppAssets.personIcon,
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              "Business Tax Number",
                                            ),
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
                                  SizedBox(height: 20.h),

                                  /// OR DIVIDER
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: Divider(
                                  //         color: AppColors.colorFFFFFF.withValues(alpha: 0.3),
                                  //         thickness: 1,
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  //       child: CustomText(
                                  //         title: 'OR',
                                  //         color: AppColors.colorFFFFFF.withValues(alpha: 0.6),
                                  //         fontSize: 14,
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: Divider(
                                  //         color: AppColors.colorFFFFFF.withValues(alpha: 0.3),
                                  //         thickness: 1,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(height: 20.h),

                                  /// CONTINUE WITH GOOGLE BUTTON
                                  // Obx(
                                  //   () => CustomBtn(
                                  //     buttonHeight: 55.h,
                                  //     btnTitle: "Continue with Google",
                                  //     btnBackgroundColor: AppColors.color000000,
                                  //     borderColor: AppColors.colorFFFFFF.withValues(alpha: 0.4),
                                  //     btnTxtColor: AppColors.colorFFFFFF,
                                  //     onPressed: controller.signUpWithGoogle,
                                  //     isLoading: controller.isGoogleSignInLoading.value,
                                  //     iconPath: AppAssets.googleLogo,
                                  //   ),
                                  // ),
                                  // if (Platform.isIOS) ...[
                                  //   SizedBox(height: 15.h),
                                  //
                                  //   /// CONTINUE WITH APPLE BUTTON
                                  //   Obx(
                                  //     () => CustomBtn(
                                  //       isLoading: controller.isAppleSignInLoading.value,
                                  //       buttonHeight: 55.h,
                                  //       btnTitle: "Continue With Apple",
                                  //       btnBackgroundColor: AppColors.color000000,
                                  //       borderColor: AppColors.colorFFFFFF,
                                  //       btnTxtColor: AppColors.colorFFFFFF,
                                  //       iconPath: AppAssets.appleLogo,
                                  //       onPressed: controller.signUpWithApple,
                                  //     ),
                                  //   ),
                                  // ],
                                  // SizedBox(height: 20.h),
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

  Widget _buildDropdown({
    required String hint,
    required String iconPath,
    required RxString selectedValue,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return CustomDropdown(
      hint: hint,
      iconPath: iconPath,
      selectedValue: selectedValue,
      onChanged: onChanged,
      validator: validator,
      items: items,
    );
  }
}
