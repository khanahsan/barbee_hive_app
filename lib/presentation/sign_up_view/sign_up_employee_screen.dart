import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/component/hexagon_widget.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/controllers/sign_up_employee_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_dropdown.dart';

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
                              horizontal: 10.w,
                              vertical: 20.h,
                            ),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// HEADER
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
                                        'Sign Up as Employee',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),

                                  /// PROFILE IMAGE
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        HexagonProfilePhotoTile(
                                          selectedImage:
                                              controller.selectedImage.value,
                                          imageUrl:
                                              controller
                                                      .profileImageUrl
                                                      .value
                                                      .isNotEmpty
                                                  ? controller
                                                      .profileImageUrl
                                                      .value
                                                  : null,
                                          onTap:
                                              controller.showImagePickerOptions,
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
                                  _buildDropdown(
                                    hint: 'Experience',
                                    iconPath: AppAssets.cardIcon,
                                    selectedValue: controller.selectedSkill,
                                    onChanged: controller.updateSkill,
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              'Experience',
                                            ),
                                    items:
                                        controller.skills
                                            .map(
                                              (skill) => DropdownMenuItem(
                                                value: skill.name,
                                                child: CustomText(
                                                  title: skill.name,
                                                  color: AppColors.color4C4C4C,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                  SizedBox(height: 15.h),

                                  /// COUNTRY
                                  _buildTextField(
                                    'Country',
                                    controller.countryController,
                                    prefixIconPath: AppAssets.countryIcon,
                                    validator:
                                        (v) => FormValidators.validateRequired(
                                          v,
                                          'Country',
                                        ),
                                  ),
                                  SizedBox(height: 15.h),

                                  /// STATE + CITY
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          'State',
                                          controller.stateController,
                                          prefixIconPath: AppAssets.stateIcon,
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'State',
                                                  ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: _buildTextField(
                                          'City',
                                          controller.cityController,
                                          prefixIconPath: AppAssets.cityIcon,
                                          validator:
                                              (v) =>
                                                  FormValidators.validateRequired(
                                                    v,
                                                    'City',
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),

                                  /// DOB
                                  Obx(
                                        () => GestureDetector(
                                      onTap: controller.pickDate,
                                      child: AbsorbPointer(
                                        child: _buildTextField(
                                          controller.selectedDate.value.isEmpty
                                              ? 'DOB (MM-DD-YYYY)'
                                              : controller.selectedDate.value,
                                          controller.dateController,
                                          suffixIconPath: AppAssets.calendarIcon,
                                          readOnly: true,
                                          validator: FormValidators.validateAge,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15.h),

                                  /// GENDER + HEIGHT
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
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Male',
                                              child: CustomText(
                                                title: 'Male',
                                                color: AppColors.color4C4C4C,
                                                fontSize: 16,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Female',
                                              child: CustomText(
                                                title: 'Female',
                                                color: AppColors.color4C4C4C,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
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
                                          items: const [
                                            DropdownMenuItem(
                                              value: '140',
                                              child: CustomText(
                                                title: '140 cm',
                                                color: AppColors.color4C4C4C,
                                                fontSize: 16,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: '150',
                                              child: CustomText(
                                                title: '150 cm',
                                                color: AppColors.color4C4C4C,
                                                fontSize: 16,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: '160',
                                              child: CustomText(
                                                title: '160 cm',
                                                color: AppColors.color4C4C4C,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),

                                  /// EYE + HAIR COLOR
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
                                    () => DottedBorder(
                                      options:
                                          const RoundedRectDottedBorderOptions(
                                            dashPattern: [6, 3],
                                            color: AppColors.textFieldTextColor,
                                            strokeWidth: 2,
                                            radius: Radius.circular(12),
                                          ),
                                      child: GestureDetector(
                                        onTap: controller.pickResume,
                                        child: Container(
                                          width: double.infinity,
                                          height: 55.h,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                          ),
                                          child: Text(
                                            controller.selectedResume.value ==
                                                    null
                                                ? 'Upload Resume/Certification (PDF)'
                                                : 'Selected: ${controller.selectedResume.value!.path.split('/').last}',
                                            style: TextStyle(
                                              color:
                                                  AppColors.textFieldTextColor,
                                              fontSize: 14.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),

                                  /// TERMS CHECKBOX
                                  Obx(
                                    () => Row(
                                      spacing: 10.w,
                                      children: [
                                        GestureDetector(
                                          onTap: controller.toggleCheckbox,
                                          child: Container(
                                            width: 20.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.grey,
                                                width: 2.w,
                                              ),
                                              color:
                                                  controller.isChecked.value
                                                      ? AppColors.colorFF8600
                                                      : Colors.transparent,
                                            ),
                                            child:
                                                controller.isChecked.value
                                                    ? Icon(
                                                      Icons.check,
                                                      size: 15.sp,
                                                      color: Colors.white,
                                                    )
                                                    : null,
                                          ),
                                        ),
                                        CustomText(
                                          title:
                                              'I agree to the Terms of Service',
                                          color: AppColors.colorFF8600,
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30.h),

                                  /// CREATE ACCOUNT BUTTON
                                  CustomBtn(
                                    btnTitle: 'Create Account',
                                    buttonHeight: 50.h,
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
