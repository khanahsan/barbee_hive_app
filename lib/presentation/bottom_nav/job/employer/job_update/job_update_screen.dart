import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_update/controller/job_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(AppAssets.logo, width: 200.w),
              SizedBox(height: 10.h),

              // Main Card Container
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
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 15.h,

                      children: [
                        SizedBox(height: 20.h),

                        _buildTextField(
                          context,
                          'Job Role',
                          icon: AppAssets.nameLogo,
                          controller.jobRoleController,
                        ),
                        _buildTextField(
                          context,
                          'Experience Level',
                          icon: AppAssets.experienceLogo,
                          controller.experienceLevelController,
                        ),
                        _buildTextField(
                          context,
                          'Salary',
                          icon: AppAssets.salaryLogo,
                          controller.salaryController,
                        ),
                        _buildTextField(
                          context,
                          'Country',
                          icon: AppAssets.countryIcon,
                          controller.countryController,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                context,
                                'State',
                                icon: AppAssets.stateIcon,
                                controller.stateController,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _buildTextField(
                                context,
                                'City',
                                icon: AppAssets.locationLogo,
                                controller.cityController,
                              ),
                            ),
                          ],
                        ),
                        _buildTextField(
                          context,
                          'Recruiter',
                          icon: AppAssets.recruiterLogo,
                          controller.recruiterController,
                        ),

                        // Job Type Dropdown
                        _buildDropdownField(
                          context,
                          'Job Type',
                          AppAssets.heightLogo,
                          controller.selectedJobType,
                          controller.updateJobType,
                          items: const [
                            DropdownMenuItem(
                              value: 'part-time',
                              child: Text(
                                'Part Time',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'full-time',
                              child: Text(
                                'Full Time',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        // Position Seeking Dropdown
                        Obx(
                          () => _buildDropdownField(
                            context,
                            'Position Seeking',
                            AppAssets.jobtyprLogo,
                            controller.selectedSkill,
                            controller.updateSkill,
                            items:
                                controller.skills
                                    .asMap()
                                    .entries
                                    .where(
                                      (entry) =>
                                          !controller.skills
                                              .sublist(0, entry.key)
                                              .map((e) => e.name)
                                              .contains(entry.value.name),
                                    )
                                    .map(
                                      (entry) => DropdownMenuItem(
                                        value: entry.value.name,
                                        child: Text(
                                          entry.value.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),

                        _buildTextField(
                          context,
                          'Job Description',
                          controller.jobDesController,
                          maxLine: 3,
                        ),

                        // Image Picker
                        // Obx(
                        //   () => DottedBorder(
                        //     options: const RoundedRectDottedBorderOptions(
                        //       dashPattern: [6, 3],
                        //       color: AppColors.textFieldTextColor,
                        //       strokeWidth: 2,
                        //       radius: Radius.circular(12),
                        //     ),
                        //     child: GestureDetector(
                        //       onTap: controller.pickImage,
                        //       child: Container(
                        //         width: double.infinity,
                        //         height: 55.h,
                        //         padding: EdgeInsets.symmetric(horizontal: 10.w),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           controller.selectedImage.value == null
                        //               ? 'Upload Image'
                        //               : 'Selected: ${controller.selectedImage.value!.path.split('/').last}',
                        //           style: TextStyle(
                        //             color: AppColors.textFieldTextColor,
                        //             fontSize: 14.sp,
                        //           ),
                        //           overflow: TextOverflow.ellipsis,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 15.h),

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
      ),
    );
  }

  /// --- Text Field Builder ---
  Widget _buildTextField(
    BuildContext context,
    String hint,
    TextEditingController textController, {
    String? icon,
    bool readOnly = false,
    void Function()? onTap,
    int? maxLine,
  }) {
    return TextField(
      maxLines: maxLine ?? 1,
      controller: textController,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: AppColors.textFieldTextColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textFieldTextColor),
        prefixIcon:
            icon != null && icon.isNotEmpty
                ? Image.asset(
                  icon,
                  color: AppColors.textFieldTextColor,
                  scale: 4.0.h,
                )
                : null,
        filled: true,
        fillColor: AppColors.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// --- Dropdown Builder ---
  Widget _buildDropdownField(
    BuildContext context,
    String hint,
    String iconPath,
    RxString selectedValue,
    Function(String?) onChanged, {
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Image.asset(
              iconPath,
              color: AppColors.textFieldTextColor,
              width: 24.w,
              height: 24.h,
            ),
          ),
          Expanded(
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.grey[900],
                  hint: Text(
                    selectedValue.value.isEmpty ? hint : selectedValue.value,
                    style: TextStyle(
                      color: AppColors.textFieldTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  iconEnabledColor: Colors.grey,
                  items: items,
                  onChanged: onChanged,
                  value:
                      selectedValue.value.isEmpty ? null : selectedValue.value,
                  menuMaxHeight: 300.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
