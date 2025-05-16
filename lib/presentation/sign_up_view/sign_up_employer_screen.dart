import 'package:barbee_hive_app/presentation/sign_up_view/sign_up_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/custom_text_field.dart';
import 'controllers/sign_up_employer_controller.dart';

class SignUpEmployerScreen extends GetView<SignUpEmployerController> {
  const SignUpEmployerScreen({super.key});

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
                child: Obx(
                    () => controller.isLoading.value
                    ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 15.h,
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
                                'Sign Up as Employer',
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
                          // _buildTextField(context, 'Name', AppAssets.nameLogo, controller.nameController),
                          CustomTextField(
                            hint: 'Business Name',
                            icon: AppAssets.nameLogo,
                            controller: controller.nameController,
                          ),
                          // _buildTextField(context, 'Email Address', AppAssets.emailLogo, controller.emailController),
                          CustomTextField(
                            hint: 'Email Address',
                            icon: AppAssets.emailLogo,
                            controller: controller.emailController,
                          ),
                          /*_buildTextField(context, 'Password', AppAssets.passwordLogo, controller.passwordController,
                          isPassword: true, isPasswordField: true),*/
                          Obx(() => CustomTextField(
                            hint: 'Password',
                            icon: AppAssets.passwordLogo,
                            controller: controller.passwordController,
                            isPassword: true,
                            isObscured: !controller.isPasswordVisible.value,
                            onToggleVisibility: controller.togglePasswordVisibility,
                          )),
                          /*_buildTextField(context, 'Confirm Password', AppAssets.passwordLogo, controller.confirmPasswordController,
                          isPassword: true, isConfirmPasswordField: true),*/
                          Obx(() => CustomTextField(
                            hint: 'Confirm Password',
                            icon: AppAssets.passwordLogo,
                            controller: controller.confirmPasswordController,
                            isPassword: true,
                            isObscured: !controller.isConfirmPasswordVisible.value,
                            onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                          )),

                          CustomTextField(
                            hint: 'Country',
                            icon:AppAssets.countryIcon,
                            controller: controller.countryController,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(

                                  hint: 'State',
                                  icon: AppAssets.stateIcon,
                                  controller: controller.stateController,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: CustomTextField(
                                  hint: 'City',
                                  icon: AppAssets.cityIcon,
                                  controller:  controller.cityController,
                                ),
                              ),
                            ],
                          ),
                          _buildDropdownField(
                            context,
                            'Position Seeking',
                            AppAssets.experienceLogo,
                            controller.selectedSkill,
                            controller.updateSkill,
                            items: controller.skills
                                .asMap()
                                .entries
                                .where((entry) => !controller.skills
                                .sublist(0, entry.key)
                                .map((e) => e.name)
                                .contains(entry.value.name))
                                .map((entry) => DropdownMenuItem(
                              value: entry.value.name,
                              child: Text(
                                entry.value.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                                .toList(),
                          ),
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
                                      color: controller.isChecked.value ? AppColors.primary : Colors.transparent,
                                    ),
                                    child: controller.isChecked.value
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
                            onPressed: () => controller.register(),
                          ),
                          /*CustomBtn(
                        buttonHeight: 50,
                        btnTitle: 'Create Account',
                        btnBackgroundColor: Colors.orange,
                        btnTxtColor: Colors.white,
                        buttonWidth: double.infinity,
                        onPressed: controller.isChecked.value
                            ? () {
                          // Add your sign-up logic here
                          print("Create Account button pressed");
                        }
                            : () {
                          print("Please agree to the Terms of Service");
                        },
                      ),*/
                          SizedBox(height: 20.h),
                        ],
                      ),
                    )
                ),
              ),
            ),
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
