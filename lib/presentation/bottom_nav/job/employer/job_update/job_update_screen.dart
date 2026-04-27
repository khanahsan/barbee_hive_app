import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_update/controller/job_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/utils/form_validators.dart';
import '../../../../../infrastructure/widgets/app_text_field.dart';
import '../../../../../infrastructure/widgets/custom_dropdown.dart';

class JobUpdateScreen extends GetView<JobUpdateController> {
  const JobUpdateScreen({super.key});

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
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(AppAssets.logo, width: 200.w),
                SizedBox(height: 10.h),

                // ORANGE TOP + BLACK CONTAINER (OLD DESIGN)
                Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.only(top: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.colorFF8600,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),

                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.r),
                          topRight: Radius.circular(18.r),
                        ),
                      ),

                      child: Column(
                        spacing: 15.h,
                        children: [
                          SizedBox(height: 20.h),

                          // Job Role
                          _dropdownField(
                            hint: 'Select Job Role',
                            iconPath: AppAssets.personIcon,
                            selectedValue: controller.selectedSkill,
                            items:
                                controller.skills
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.name,
                                        child: Text(
                                          e.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: controller.updateSkill,
                          ),

                          // Experience Level
                          _dropdownField(
                            hint: 'Select Experience Level',
                            iconPath: AppAssets.experienceLevel,
                            selectedValue: controller.selectedExperienceLevel,
                            items:
                                controller.experienceLevels
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.name,
                                        child: Text(
                                          e.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: controller.updateExperienceLevel,
                          ),

                          // Min & Max Salary
                          Row(
                            spacing: 10.w,
                            children: [
                              Expanded(
                                child: _textField(
                                  hintText: 'Min Salary',
                                  controller: controller.minSalaryController,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.salary,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  validator:
                                      (v) => FormValidators.validateSalary(
                                        v,
                                        "Min Salary",
                                      ),
                                ),
                              ),
                              Expanded(
                                child: _textField(
                                  hintText: 'Max Salary',
                                  controller: controller.maxSalaryController,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.salary,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  validator:
                                      (v) => FormValidators.validateSalary(
                                        v,
                                        "Max Salary",
                                        isMinField: false,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          /// Salary Type
                          _dropdownField(
                            validator:
                                (value) => FormValidators.validateRequired(
                                  value,
                                  "Salary Type",
                                ),
                            hint: 'Select Salary Type',
                            iconPath: AppAssets.salaryLogo,
                            selectedValue: controller.selectedSalaryType,
                            onChanged: controller.updateSalaryType,
                            items:
                                controller.salaryTypes
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

                          // Country
                          _dropdownField(
                            hint: 'Select Country',
                            iconPath: AppAssets.countryIcon,
                            selectedValue: controller.selectedCountry,
                            items:
                                controller.countries
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.name,
                                        child: Text(
                                          e.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: controller.updateCountry,
                          ),

                          // State + City
                          Row(
                            children: [
                              Expanded(
                                child: _dropdownField(
                                  hint: 'Select State',
                                  iconPath: AppAssets.stateIcon,
                                  selectedValue: controller.selectedState,
                                  items:
                                      controller.states
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.name,
                                              child: Text(
                                                e.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: controller.updateState,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Obx(() {
                                  if (controller.isCitiesLoading.value) {
                                    return AppShimmer(
                                      height: 56,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(10),
                                    );
                                  }

                                  return _dropdownField(
                                    validator:
                                        (value) =>
                                            FormValidators.validateRequired(
                                              value,
                                              "City",
                                            ),
                                    hint: 'City',
                                    iconPath: AppAssets.cityIcon,
                                    selectedValue: controller.selectedCity,
                                    onChanged: controller.updateCity,
                                    items:
                                        controller.cities
                                            .map(
                                              (city) => DropdownMenuItem(
                                                value: city.name,
                                                child: Text(
                                                  city.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  );
                                }),
                              ),
                            ],
                          ),

                          // Recruiter
                          _textField(
                            hintText: 'Recruiter',
                            controller: controller.recruiterController,
                            prefixIcon: SvgPicture.asset(
                              AppAssets.personTwoIcon,
                              fit: BoxFit.scaleDown,
                            ),
                            validator:
                                (v) => FormValidators.validateRequired(
                                  v,
                                  "Recruiter",
                                ),
                          ),

                          _textField(
                            hintText: controller.selectedImageName,
                            controller: TextEditingController(),
                            prefixIcon: SvgPicture.asset(
                              AppAssets.imagePlusIcon,
                              fit: BoxFit.scaleDown,
                            ),
                            readOnly: true,
                            suffixIcon: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => controller.pickImage(context),
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
                                child: const Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    color: AppColors.colorFFFFFF,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          _dropdownField(
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

                          // Job Description
                          _textField(
                            hintText: 'Job Description',
                            controller: controller.jobDesController,
                            maxLines: 4,
                            validator:
                                (v) => FormValidators.validateRequired(
                                  v,
                                  "Job Description",
                                ),
                          ),
                          SizedBox(height: 10.h),

                          // Submit Button
                          Obx(
                            () => CustomBtn(
                              btnTitle: 'Submit Now',
                              buttonHeight: 50.h,
                              btnBackgroundColor: AppColors.colorFF8600,
                              btnTxtColor: Colors.white,
                              buttonWidth: double.infinity,
                              onPressed: () => controller.updateJob(context),
                              isLoading: controller.isLoading.value,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
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

  /// Dropdown
  Widget _dropdownField({
    required String hint,
    required String iconPath,
    required RxString selectedValue,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
    Color? backgroundColor,
    String? Function(String?)? validator,
  }) {
    return CustomDropdown(
      textColor: AppColors.colorFFFFFF,
      hint: hint,
      iconPath: iconPath,
      selectedValue: selectedValue,
      onChanged: onChanged,
      items: items,
      validator: validator,
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
  }) {
    return AppTextField(
      fontColor: AppColors.colorFFFFFF,
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
    );
  }
}
