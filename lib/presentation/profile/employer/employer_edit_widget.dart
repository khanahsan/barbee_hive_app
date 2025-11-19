/*
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';
import '../../../infrastructure/widgets/app_text_field.dart';

class EmployerEditWidget extends StatelessWidget {
  EmployerEditWidget({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15.h,
          children: [
            _buildCustomTextField(
              hintText: "Name",
              controller: controller.nameController,
              prefixIconPath: AppAssets.editIcon,
            ),
            _buildCustomTextField(
              hintText: "Email Address",
              controller: controller.emailController,
              prefixIconPath: AppAssets.envelopeIcon,
            ),
            _buildCustomTextField(
              hintText: "Password",
              controller: controller.passController,
              prefixIconPath: AppAssets.lockIcon,
            ),
            _buildCustomTextField(
              hintText: "Confirm Password",
              controller: controller.confirmPassController,
              prefixIconPath: AppAssets.lockIcon,
            ),
            CustomDropdown(
              prefixIconPath: AppAssets.experienceIcon,
              value: controller.selectedExperience.value,
              hintText: "Experience",
              items: controller.experienceList,
              onChanged: (val) {
                controller.selectedExperience.value = val ?? '';
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required String prefixIconPath,
  }) {
    return CustomTextField(
      fontColor: AppColors.color4C4C4C,
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
*/

import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/app_text_field.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';

class EmployerEditWidget extends GetView<ProfileController> {
  const EmployerEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: SingleChildScrollView(
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
            Obx(
                  () =>
                  AppTextField(
                    fontSize: 16,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 16.w,
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return FormValidators.validatePassword(value);
                      }
                      return null;
                    },
                    // fontColor: AppColors.color4C4C4C,
                    controller: controller.passController,
                    filled: true,
                    fillColor: AppColors.textFieldBackground,
                    enabledBorderColor: Colors.transparent,
                    hintText: "Password",
                    isObscuredText: controller.passwordObscure.value,
                    prefixIcon: SvgPicture.asset(
                      AppAssets.lockIcon,
                      fit: BoxFit.scaleDown,
                      color: AppColors.color4C4C4C,
                    ),
                    suffixIcon: GestureDetector(
                      onTap:
                          () =>
                      controller.passwordObscure.value =
                      !controller.passwordObscure.value,
                      child: Icon(
                        controller.passwordObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.color4C4C4C,
                      ),
                    ),
                  ),
            ),

            /// CONFIRM PASSWORD FIELD
            Obx(
                  () =>
                  AppTextField(
                    fontSize: 16,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 16.w,
                    ),
                    validator: (value) {
                      if (controller.passController.text.isNotEmpty) {
                        return FormValidators.validateConfirmPassword(
                          value,
                          controller.passController.text,
                        );
                      }
                      return null;
                    },
                    // fontColor: AppColors.color4C4C4C,
                    controller: controller.confirmPassController,
                    filled: true,
                    fillColor: AppColors.textFieldBackground,
                    enabledBorderColor: Colors.transparent,
                    hintText: "Confirm Password",
                    isObscuredText: controller.confirmPasswordObscure.value,
                    prefixIcon: SvgPicture.asset(
                      AppAssets.lockIcon,
                      fit: BoxFit.scaleDown,
                      color: AppColors.color4C4C4C,
                    ),
                    suffixIcon: GestureDetector(
                      onTap:
                          () =>
                      controller.confirmPasswordObscure.value =
                      !controller.confirmPasswordObscure.value,
                      child: Icon(
                        controller.confirmPasswordObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.color4C4C4C,
                      ),
                    ),
                  ),
            ),

            /// COUNTRY FIELD
            _buildCustomTextField(
              hintText: 'Country',
              controller: controller.countryController,
              prefixIconPath: AppAssets.countryIcon,
              validator: (v) => FormValidators.validateRequired(v, 'Country'),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15.w,
              children: [
                Expanded(
                  child: _buildCustomTextField(
                    hintText: 'State',
                    controller: controller.stateController,
                    prefixIconPath: AppAssets.stateIcon,
                    validator:
                        (v) => FormValidators.validateRequired(v, 'State'),
                  ),
                ),
                Expanded(
                  child: _buildCustomTextField(
                    hintText: 'City',
                    controller: controller.cityController,
                    prefixIconPath: AppAssets.cityIcon,
                    validator:
                        (v) => FormValidators.validateRequired(v, 'City'),
                  ),
                ),
              ],
            ),

            /// EXPERIENCE FIELD
            Obx(
              () => CustomDropdown(
                validator: (value) => FormValidators.validateRequired(value, "Position Seeking"),
                hint: "Position Seeking",
                iconPath: AppAssets.cardIcon,
                selectedValue: controller.currentSkillName,
                items:
                    controller.skills
                        .map(
                          (skill) => DropdownMenuItem<String>(
                            value: skill.name,
                            child: Text(skill.name),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  controller.currentSkillName.value = val ?? '';
                  final selected = controller.skills.firstWhereOrNull(
                        (e) => e.name == val,
                  );
                  controller.currentSkillId.value = selected?.id ?? 0;
                },
              ),
            ),
          ],
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
