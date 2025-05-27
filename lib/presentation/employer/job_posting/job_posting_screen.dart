import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/presentation/employer/job_posting/controller/job_posting_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/widgets/custom_btn.dart';

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
              Image.asset(
                AppAssets.logo,
                width: 200.w,
                //height: 120.h,
              ),
              SizedBox(height: 10.h),

              Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
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
                        borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
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
                          icon: AppAssets.emailLogo,
                          controller.experienceLevelController,
                        ),
                        _buildTextField(
                          context,
                          'Salary',
                          icon: AppAssets.passwordLogo,
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
                                icon: AppAssets.cityIcon,
                                controller.cityController,
                              ),
                            ),
                          ],
                        ),
                        _buildTextField(
                          context,
                          'Recruiter',
                          icon: AppAssets.countryIcon,
                          controller.recruiterController,
                        ),
                        _buildDropdownField(
                          context,
                          'Job Type',
                          AppAssets.heightLogo,
                          controller.selectedJobType,
                          controller.updateJobType,
                          items: const [
                            DropdownMenuItem(
                              value: 'part-time',
                              child: Text('Part Time', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'full-time',
                              child: Text('Full Time', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        _buildTextField(
                          context,
                          'Job Description',
                          controller.stateController,
                          maxLine: 3,
                        ),
                        Obx(
                              () => DottedBorder(
                                options: RectDottedBorderOptions(
                                  dashPattern: [6, 3],
                                ),
                            // color: AppColors.textFieldTextColor,
                            // strokeWidth: 2,
                            // borderType: BorderType.RRect,
                            // radius: const Radius.circular(12),
                            // dashPattern: const [5, 5],
                            child: GestureDetector(
                              onTap: controller.pickImage,
                              child: Container(
                                width: double.infinity,
                                height: 55.h,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.selectedImage.value == null
                                      ? 'Upload Image'
                                      : 'Selected: ${controller.selectedImage.value!.path.split('/').last}',
                                  style: TextStyle(
                                    color: AppColors.textFieldTextColor,
                                    fontSize: 14.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 15.h),
                        CustomBtn(
                          btnTitle: 'Submit Now',
                          buttonHeight: 50.h,
                          btnBackgroundColor: AppColors.primary,
                          btnTxtColor: Colors.white,
                          buttonWidth: double.infinity,
                          onPressed: () {},
                        ),
                        SizedBox(height: 20.h),
                      ],
                    )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTextField(
      BuildContext context,
      String hint,
      TextEditingController textController,
      {
        String? icon,
        bool readOnly = false, // Added
        void Function()? onTap, // Added
        int? maxLine,
      }
      ) {
    return GetBuilder<JobPostingController>(
      builder: (controller) => TextField(
        maxLines: maxLine ?? 1,
        controller: textController,
        readOnly: readOnly, // Added
        onTap: onTap, // Added
        style: const TextStyle(color: AppColors.textFieldTextColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textFieldTextColor),
          prefixIcon: icon != null && icon.isNotEmpty // Check if icon is valid
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
      ),
    );
  }

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
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Image.asset(
              iconPath,
              color: AppColors.textFieldTextColor,
              width: 16.w,
              height: 16.h,
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
                  value: selectedValue.value.isEmpty ? null : selectedValue.value,
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

