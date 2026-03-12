import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/model/height_response.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/app_text_field.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';
import '../../../infrastructure/widgets/custom_multi_select_dropdown.dart';
import '../../../infrastructure/widgets/custom_resume_widget.dart';
import '../../../infrastructure/widgets/custom_app_shimmer.dart';

class EmployeeEditWidget extends GetView<ProfileController> {
  const EmployeeEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
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


              /// SKILLS FIELD
              CustomMultiSelectDropdown(
                hint: 'Skills',
                iconPath: AppAssets.cardIcon,
                selectedValues: controller.selectedSkills,
                items: controller.skills.map((s) => s.name).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select at least one experience";
                  }
                  return null;
                },
              ),

              /// EXPERIENCE LEVEL FIELD
              CustomDropdown(
                validator:
                    (value) =>
                        FormValidators.validateRequired(value, "Experience"),
                hint: "Experience Level",
                iconPath: AppAssets.cardIcon,
                selectedValue: controller.selectedExperience,
                items:
                    controller.experienceLevels
                        .map(
                          (level) => DropdownMenuItem<String>(
                            value: level.name,
                            child: Text(level.name),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  controller.selectedExperience.value = val ?? '';
                },
              ),


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
                      enableSearch: true,
                      searchHint: "Search state",
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
                        enableSearch: true,
                        searchHint: "Search city",
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
              //   validator: (v) => FormValidators.validateRequired(v, 'Address'),
              // ),

              /// DOB FIELD
              GestureDetector(
                onTap: () => controller.pickDate(),
                child: AbsorbPointer(
                  child: _buildCustomTextField(
                    hintText: "MM/DD/YYYY",
                    controller: controller.dobController,
                    suffixIconPath: AppAssets.calendarIcon,
                    validator: (value) => FormValidators.validateAge(value),
                    readOnly: true,
                  ),
                ),
              ),

              /// GENDER & HEIGHT FIELD
              Row(
                spacing: 20.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(() {
                      return CustomDropdown(
                        validator:
                            (value) =>
                                FormValidators.validateRequired(value, "Gender"),
                        hint: "Gender",
                        iconPath: AppAssets.genderLogo,
                        selectedValue: controller.currentGender,
                        // use id
                        items:
                            controller.genders.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender.id, // use id, not name
                                child: Text(gender.name),
                              );
                            }).toList(),
                        onChanged: (val) {
                          controller.currentGender.value = val ?? '';
                        },
                      );
                    }),
                  ),

                  Expanded(
                    child: Obx(() {
                      return CustomDropdown(
                        validator:
                            (value) =>
                                FormValidators.validateRequired(value, "Height"),
                        hint: "Height",
                        iconPath: AppAssets.heightLogo,
                        selectedValue:
                            controller.currentHeight.value == 0
                                ? ''.obs
                                : controller.heights
                                    .firstWhere(
                                      (height) =>
                                          height.id ==
                                          controller.currentHeight.value,
                                    )
                                    .name
                                    .obs,
                        items:
                            controller.heights.map((height) {
                              return DropdownMenuItem<String>(
                                value: height.name,
                                child: Text(height.name),
                              );
                            }).toList(),
                        onChanged: (val) {
                          // Set currentHeight as int from selected name
                          final selectedHeight =
                              controller.heights
                                  .firstWhere(
                                    (height) => height.name == val,
                                    orElse: () => Height(id: 0, name: ''),
                                  )
                                  .id;
                          controller.currentHeight.value = selectedHeight;
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
      // fontColor: AppColors.color4C4C4C,
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
