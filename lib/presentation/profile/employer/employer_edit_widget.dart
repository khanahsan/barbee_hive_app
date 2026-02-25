

import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/app_text_field.dart';
import '../../../infrastructure/widgets/custom_app_shimmer.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';
import '../../../infrastructure/widgets/custom_multi_select_dropdown.dart';

class EmployerEditWidget extends GetView<ProfileController> {
  const EmployerEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15.h,
            children: [
          /// NAME FIELD
          _buildCustomTextField(
            hintText: "Name",
            controller: controller.nameController,
            prefixIconPath: AppAssets.editIcon,
            validator: (value) => FormValidators.validateName(value),
          ),

          /// EMAIL FIELD
          _buildCustomTextField(
            isReadOnly: true,
            hintText: "Email Address",
            controller: controller.emailController,
            prefixIconPath: AppAssets.envelopeIcon,
            validator: (value) => FormValidators.validateEmail(value),
          ),

          /// PASSWORD FIELD
          // Obx(
          //   () => AppTextField(
          //     fontSize: 16,
          //     contentPadding: EdgeInsets.symmetric(
          //       vertical: 10.h,
          //       horizontal: 16.w,
          //     ),
          //     validator: (value) {
          //       if (value != null && value.isNotEmpty) {
          //         return FormValidators.validatePassword(value);
          //       }
          //       return null;
          //     },
          //     // fontColor: AppColors.color4C4C4C,
          //     controller: controller.passController,
          //     filled: true,
          //     fillColor: AppColors.textFieldBackground,
          //     enabledBorderColor: Colors.transparent,
          //     hintText: "Password",
          //     isObscuredText: controller.passwordObscure.value,
          //     prefixIcon: SvgPicture.asset(
          //       AppAssets.lockIcon,
          //       fit: BoxFit.scaleDown,
          //       color: AppColors.color4C4C4C,
          //     ),
          //     suffixIcon: GestureDetector(
          //       onTap:
          //           () =>
          //               controller.passwordObscure.value =
          //                   !controller.passwordObscure.value,
          //       child: Icon(
          //         controller.passwordObscure.value
          //             ? Icons.visibility_off
          //             : Icons.visibility,
          //         color: AppColors.color4C4C4C,
          //       ),
          //     ),
          //   ),
          // ),

          /// CONFIRM PASSWORD FIELD
          // Obx(
          //   () => AppTextField(
          //     fontSize: 16,
          //     contentPadding: EdgeInsets.symmetric(
          //       vertical: 10.h,
          //       horizontal: 16.w,
          //     ),
          //     validator: (value) {
          //       if (controller.passController.text.isNotEmpty) {
          //         return FormValidators.validateConfirmPassword(
          //           value,
          //           controller.passController.text,
          //         );
          //       }
          //       return null;
          //     },
          //     // fontColor: AppColors.color4C4C4C,
          //     controller: controller.confirmPassController,
          //     filled: true,
          //     fillColor: AppColors.textFieldBackground,
          //     enabledBorderColor: Colors.transparent,
          //     hintText: "Confirm Password",
          //     isObscuredText: controller.confirmPasswordObscure.value,
          //     prefixIcon: SvgPicture.asset(
          //       AppAssets.lockIcon,
          //       fit: BoxFit.scaleDown,
          //       color: AppColors.color4C4C4C,
          //     ),
          //     suffixIcon: GestureDetector(
          //       onTap:
          //           () =>
          //               controller.confirmPasswordObscure.value =
          //                   !controller.confirmPasswordObscure.value,
          //       child: Icon(
          //         controller.confirmPasswordObscure.value
          //             ? Icons.visibility_off
          //             : Icons.visibility,
          //         color: AppColors.color4C4C4C,
          //       ),
          //     ),
          //   ),
          // ),

          /// COUNTRY FIELD
          CustomDropdown(
            validator:
                (value) => FormValidators.validateRequired(value, "Country"),
            hint: "Country",
            iconPath: AppAssets.countryIcon,
            selectedValue: controller.currentCountryName,
            items:
            controller.countries
                .map(
                  (e) => DropdownMenuItem<String>(
                value: e.name,
                child: Text(e.name),
              ),
            )
                .toList(),
            onChanged: (val) {
              controller.currentCountryName.value = val ?? '';


              final selected = controller.countries.firstWhereOrNull(
                    (e) => e.name == val,
              );
              controller.currentCountryId.value = selected?.id ?? 0;
            },
          ),
          // _buildCustomTextField(
          //   hintText: 'Country',
          //   controller: controller.countryController,
          //   prefixIconPath: AppAssets.countryIcon,
          //   validator: (v) => FormValidators.validateRequired(v, 'Country'),
          // ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15.w,
            children: [
              Expanded(
                child: CustomDropdown(
                  validator:
                      (value) =>
                      FormValidators.validateRequired(value, "State"),
                  hint: "State",
                  iconPath: AppAssets.stateIcon,
                  selectedValue: controller.currentStateName,
                  items:
                  controller.states
                      .map(
                        (e) => DropdownMenuItem<String>(
                      value: e.name,
                      child: Text(e.name),
                    ),
                  )
                      .toList(),
                  onChanged: controller.updateStateSelection,
                ),
              ),
              // Expanded(
              //   child: _buildCustomTextField(
              //     hintText: 'State',
              //     controller: controller.stateController,
              //     prefixIconPath: AppAssets.stateIcon,
              //     validator:
              //         (v) => FormValidators.validateRequired(v, 'State'),
              //   ),
              // ),
              Expanded(
                child: Obx(() {
                  if (controller.isCitiesLoading.value) {
                    return AppShimmer(
                      height: 56,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(10),
                    );
                  }
                  return CustomDropdown(
                    validator:
                        (value) =>
                            FormValidators.validateRequired(value, "City"),
                    hint: "City",
                    iconPath: AppAssets.cityIcon,
                    selectedValue: controller.currentCityName,
                    items:
                        controller.cities
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e.name,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                    onChanged: controller.updateCitySelection,
                  );
                }),
              ),
            ],
          ),

          /// ADDRESS FIELD
          // _buildCustomTextField(
          //   hintText: 'Address',
          //   controller: controller.addressController,
          //   prefixIconPath: AppAssets.cityIcon,
          //   validator:
          //       (v) => FormValidators.validateRequired(v, 'Address'),
          // ),

          /// EXPERIENCE FIELD
          CustomMultiSelectDropdown(
            hint: "Position Seeking",
            iconPath: AppAssets.cardIcon,
            selectedValues: controller.selectedSkills,
            items: controller.skills.map((s) => s.name).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Position Seeking required";
              }
              return null;
            },
          ),

          /// BUSINESS TAX FIELD
          _buildCustomTextField(
            hintText: 'Business Tax #',
            controller: controller.businessTaxController,
            prefixIconPath: AppAssets.personIcon,
            validator:
                (v) =>
                    FormValidators.validateRequired(v, 'Business Tax Number'),
          ),
          // Obx(
          //   () => CustomDropdown(
          //     validator:
          //         (value) => FormValidators.validateRequired(
          //           value,
          //           "Position Seeking",
          //         ),
          //     hint: "Position Seeking",
          //     iconPath: AppAssets.cardIcon,
          //     selectedValue: controller.currentSkillName,
          //     items:
          //         controller.skills
          //             .map(
          //               (skill) => DropdownMenuItem<String>(
          //                 value: skill.name,
          //                 child: Text(skill.name),
          //               ),
          //             )
          //             .toList(),
          //     onChanged: (val) {
          //       controller.currentSkillName.value = val ?? '';
          //       final selected = controller.skills.firstWhereOrNull(
          //         (e) => e.name == val,
          //       );
          //       controller.currentSkillId.value = selected?.id ?? 0;
          //     },
          //   ),
          // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required String prefixIconPath,
    String? Function(String?)? validator,
    bool? isReadOnly,
  }) {
    return AppTextField(
      validator: validator,
      readOnly: isReadOnly ?? false,
      controller: controller,
      filled: true,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      hintText: hintText,
      prefixIcon: SvgPicture.asset(
        prefixIconPath,
        fit: BoxFit.scaleDown,
        color: AppColors.color4C4C4C,
      ),
    );
  }
}
