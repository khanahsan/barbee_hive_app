import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/controller/apply_screen_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_btn.dart';
import '../../../../infrastructure/widgets/custom_dialog.dart';
import '../../../../infrastructure/widgets/custom_dropdown.dart';

class ApplyScreen extends GetView<ApplyScreenController> {
  final int? jobId;
  final String? profileImage;

  const ApplyScreen({
    required this.jobId,
    required this.profileImage,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        showHexagon: false,
        leadingIconPath: AppAssets.backIcon,
        context: context,
        title: '',
        titleWidget: SvgPicture.asset(
          AppAssets.appIconTwo,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
        ), leadingTapFunction: () => Get.back(),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Obx(
        () => Stack(
          children: [
            // Top Image
            Positioned(
              left: 0.w,
              right: 0.w,
              top: -20.h,
              child: SizedBox(
                height: 320.h,
                child: _buildProfileImage(),
              ),
            ),

            // Top Bar
            // Positioned(
            //   top: 1.h,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     padding: EdgeInsets.only(
            //       left: 15.w,
            //       right: 15.w,
            //       top: 50.h,
            //       bottom: 15.h,
            //     ),
            //     decoration: BoxDecoration(
            //       color: AppColors.color101010,
            //       borderRadius: BorderRadius.vertical(
            //         bottom: Radius.circular(22.r),
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         GestureDetector(
            //           onTap: () => Navigator.of(context).pop(),
            //           child: Icon(
            //             Icons.arrow_back,
            //             color: AppColors.colorFFFFFF,
            //             size: 25.sp,
            //           ),
            //         ),
            //         Text(
            //           "Apply",
            //           style: Theme.of(context).textTheme.titleSmall?.copyWith(
            //             fontSize: 24.sp,
            //             fontWeight: FontWeight.w600,
            //             color: AppColors.colorFFFFFF,
            //           ),
            //         ),
            //         SizedBox.shrink(),
            //       ],
            //     ),
            //   ),
            // ),

            // Bottom Form
            Positioned(
              bottom: 0.h,
              left: 0.w,
              right: 0.w,
              child: Container(
                height: 532.h,
                margin: EdgeInsets.only(top: 20.h),
                padding: EdgeInsets.only(top: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.colorFF8600,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18.0),
                      topLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          reverse: false,
                          padding: EdgeInsets.only(
                            top: 30.h,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 18.h,
                              children: [
                                _dropdownField(
                                  validator:
                                      (value) => FormValidators.validateRequired(
                                        value,
                                        "Experience Level",
                                      ),
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
                                _textField(
                                  validator:
                                      (value) => FormValidators.validateRequired(
                                        value,
                                        "Years of Experience",
                                      ),
                                  controller: controller.yearsOfExperience,
                                  hintText: "Years of Experience",
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.calenderIcon,
                                    height: 15.h,
                                    width: 15.w,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(2),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                _textField(
                                  validator:
                                      (value) => FormValidators.validateRequired(
                                        value,
                                        "Expected Salary",
                                      ),
                                  controller: controller.expectedSalary,
                                  hintText: "Expected Salary",
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.cashIcon,
                                    height: 15.h,
                                    width: 15.w,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
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
                                //SizedBox(height: 10.h),



                              ],
                            ),
                          ),
                        ),
                      ),
                //      Spacer(),
                      CustomBtn(
                        btnTitle: 'Submit Now',
                        buttonHeight: 50.h,
                        btnBackgroundColor: AppColors.colorFF8600,
                        btnTxtColor: Colors.white,
                        buttonWidth: double.infinity,
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            if (jobId != null) {
                              controller.applyForJob(jobId!, context);
                            } else {
                              Get.snackbar(
                                'Error',
                                'Job ID is missing',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Loading Overlay
            if (controller.isLoading.value)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.colorFF8600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final rawUrl = profileImage?.trim();
    final normalizedUrl =
        (rawUrl == null || rawUrl.isEmpty || rawUrl.toLowerCase() == 'null')
            ? null
            : rawUrl;
    final uri = normalizedUrl == null ? null : Uri.tryParse(normalizedUrl);
    final isNetwork =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (!isNetwork) {
      return Image.asset(
        AppAssets.profileImage,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: normalizedUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.colorFF8600,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        AppAssets.profileImage,
        fit: BoxFit.cover,
      ),
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
    List<TextInputFormatter>? inputFormatter,
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
      inputFormatters: inputFormatter,
    );
  }
}
