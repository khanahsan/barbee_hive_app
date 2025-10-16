
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/component/custom_dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'component/hexagon_widget.dart';
import 'controllers/sign_up_employee_controller.dart';

class SignUpEmployeeScreen extends GetView<SignUpEmployeeController> {
  const SignUpEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('AppAssets.uploadImageIcon ${AppAssets.uploadImageIcon}');
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Hero(
          tag: 'gold_line',
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(top: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.r),
                  topRight: Radius.circular(20.0.r),
                ),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18.0),
                    topLeft: Radius.circular(18.0),
                  ),
                ),
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 20.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  spacing: 30.w,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => Get.back(),
                                    ),
                                    Text(
                                      'Sign Up as Employee',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      HexagonProfilePhotoTile(
                                        selectedImage:
                                            controller.selectedImage.value,
                                        imageUrl:
                                            controller
                                                    .profileImageUrl
                                                    .value
                                                    .isNotEmpty
                                                ? controller
                                                    .profileImageUrl
                                                    .value
                                                : null,
                                        onTap:
                                            controller.showImagePickerOptions,
                                      ),
                                      // Obx(
                                      //   () => HexagonAvatar(
                                      //     iconPath: AppAssets.cameraIcon,
                                      //     width: 120.w,
                                      //     height: 120.h,

                                      //     selectedImage:
                                      //         controller.selectedImage.value,
                                      //     imageUrl:
                                      //         controller
                                      //                 .profileImageUrl
                                      //                 .value
                                      //                 .isNotEmpty
                                      //             ? controller
                                      //                 .profileImageUrl
                                      //                 .value
                                      //             : null,
                                      //     onTap:
                                      //         controller.showImagePickerOptions,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                _buildTextField(
                                  context,
                                  'Name',
                                  AppAssets.nameLogo,
                                  controller.nameController,
                                ),
                                SizedBox(height: 15.h),
                                _buildTextField(
                                  context,
                                  'Email Address',
                                  AppAssets.emailLogo,
                                  controller.emailController,
                                ),
                                SizedBox(height: 15.h),
                                _buildTextField(
                                  context,
                                  'Password',
                                  AppAssets.passwordLogo,
                                  controller.passwordController,
                                  isPassword: true,
                                  isPasswordField: true,
                                ),
                                SizedBox(height: 15.h),
                                _buildTextField(
                                  context,
                                  'Confirm Password',
                                  AppAssets.passwordLogo,
                                  controller.confirmPasswordController,
                                  isPassword: true,
                                  isConfirmPasswordField: true,
                                ),
                                SizedBox(height: 15.h),

                                _buildDropdownField(
                                  context,
                                  'Experience',
                                  AppAssets.experienceLogo2,
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
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                                SizedBox(height: 15.h),
                                _buildTextField(
                                  context,
                                  'Country',
                                  AppAssets.countryIcon,
                                  controller.countryController,
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        context,
                                        'State',
                                        AppAssets.stateIcon,
                                        controller.stateController,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: _buildTextField(
                                        context,
                                        'City',
                                        AppAssets.cityIcon,
                                        controller.cityController,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => _buildTextField(
                                    context,
                                    controller.selectedDate.value.isEmpty
                                        ? 'DOB (MM-DD-YYYY)'
                                        : controller.selectedDate.value,
                                    AppAssets.calenderLogo,
                                    controller.dateController,
                                    readOnly: true,
                                    onTap: controller.pickDate,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomDropdownField(
                                        hint: 'Select Gender',
                                        iconPath: AppAssets.genderLogo,
                                        selectedValue:
                                            controller.selectedGender,
                                        onChanged: controller.updateGender,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'Male',
                                            child: Text(
                                              'Male',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Female',
                                            child: Text(
                                              'Female',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomDropdownField(
                                        hint: 'Select Height',
                                        iconPath: AppAssets.heightLogo,
                                        selectedValue:
                                            controller.selectedHeight,
                                        onChanged: controller.updateHeight,
                                        items: [
                                          DropdownMenuItem(
                                            value: '140',
                                            child: Text(
                                              '140 cm',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: '150',
                                            child: Text(
                                              '150 cm',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: '160',
                                            child: Text(
                                              '160 cm',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomDropdownField(
                                        hint: "Select Eye Color",
                                        iconPath: AppAssets.userLogo,
                                        selectedValue:
                                            controller.selectedEyeColor,
                                        onChanged: controller.updateEyeColor,
                                        items:
                                            controller.eyeColors
                                                .asMap()
                                                .entries
                                                .where(
                                                  (entry) =>
                                                      !controller.eyeColors
                                                          .sublist(0, entry.key)
                                                          .map((e) => e.name)
                                                          .contains(
                                                            entry.value.name,
                                                          ),
                                                )
                                                .map(
                                                  (entry) => DropdownMenuItem(
                                                    value: entry.value.name,
                                                    child: Text(
                                                      entry.value.name,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: CustomDropdownField(
                                        hint: 'Select Hair Color',
                                        iconPath: AppAssets.userLogo,
                                        selectedValue:
                                            controller.selectedHairColor,
                                        onChanged: controller.updateHairColor,
                                        items:
                                            controller.hairColors
                                                .asMap()
                                                .entries
                                                .where(
                                                  (entry) =>
                                                      !controller.hairColors
                                                          .sublist(0, entry.key)
                                                          .map((e) => e.name)
                                                          .contains(
                                                            entry.value.name,
                                                          ),
                                                )
                                                .map(
                                                  (entry) => DropdownMenuItem(
                                                    value: entry.value.name,
                                                    child: Text(
                                                      entry.value.name,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                /* SizedBox(height: 15.h),
                        _buildDropdownField(
                          context,
                          'Select Skill',
                          AppAssets.experienceLogo,
                          controller.selectedSkill,
                          controller.updateSkill,
                          items: controller.skills
                              .map((skill) => DropdownMenuItem(
                            value: skill.name,
                            child: Text(
                              skill.name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                              .toList(),
                        ),*/
                                SizedBox(height: 15.h),
                                Obx(
                                  () => DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      dashPattern: [6, 3],
                                      color: AppColors.textFieldTextColor,
                                      strokeWidth: 2,
                                      radius: const Radius.circular(12),
                                    ),
                                    child: GestureDetector(
                                      onTap: controller.pickResume,
                                      child: Container(
                                        width: double.infinity,
                                        height: 55.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          controller.selectedResume.value ==
                                                  null
                                              ? 'Upload Resume/Certification (PDF)'
                                              : 'Selected: ${controller.selectedResume.value!.path.split('/').last}',
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
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.toggleCheckbox();
                                        },
                                        child: Container(
                                          width: 20.w,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.grey,
                                              width: 2.w,
                                            ),
                                            color:
                                                controller.isChecked.value
                                                    ? AppColors.primary
                                                    : Colors.transparent,
                                          ),
                                          child:
                                              controller.isChecked.value
                                                  ? Icon(
                                                    Icons.check,
                                                    size: 15.sp,
                                                    color: Colors.white,
                                                  )
                                                  : null,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'I agree to the Terms of Service',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                CustomBtn(
                                  btnTitle: 'Create Account',
                                  buttonHeight: 50.h,
                                  btnBackgroundColor: AppColors.primary,
                                  btnTxtColor: Colors.white,
                                  buttonWidth: double.infinity,
                                  onPressed:
                                      () => controller.registerEmployee(),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String hint,
    String icon,
    TextEditingController textController, {
    bool isPassword = false,
    bool isPasswordField = false,
    bool isConfirmPasswordField = false,
    bool readOnly = false, // Added
    void Function()? onTap, // Added
  }) {
    return GetBuilder<SignUpEmployeeController>(
      builder:
          (controller) => TextField(
            controller: textController,
            obscureText:
                isPassword
                    ? (isPasswordField
                        ? !controller.isPasswordVisible.value
                        : isConfirmPasswordField
                        ? !controller.isConfirmPasswordVisible.value
                        : false)
                    : false,
            readOnly: readOnly, // Added
            onTap: onTap, // Added
            style: const TextStyle(color: AppColors.textFieldTextColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textFieldTextColor),
              prefixIcon: Image.asset(
                icon,
                color: AppColors.textFieldTextColor,
                scale: 4.0.h,
              ),
              suffixIcon:
                  isPassword
                      ? Obx(
                        () => IconButton(
                          icon: Icon(
                            (isPasswordField &&
                                        controller.isPasswordVisible.value) ||
                                    (isConfirmPasswordField &&
                                        controller
                                            .isConfirmPasswordVisible
                                            .value)
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textFieldTextColor,
                          ),
                          onPressed: () {
                            if (isPasswordField) {
                              controller.togglePasswordVisibility();
                            } else if (isConfirmPasswordField) {
                              controller.toggleConfirmPasswordVisibility();
                            }
                          },
                        ),
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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Image.asset(
              iconPath,
              color: AppColors.textFieldTextColor,
              width: 20.w,
              height: 20.h,
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
                      fontSize: 18.sp,
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

// class HexagonClipper extends CustomClipper<Path> {
//   final double borderOffset;
//
//   HexagonClipper({this.borderOffset = 0.0});
//
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     final width = size.width;
//     final height = size.height;
//     final centerX = width / 2;
//     final centerY = height / 2;
//     final radius = (width / 2) + borderOffset;
//
//     for (int i = 0; i < 6; i++) {
//       final angle = (60 * i - 30) * 3.1415926535897932 / 180;
//       final x = centerX + radius * cos(angle);
//       final y = centerY + radius * sin(angle);
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }
