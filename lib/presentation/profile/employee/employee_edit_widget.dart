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
import '../../../infrastructure/widgets/custom_resume_widget.dart';

class EmployeeEditWidget extends GetView<ProfileController> {
  const EmployeeEditWidget({super.key});

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
              validator: FormValidators.validateName,
            ),

            /// EMAIL FIELD
            _buildCustomTextField(
              hintText: "Email Address",
              controller: controller.emailController,
              prefixIconPath: AppAssets.envelopeIcon,
              readOnly: true,
              validator: FormValidators.validateEmail,
            ),

            /// PASSWORD FIELD
            _buildCustomTextField(
              hintText: "Password",
              controller: controller.passController,
              prefixIconPath: AppAssets.lockIcon,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  // Only validate if user typed something
                  return FormValidators.validatePassword(value);
                }
                return null; // empty password is allowed
              },
            ),

            /// CONFIRM PASSWORD FIELD
            _buildCustomTextField(
              hintText: "Confirm Password",
              controller: controller.confirmPassController,
              prefixIconPath: AppAssets.lockIcon,
              validator: (value) {
                if (controller.passController.text.isNotEmpty) {
                  // Only validate if password field is not empty
                  return FormValidators.validateConfirmPassword(
                    value,
                    controller.passController.text,
                  );
                }
                return null; // allow empty confirm password if password is empty
              },
            ),

            /// POSITION FIELD
            CustomDropdown(
              validator:
                  (value) => FormValidators.validateRequired(
                    value,
                    "Position Seeking",
                  ),
              hint: "Position Seeking",
              iconPath: AppAssets.cardIcon,
              selectedValue: controller.currentSkillName,
              items:
                  controller.skills
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.name,
                          child: Text(e.name),
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

            /// DOB FIELD
            _buildCustomTextField(
              hintText: "MM/DD/YYYY",
              controller: controller.dobController,
              suffixIconPath: AppAssets.calendarIcon,
              validator: (value) => FormValidators.validateAge(value),
            ),

            /// GENDER & HEIGHT FIELD
            Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown(
                    validator:
                        (value) =>
                            FormValidators.validateRequired(value, "Gender"),
                    hint: "Gender",
                    iconPath: AppAssets.genderLogo,
                    selectedValue: controller.currentGender,
                    items:
                        controller.genderList
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      controller.currentGender.value = val ?? '';
                    },
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return CustomDropdown(
                      validator:
                          (value) =>
                              FormValidators.validateRequired(value, "Height"),
                      hint: "Height",
                      iconPath: AppAssets.heightLogo,
                      // convert int → string
                      selectedValue:
                          controller.currentHeight.value.toString().obs,
                      items:
                          controller.heightList
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e.toString(),
                                  child: Text(e.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        controller.currentHeight.value =
                            int.tryParse(val ?? '') ?? 0;
                      },
                    );
                  }),
                ),
              ],
            ),

            /// EYE & HAIR COLOR FIELD
            Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown(
                    validator:
                        (value) =>
                            FormValidators.validateRequired(value, "Eye Color"),
                    hint: "Eye Color",
                    iconPath: AppAssets.personIcon,
                    selectedValue: controller.currentEyeColorName,
                    items:
                        controller.eyeColors
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e.name,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      controller.currentEyeColorName.value = val ?? '';
                      final selected = controller.eyeColors.firstWhereOrNull(
                        (e) => e.name == val,
                      );
                      controller.currentEyeColorId.value = selected?.id ?? 0;
                    },
                  ),
                ),
                Expanded(
                  child: CustomDropdown(
                    validator:
                        (value) => FormValidators.validateRequired(
                          value,
                          "Hair Color",
                        ),
                    hint: "Hair Color",
                    iconPath: AppAssets.personIcon,
                    selectedValue: controller.currentHairColorName,
                    items:
                        controller.hairColors
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e.name,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      controller.currentHairColorName.value = val ?? '';
                      final selected = controller.hairColors.firstWhereOrNull(
                        (e) => e.name == val,
                      );
                      controller.currentHairColorId.value = selected?.id ?? 0;
                    },
                  ),
                ),
              ],
            ),

            CustomResumeWidget(
              initialFileName: controller.selectedResumeFilePath.value,
              onFileSelected: (file) {
                controller.selectedResumeFile.value = file;
                controller.selectedResumeFilePath.value =
                    file.path.split('/').last;
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
    String? prefixIconPath,
    String? suffixIconPath,
    bool? readOnly,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      fontSize: 16,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      validator: validator,
      fontColor: AppColors.color4C4C4C,
      controller: controller,
      filled: true,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      hintText: hintText,
      readOnly: readOnly ?? false,
      prefixIcon:
          prefixIconPath != null
              ? SvgPicture.asset(
                prefixIconPath,
                fit: BoxFit.scaleDown,
                color: AppColors.color4C4C4C,
              )
              : null,
      suffixIcon:
          suffixIconPath != null
              ? SvgPicture.asset(
                suffixIconPath,
                fit: BoxFit.scaleDown,
                color: AppColors.color4C4C4C,
              )
              : null,
    );
  }
}
