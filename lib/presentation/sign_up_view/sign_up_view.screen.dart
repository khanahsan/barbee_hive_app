import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'controllers/sign_up_view.controller.dart';

class HexagonClipper extends CustomClipper<Path> {
  final double borderOffset;

  HexagonClipper({this.borderOffset = 0.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double offset = borderOffset;

    path.moveTo(width * 0.5, offset); // Top center
    path.lineTo(width - offset, height * 0.25 + offset); // Top right
    path.lineTo(width - offset, height * 0.75 - offset); // Bottom right
    path.lineTo(width * 0.5, height - offset); // Bottom center
    path.lineTo(offset, height * 0.75 - offset); // Bottom left
    path.lineTo(offset, height * 0.25 + offset); // Top left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SignUpViewScreen extends GetView<SignUpViewController> {
  const SignUpViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
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
                            ClipPath(
                              clipper: HexagonClipper(borderOffset: -2.w),
                              child: Container(
                                width: 124.w,
                                height: 124.h,
                                color: AppColors.primary,
                              ),
                            ),
                            ClipPath(
                              clipper: HexagonClipper(),
                              child: Container(
                                width: 120.w,
                                height: 120.h,
                                color: Colors.black,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.cameraLogo,
                                      color: AppColors.grey,
                                      height: 25.0.h,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Upload Photo',
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                      _buildTextField(
                        context,
                        'Experience',
                        AppAssets.experienceLogo,
                        controller.experienceController,
                      ),
                      SizedBox(height: 15.h),
                      _buildTextField(
                        context,
                        'MM/DD/YYYY',
                        AppAssets.calenderLogo,
                        controller.dateController,
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              context,
                              'Select Gender',
                              AppAssets.genderLogo,
                              controller.selectedGender,
                              controller.updateGender,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildDropdownField(
                              context,
                              'Select Height',
                              AppAssets.heightLogo,
                              controller.selectedHeight,
                              controller.updateHeight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              context,
                              'Select Eye Color',
                              AppAssets.userLogo,
                              controller.selectedEyeColor,
                              controller.updateEyeColor,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildDropdownField(
                              context,
                              'Select Hair Color',
                              AppAssets.userLogo,
                              controller.selectedHairColor,
                              controller.updateHairColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      DottedBorder(
                        color: AppColors.textFieldTextColor,
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        dashPattern: const [5, 5],
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Center(
                            child: Text(
                              'Upload Resume/Certification ',
                              style: TextStyle(
                                color: AppColors.textFieldTextColor,
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
                        btnBackgroundColor: AppColors.primary,
                        btnTxtColor: Colors.white,
                        buttonWidth: double.infinity,
                        onPressed:
                            controller.isChecked.value
                                ? () {
                                  // Add your sign-up logic here
                                  print("Create Account button pressed");
                                }
                                : () {
                                  print("Please agree to the Terms of Service");
                                },
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
  }) {
    return GetBuilder<SignUpViewController>(
      builder:
          (controller) => TextField(
            controller: textController,
            obscureText:
                isPassword
                    ? (isPasswordField
                        ? !controller
                            .isPasswordVisible
                            .value // Text hidden when isPasswordVisible is false
                        : isConfirmPasswordField
                        ? !controller
                            .isConfirmPasswordVisible
                            .value // Text hidden when isConfirmPasswordVisible is false
                        : false)
                    : false,
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
                                ? Icons
                                    .visibility_off_outlined // Show when text is visible
                                : Icons.visibility_outlined,
                            // Show when text is hidden
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
    Function(String?) onChanged,
  ) {
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
                  items: const [
                    DropdownMenuItem(
                      value: 'Option 1',
                      child: Text(
                        'Option 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Option 2',
                      child: Text(
                        'Option 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: onChanged,
                  value:
                      selectedValue.value.isEmpty ? null : selectedValue.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
