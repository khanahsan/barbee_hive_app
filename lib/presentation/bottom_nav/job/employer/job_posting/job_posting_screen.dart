/*
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(AppAssets.logo, width: 200.w),
              SizedBox(height: 10.h),
              Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorFF8600,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.r),
                      topRight: Radius.circular(20.0.r),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.h),

                          /// Job Role Field
                          Obx(
                            () => CustomDropdown(
                              validator:
                                  (value) => FormValidators.validateRequired(
                                    value,
                                    "Job Role",
                                  ),
                              hint: 'Select Job Role',
                              iconPath: AppAssets.personIcon,
                              selectedValue: controller.selectedSkill,
                              onChanged: controller.updateSkill,
                              items:
                                  controller.skills
                                      .map(
                                        (skill) => DropdownMenuItem(
                                          value: skill.name,
                                          child: Text(
                                            skill.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          SizedBox(height: 15.h),

                          /// Experience Level Field
                          Obx(
                            () => CustomDropdown(
                              validator:
                                  (value) => FormValidators.validateRequired(
                                    value,
                                    "Experience Level",
                                  ),
                              hint: 'Select Experience Level',
                              iconPath: AppAssets.experienceLevel,
                              selectedValue: controller.selectedExperienceLevel,
                              onChanged: controller.updateExperienceLevel,
                              items:
                                  controller.experienceLevels
                                      .map(
                                        (exp) => DropdownMenuItem(
                                          value: exp.name,
                                          child: Text(
                                            exp.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          SizedBox(height: 15.h),

                          /// Min & Max Salary Field
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10.w,
                            children: [
                              Expanded(
                                child: _buildAppField(
                                  validator:
                                      (value) => FormValidators.validateSalary(
                                        value,
                                        "Min Salary",
                                      ),
                                  controller: controller.minSalaryController,
                                  hintText: 'Min Salary',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.salary,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _buildAppField(
                                  validator:
                                      (value) => FormValidators.validateSalary(
                                        value,
                                        "Max Salary",
                                        isMinField: false,
                                      ),
                                  controller: controller.maxSalaryController,
                                  hintText: 'Max Salary',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.salary,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),

                          /// Country Field
                          _buildAppField(
                            validator:
                                (value) => FormValidators.validateRequired(
                                  value,
                                  "Country",
                                ),
                            controller: controller.countryController,
                            hintText: 'Country',
                            prefixIcon: SvgPicture.asset(
                              AppAssets.countryIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(height: 15.h),

                          /// State & City Field
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10.w,
                            children: [
                              Expanded(
                                child: _buildAppField(
                                  validator:
                                      (value) =>
                                          FormValidators.validateRequired(
                                            value,
                                            "State",
                                          ),
                                  controller: controller.stateController,
                                  hintText: 'State',
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.stateIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _buildAppField(
                                  validator:
                                      (value) =>
                                          FormValidators.validateRequired(
                                            value,
                                            "City",
                                          ),
                                  controller: controller.cityController,
                                  hintText: 'City',
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.cityIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),

                          /// Recruiter Field
                          _buildAppField(
                            validator:
                                (value) => FormValidators.validateRequired(
                                  value,
                                  "Recruiter",
                                ),
                            controller: controller.recruiterController,
                            hintText: 'Recruiter',
                            prefixIcon: SvgPicture.asset(
                              AppAssets.personTwoIcon,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(height: 15.h),

                          _buildAppField(
                            controller: TextEditingController(
                            ),
                            hintText:
                                controller.selectedImage.value != null
                                    ? 'Selected: ${controller.selectedImage.value!.path.split('/').last}'
                                    : 'Upload Image',

                            prefixIcon: SvgPicture.asset(
                              AppAssets.imagePlusIcon,
                              fit: BoxFit.scaleDown,
                            ),
                            readOnly: true,
                            suffixIcon: GestureDetector(
                              onTap: controller.pickImage,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 15.h,
                                  horizontal: 10.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: CustomText(
                                  title: "Upload Image",
                                  color: AppColors.colorFFFFFF,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),

                          /// Job Type Field
                          Obx(
                            () => CustomDropdown(
                              validator:
                                  (value) => FormValidators.validateRequired(
                                    value,
                                    "Job Type",
                                  ),
                              hint: 'Job Type',
                              iconPath: AppAssets.cardIcon,
                              selectedValue: controller.selectedJobType,
                              onChanged: controller.updateJobType,
                              items:
                                  controller.jobTypes
                                      .map(
                                        (job) => DropdownMenuItem(
                                          value: job.name,
                                          child: Text(
                                            job.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),

                          SizedBox(height: 15.h),

                          /// Job Description Field
                          _buildAppField(
                            validator:
                                (value) => FormValidators.validateRequired(
                                  value,
                                  "Job Description",
                                ),
                            controller: controller.jobDesController,
                            hintText: 'Job Description',
                            maxLines: 4,
                          ),
                          SizedBox(height: 15.h),

                          Obx(
                            () => CustomBtn(
                              btnTitle: 'Submit Now',
                              buttonHeight: 50.h,
                              btnBackgroundColor: AppColors.colorFF8600,
                              btnTxtColor: Colors.white,
                              buttonWidth: double.infinity,
                              onPressed: () {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  controller.postJob(context);
                                }
                              },
                              isLoading: controller.isLoading.value,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppField({
    required TextEditingController controller,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      validator: validator,
      controller: controller,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: keyboardType,
      maxLines: maxLines,
      isTapAble: !readOnly,
      readOnly: readOnly,
      fillColor: AppColors.textFieldBackground,
    );
  }
}
*/


import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
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

        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(AppAssets.logo, width: 200.w),
                SizedBox(height: 10.h),
                Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.only(top: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.colorFF8600,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0.r),
                        topRight: Radius.circular(20.0.r),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.r),
                          topRight: Radius.circular(18.r),
                        ),
                      ),
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
                              hint: 'Select Experience Level',
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
                                      value, "Salary Country"),
                              hint: 'Select Country',
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
                                      hint: 'Select State',
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
