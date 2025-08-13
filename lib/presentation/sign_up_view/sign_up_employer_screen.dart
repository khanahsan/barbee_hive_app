import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/custom_text_field.dart';
import 'component/agree_terms_tile.dart';
import 'component/custom_dropdown.dart';
import 'component/profile_photo_tile.dart';
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
                  () =>
                      controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
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

                                //Profile Photo Tile
                                ProfilePhotoTile(),

                                //Business Name Field
                                CustomTextField(
                                  hint: 'Business Name',
                                  icon: AppAssets.nameLogo,
                                  controller: controller.nameController,
                                ),

                                //Email Address Field
                                CustomTextField(
                                  hint: 'Email Address',
                                  icon: AppAssets.emailLogo,
                                  controller: controller.emailController,
                                ),

                                //Password Field
                                Obx(
                                  () => CustomTextField(
                                    hint: 'Password',
                                    icon: AppAssets.passwordLogo,
                                    controller: controller.passwordController,
                                    isPassword: true,
                                    isObscured:
                                        !controller.isPasswordVisible.value,
                                    onToggleVisibility:
                                        controller.togglePasswordVisibility,
                                  ),
                                ),

                                //Confirm Password Field
                                Obx(
                                  () => CustomTextField(
                                    hint: 'Confirm Password',
                                    icon: AppAssets.passwordLogo,
                                    controller:
                                        controller.confirmPasswordController,
                                    isPassword: true,
                                    isObscured:
                                        !controller
                                            .isConfirmPasswordVisible
                                            .value,
                                    onToggleVisibility:
                                        controller
                                            .toggleConfirmPasswordVisibility,
                                  ),
                                ),

                                //Country Field
                                CustomTextField(
                                  hint: 'Country',
                                  icon: AppAssets.countryIcon,
                                  controller: controller.countryController,
                                ),

                                //State and City Field
                                Row(
                                  spacing: 10.w,
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        hint: 'State',
                                        icon: AppAssets.stateIcon,
                                        controller: controller.stateController,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomTextField(
                                        hint: 'City',
                                        icon: AppAssets.cityIcon,
                                        controller: controller.cityController,
                                      ),
                                    ),
                                  ],
                                ),

                                //Position Seeking Field
                                CustomDropdownField(
                                  hint: 'Position Seeking',

                                  iconPath: AppAssets.experienceLogo,

                                  selectedValue: controller.selectedSkill,
                                  onChanged: controller.updateSkill,
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
                                AgreeTermsTile(),
                                SizedBox(height: 30.h),

                                //Create Account Button
                                CustomBtn(
                                  btnTitle: 'Create Account',
                                  buttonHeight: 50.h,
                                  btnBackgroundColor: AppColors.primary,
                                  btnTxtColor: Colors.white,
                                  buttonWidth: double.infinity,
                                  onPressed: () => controller.register(),
                                ),
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
}
