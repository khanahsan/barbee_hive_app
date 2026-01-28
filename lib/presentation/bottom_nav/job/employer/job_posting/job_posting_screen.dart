


import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/widgets/custom_dropdown.dart';
import 'controller/job_posting_controller.dart';

class JobPostingScreen extends GetView<JobPostingController> {
  const JobPostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Get.back(),
      //   ),
      // ),
      appBar: customAppbar(
        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
        context: context,
        leadingTapFunction: () => Get.back(),
        showActions: true,
        title: '',
        titleWidget: SvgPicture.asset(
          AppAssets.appIconTwo,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        return Column(
          children: [
            /// WHERE HIRING HAPPENS Banner (Fixed at top)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.r), bottomLeft: Radius.circular(25.r)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.colorFF8600.withOpacity(0.8),
                    AppColors.colorFF8600.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'WHERE HIRING ',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.colorFF8600,
                          ),
                        ),
                        TextSpan(
                          text: 'HAPPENS',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.colorFFFFFF,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'See all your posted shifts, track applicants, and launch new jobs\nall in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.colorC2C2C2,
                    ),
                  ),
                ],
              ),
            ),
            /// Scrollable Form Fields
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      /// Job Role
                      _dropdownField(
                        validator: (value) =>
                            FormValidators.validateRequired(
                                value, "Job Role"),
                        hint: 'Select Job Role',
                        iconPath: AppAssets.personIcon,
                        selectedValue: controller.selectedSkill,
                        onChanged: controller.updateSkill,
                        items: controller.skills
                            .map(
                              (skill) =>
                              DropdownMenuItem(
                                value: skill.name,
                                child: Text(
                                  skill.name,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                        )
                            .toList(),
                      ),
                      SizedBox(height: 15.h),

                      /// Experience Level
                      _dropdownField(
                        validator: (value) =>
                            FormValidators.validateRequired(
                                value, "Experience Level"),
                        hint: 'Experience Level',
                        iconPath: AppAssets.experienceLevel,
                        selectedValue: controller.selectedExperienceLevel,
                        onChanged: controller.updateExperienceLevel,
                        items: controller.experienceLevels
                            .map(
                              (exp) =>
                              DropdownMenuItem(
                                value: exp.name,
                                child: Text(
                                  exp.name,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                        )
                            .toList(),
                      ),
                      SizedBox(height: 15.h),

                      /// Salary
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.w,
                        children: [
                          Expanded(
                            child: _textField(
                              hintText: 'Min Salary',
                              controller: controller.minSalaryController,
                              keyboardType: TextInputType.number,
                              prefixIcon: SvgPicture.asset(
                                  AppAssets.salary,
                                  fit: BoxFit.scaleDown),
                              validator: (v) =>
                                  FormValidators.validateSalary(
                                      v, "Min Salary"),
                            ),
                          ),
                          Expanded(
                            child: _textField(
                              hintText: 'Max Salary',
                              controller: controller.maxSalaryController,
                              keyboardType: TextInputType.number,
                              prefixIcon: SvgPicture.asset(
                                  AppAssets.salary,
                                  fit: BoxFit.scaleDown),
                              validator: (v) =>
                                  FormValidators.validateSalary(
                                      v, "Max Salary", isMinField: false),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),

                      /// Salary Type
                      _dropdownField(
                        validator: (value) =>
                            FormValidators.validateRequired(
                                value, "Salary Type"),
                        hint: 'Select Salary Type',
                        iconPath: AppAssets.salaryLogo,
                        selectedValue: controller.selectedSalaryType,
                        onChanged: controller.updateSalaryType,
                        items: controller.salaryTypes
                            .map(
                              (exp) =>
                              DropdownMenuItem(
                                value: exp.name,
                                child: Text(
                                  exp.name,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                        )
                            .toList(),
                      ),
                      SizedBox(height: 15.h),
                      //
                      // _textField(
                      //   hintText: 'Select Country',
                      //   controller: controller.cityController,
                      //   enabled: false,
                      //   prefixIcon: SvgPicture.asset(
                      //       AppAssets.cityIcon,
                      //       fit: BoxFit.scaleDown),
                      //
                      // ),


                      /// Country
                      _dropdownField(
                        validator: (value) =>
                            FormValidators.validateRequired(
                                value, "Country"),
                        hint: 'Country',
                        iconPath: AppAssets.countryIcon,
                        selectedValue: controller.selectedCountry,
                        onChanged: (value){
                          print("value : $value");
                          controller.updateCountry(value);
                        },
                        items: controller.countries
                            .map(
                              (exp) =>
                              DropdownMenuItem(
                                value: exp.name,
                                child: Text(
                                  exp.name,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                        )
                            .toList(),
                      ),
                      // _textField(
                      //   hintText: 'Country',
                      //   controller: controller.countryController,
                      //   prefixIcon: SvgPicture.asset(
                      //       AppAssets.countryIcon, fit: BoxFit.scaleDown),
                      //   validator: (v) =>
                      //       FormValidators.validateRequired(v, "Country"),
                      // ),
                      SizedBox(height: 15.h),

                      /// State & City
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.w,
                        children: [
                          Expanded(
                            child: Obx(() {
                              return _dropdownField(
                                validator: (value) =>
                                    FormValidators.validateRequired(
                                        value, "State"),
                                hint: 'State',
                                iconPath: AppAssets.stateIcon,
                                selectedValue: controller.selectedState,
                                onChanged: controller.updateState,
                                items: controller.states
                                    .map(
                                      (exp) =>
                                      DropdownMenuItem(
                                        value: exp.name,
                                        child: Text(
                                          exp.name,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                )
                                    .toList(),
                              );
                            }),
                          ),
                          // Expanded(
                          //   child: _textField(
                          //     hintText: 'State',
                          //     controller: controller.stateController,
                          //     prefixIcon: SvgPicture.asset(
                          //         AppAssets.stateIcon,
                          //         fit: BoxFit.scaleDown),
                          //     validator: (v) =>
                          //         FormValidators.validateRequired(
                          //             v, "State"),
                          //   ),
                          // ),
                          Expanded(
                            child: _textField(
                              hintText: 'City',
                              controller: controller.cityController,
                              prefixIcon: SvgPicture.asset(
                                  AppAssets.cityIcon,
                                  fit: BoxFit.scaleDown),
                              validator: (v) =>
                                  FormValidators.validateRequired(
                                      v, "City"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),

                      /// Recruiter
                      _textField(
                        hintText: 'Recruiter',
                        controller: controller.recruiterController,
                        prefixIcon: SvgPicture.asset(
                            AppAssets.personTwoIcon,
                            fit: BoxFit.scaleDown),
                        validator: (v) =>
                            FormValidators.validateRequired(
                                v, "Recruiter"),
                      ),
                      SizedBox(height: 15.h),

                      /// Upload Image
                      _textField(
                        hintText: controller.selectedImage.value != null
                            ? 'Selected: ${controller.selectedImage.value!
                            .path
                            .split('/')
                            .last}'
                            : 'Upload Image',
                        controller: TextEditingController(),
                        prefixIcon: SvgPicture.asset(
                            AppAssets.imagePlusIcon,
                            fit: BoxFit.scaleDown),
                        readOnly: true,
                        suffixIcon: GestureDetector(
                          onTap: () => controller.pickImage(context),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 10.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: const Text(
                              "Upload Image",
                              style: TextStyle(
                                  color: AppColors.colorFFFFFF,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      /// Job Type
                      _dropdownField(
                        validator: (value) =>
                            FormValidators.validateRequired(
                                value, "Job Type"),
                        hint: 'Job Type',
                        iconPath: AppAssets.cardIcon,
                        selectedValue: controller.selectedJobType,
                        onChanged: controller.updateJobType,
                        items: controller.jobTypes
                            .map(
                              (job) =>
                              DropdownMenuItem(
                                value: job.name,
                                child: Text(job.name,
                                    style: const TextStyle(
                                        color: Colors.white)),
                              ),
                        )
                            .toList(),
                      ),
                      SizedBox(height: 15.h),

                      /// Job Description
                      _textField(
                        hintText: 'Job Description',
                        controller: controller.jobDesController,
                        maxLines: 4,
                        validator: (v) =>
                            FormValidators.validateRequired(
                                v, "Job Description"),
                      ),
                      SizedBox(height: 15.h),

                      /// Submit Button
                      Obx(
                            () =>
                            CustomBtn(
                              btnTitle: 'Submit Now',
                              buttonHeight: 50.h,
                              btnBackgroundColor: AppColors.colorFF8600,
                              btnTxtColor: Colors.white,
                              buttonWidth: double.infinity,
                              onPressed: () {
                                controller.postJob(context);
                                // if (controller.formKey.currentState!
                                //     .validate()) {
                                //
                                // }
                              },
                              isLoading: controller.isLoading.value,
                            ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 15.w),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Reusable Text Field
  Widget _textField({
    required String hintText,
    required TextEditingController controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    String? Function(String?)? validator,
    bool? enabled,
  }) {
    return AppTextField(
      textInputAction: TextInputAction.done,
      controller: controller,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: keyboardType,
      maxLines: maxLines,
      isTapAble: !readOnly,
      readOnly: readOnly,
      validator: validator,
      fillColor: AppColors.textFieldBackground,
      enabled: enabled,

    );
  }

  /// Reusable Dropdown Field
  Widget _dropdownField({
    required String hint,
    required String iconPath,
    required RxString selectedValue,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
    double? fontSize,
    double? iconSize,
    double? borderRadius,
    Color? backgroundColor,
    Color? textColor,
    Color? dropdownColor,
    String? Function(String?)? validator,
  }) {
    return CustomDropdown(
      hint: hint,
      iconPath: iconPath,
      selectedValue: selectedValue,
      onChanged: onChanged,
      items: items,
      fontSize: fontSize,
      iconSize: iconSize,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      textColor: textColor,
      dropdownColor: dropdownColor,
      validator: validator,
    );
  }

}
