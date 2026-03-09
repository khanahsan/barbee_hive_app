import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_app_shimmer.dart';
import '../../infrastructure/widgets/custom_dropdown.dart';
import '../../infrastructure/widgets/custom_multi_select_dropdown.dart';
import '../../infrastructure/widgets/custom_profile_image.dart';
import '../../infrastructure/widgets/custom_resume_widget.dart';
import 'component/agree_terms_tile.dart';
import 'controllers/sign_up_employee_controller.dart';

class SignUpEmployeeScreen extends GetView<SignUpEmployeeController> {
  const SignUpEmployeeScreen({super.key});

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
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 30.h,
                            ),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// HEADER
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
                                          title: 'Sign-Up as Employee',
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
                                  //       title: 'Sign Up as Employee',
                                  //       color: AppColors.colorFFFFFF,
                                  //       fontSize: 22,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(height: 20.h),

                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        /// PROFILE IMAGE
                                        CustomProfileImage(
                                          imagePath:
                                              controller
                                                  .selectedImage
                                                  .value
                                                  ?.path ??
                                              controller.profileImageUrl.value,
                                          width: 130,
                                          height: 140,
                                          testIcon: AppAssets.cameraIcon,
                                          text: "Upload Photo",
                                          showFullText: true,
                                          onImagePicked: (file) {
                                            controller.selectedImage.value =
                                                file;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  /// NAME
                                  _buildTextField(
                                    'Name',
                                    controller.nameController,
                                    prefixIconPath: AppAssets.personIcon,
                                    validator: FormValidators.validateName,
                                  ),
                                  SizedBox(height: 15.h),

                                  /// EMAIL
                                  _buildTextField(
                                    'Email Address',
                                    controller.emailController,
                                    prefixIconPath: AppAssets.emailIcon,
                                    validator: FormValidators.validateEmail,
                                  ),
                                  SizedBox(height: 15.h),

                                  /// PASSWORD
                                  _buildTextField(
                                    'Password',
                                    controller.passwordController,
                                    prefixIconPath: AppAssets.lockIcon,
                                    isPassword: true,
                                    isPasswordField: true,
                                    validator: FormValidators.validatePassword,
                                  ),
                                  SizedBox(height: 15.h),

                                  /// CONFIRM PASSWORD
                                  _buildTextField(
                                    'Confirm Password',
                                    controller.confirmPasswordController,
                                    prefixIconPath: AppAssets.lockIcon,
                                    isPassword: true,
                                    isConfirmPasswordField: true,
                                    validator:
                                        (value) =>
                                            FormValidators.validateConfirmPassword(
                                              value,
                                              controller
                                                  .passwordController
                                                  .text,
                                            ),
                                  ),
                                  SizedBox(height: 15.h),

                                  /// EXPERIENCE
                                  CustomMultiSelectDropdown(
                                    hint: 'Skills',
                                    iconPath: AppAssets.cardIcon,
                                    selectedValues: controller.selectedSkills,
                                    items:
                                        controller.skills
                                            .map((s) => s.name)
                                            .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select at least one skill";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15.h),

                                  _buildDropdown(
                                    hint: 'Experience Level',
                                    iconPath: AppAssets.cardIcon,
                                    selectedValue:
                                        controller.selectedExperienceLevel,
                                    onChanged: controller.updateExperienceLevel,
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              'Experience Level',
                                            ),
                                    items:
                                        controller.experienceLevels
                                            .map(
                                              (level) => DropdownMenuItem(
                                                value: level.name,
                                                child: CustomText(
                                                  title: level.name,
                                                  color: AppColors.color4C4C4C,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),

                                  // _buildDropdown(
                                  //   hint: 'Experience',
                                  //   iconPath: AppAssets.cardIcon,
                                  //   selectedValue: controller.selectedSkill,
                                  //   onChanged: controller.updateSkill,
                                  //   validator:
                                  //       (value) =>
                                  //           FormValidators.validateRequired(
                                  //             value,
                                  //             'Experience',
                                  //           ),
                                  //   items:
                                  //       controller.skills
                                  //           .map(
                                  //             (skill) => DropdownMenuItem(
                                  //               value: skill.name,
                                  //               child: CustomText(
                                  //                 title: skill.name,
                                  //                 color: AppColors.color4C4C4C,
                                  //                 fontSize: 16,
                                  //               ),
                                  //             ),
                                  //           )
                                  //           .toList(),
                                  // ),
                                  SizedBox(height: 15.h),

                                  /// COUNTRY
                                  _buildDropdown(
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
                                  //   'Country',
                                  //   controller.countryController,
                                  //   prefixIconPath: AppAssets.countryIcon,
                                  //   validator:
                                  //       (v) => FormValidators.validateRequired(
                                  //         v,
                                  //         'Country',
                                  //       ),
                                  // ),
                                  SizedBox(height: 15.h),

                                  /// STATE & CITY FIELD
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      // Expanded(
                                      //   child: _buildTextField(
                                      //     'State',
                                      //     controller.stateController,
                                      //     prefixIconPath: AppAssets.stateIcon,
                                      //     validator:
                                      //         (v) =>
                                      //             FormValidators.validateRequired(
                                      //               v,
                                      //               'State',
                                      //             ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: _buildDropdown(
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
                                  SizedBox(height: 15.h),

                                  /// ADDRESS FIELD
                                  _buildTextField(
                                    'Address',
                                    controller.addressController,
                                    prefixIconPath: AppAssets.cityIcon,
                                    validator:
                                        (v) => FormValidators.validateRequired(
                                          v,
                                          'Address',
                                        ),
                                  ),
                                  SizedBox(height: 15.h),

                                  /// DOB FIELD
                                  Obx(
                                    () => GestureDetector(
                                      onTap: controller.pickDate,
                                      child: AbsorbPointer(
                                        child: _buildTextField(
                                          controller.selectedDate.value.isEmpty
                                              ? 'DOB (MM-DD-YYYY)'
                                              : controller.selectedDate.value,
                                          controller.dateController,
                                          suffixIconPath:
                                              AppAssets.calendarIcon,
                                          readOnly: true,
                                          validator: FormValidators.validateAge,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15.h),

                                  /// GENDER & HEIGHT FIELD
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      Expanded(
                                        child: _buildDropdown(
                                          hint: 'Gender',
                                          iconPath: AppAssets.genderLogo,
                                          selectedValue:
                                              controller.selectedGender,
                                          onChanged: controller.updateGender,
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'Gender',
                                                  ),

                                          items:
                                              controller.genders
                                                  .map(
                                                    (
                                                      gender,
                                                    ) => DropdownMenuItem(
                                                      value: gender.name,
                                                      child: CustomText(
                                                        title: gender.name,
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
                                      Expanded(
                                        child: _buildDropdown(
                                          hint: 'Select Height',
                                          iconPath: AppAssets.heightLogo,
                                          selectedValue:
                                              controller.selectedHeight,
                                          onChanged: controller.updateHeight,
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'Height',
                                                  ),
                                          items:
                                              controller.heights
                                                  .map(
                                                    (
                                                      height,
                                                    ) => DropdownMenuItem(
                                                      value: height.name,
                                                      child: CustomText(
                                                        title: height.name,
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
                                    ],
                                  ),
                                  SizedBox(height: 15.h),

                                  /// EYE + HAIR COLOR FIELD
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10.w,
                                    children: [
                                      Expanded(
                                        child: _buildDropdown(
                                          hint: 'Select Eye Color',
                                          iconPath: AppAssets.userLogo,
                                          selectedValue:
                                              controller.selectedEyeColor,
                                          onChanged: controller.updateEyeColor,
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'Eye Color',
                                                  ),
                                          items:
                                              controller.eyeColors
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e.name,
                                                      child: CustomText(
                                                        title: e.name,
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
                                      Expanded(
                                        child: _buildDropdown(
                                          hint: 'Select Hair Color',
                                          iconPath: AppAssets.userLogo,
                                          selectedValue:
                                              controller.selectedHairColor,
                                          onChanged: controller.updateHairColor,
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'Hair Color',
                                                  ),
                                          items:
                                              controller.hairColors
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e.name,
                                                      child: CustomText(
                                                        title: e.name,
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
                                    ],
                                  ),
                                  SizedBox(height: 15.h),

                                  /// RESUME UPLOAD
                                  Obx(
                                    () => CustomResumeWidget(
                                      initialFileName:
                                          controller.selectedResume.value?.path
                                              .split('/')
                                              .last,
                                      onFileSelected: (file) {
                                        controller.selectedResume.value = file;
                                      },
                                    ),
                                  ),

                                  SizedBox(height: 15.h),

                                  /// TERMS SECTION
                                  AgreeTermsTile(
                                    onTap: controller.toggleCheckbox,
                                    isChecked: controller.isChecked,
                                  ),
                                  SizedBox(height: 30.h),

                                  /// CREATE ACCOUNT BUTTON
                                  CustomBtn(
                                    btnTitle: 'Create Account',
                                    buttonHeight: 55.h,
                                    btnBackgroundColor: AppColors.colorFF8600,
                                    btnTxtColor: Colors.white,
                                    buttonWidth: double.infinity,
                                    onPressed: () {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        controller.registerEmployee();
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

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    String? prefixIconPath,
    String? suffixIconPath,
    bool isPassword = false,
    bool isPasswordField = false,
    bool isConfirmPasswordField = false,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    Widget? prefixIcon;
    Widget? suffixIcon;

    if (prefixIconPath != null && prefixIconPath.isNotEmpty) {
      prefixIcon =
          prefixIconPath.endsWith('.svg')
              ? SvgPicture.asset(
                prefixIconPath,
                color: AppColors.textFieldTextColor,
                fit: BoxFit.scaleDown,
              )
              : Image.asset(
                prefixIconPath,
                color: AppColors.textFieldTextColor,
                fit: BoxFit.scaleDown,
              );
    }

    if (isPassword) {
      suffixIcon = IconButton(
        icon: Icon(
          (isPasswordField && !this.controller.isPasswordVisible.value) ||
                  (isConfirmPasswordField &&
                      !this.controller.isConfirmPasswordVisible.value)
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textFieldTextColor,
        ),
        onPressed: () {
          if (isPasswordField) {
            this.controller.togglePasswordVisibility();
          } else if (isConfirmPasswordField) {
            this.controller.toggleConfirmPasswordVisibility();
          }
        },
      );
    } else if (suffixIconPath != null && suffixIconPath.isNotEmpty) {
      suffixIcon =
          suffixIconPath.endsWith('.svg')
              ? SvgPicture.asset(
                suffixIconPath,
                color: AppColors.textFieldTextColor,
                fit: BoxFit.scaleDown,
              )
              : Image.asset(
                suffixIconPath,
                color: AppColors.textFieldTextColor,
                fit: BoxFit.scaleDown,
              );
    }

    return AppTextField(
      controller: controller,
      hintText: hint,
      validator: validator,
      readOnly: readOnly,
      isObscuredText:
          isPassword
              ? (isPasswordField
                  ? !this.controller.isPasswordVisible.value
                  : isConfirmPasswordField
                  ? !this.controller.isConfirmPasswordVisible.value
                  : false)
              : false,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      fontSize: 16,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
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
