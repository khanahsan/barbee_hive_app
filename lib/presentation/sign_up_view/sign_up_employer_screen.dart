import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/widgets/app_text_field.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'component/agree_terms_tile.dart';
import 'component/custom_dropdown.dart';
import 'component/hexagon_widget.dart';
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
                color: AppColors.colorFF8600,
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
                                HexagonProfilePhotoTile(
                                  selectedImage: controller.selectedImage.value,
                                  imageUrl:
                                      controller
                                              .profileImageUrl
                                              .value
                                              .isNotEmpty
                                          ? controller.profileImageUrl.value
                                          : null,
                                  onTap: controller.showImagePickerOptions,
                                ),

                                //Business Name Field
                                AppTextField(
                                  hintText: 'Business Name',
                                  prefixIcon: Image.asset(AppAssets.nameLogo),
                                  controller: controller.nameController,
                                ),

                                //Email Address Field
                                AppTextField(
                                  hintText: 'Email Address',
                                  prefixIcon: Image.asset(AppAssets.emailLogo),
                                  controller: controller.emailController,
                                ),

                                //Password Field
                                Obx(
                                  () => AppTextField(
                                    hintText: 'Password',
                                    prefixIcon: Image.asset(
                                      AppAssets.passwordLogo,
                                    ),
                                    controller: controller.passwordController,

                                    isObscuredText:
                                        !controller.isPasswordVisible.value,
                                    suffixIcon: GestureDetector(
                                      onTap:
                                          () =>
                                              controller
                                                  .togglePasswordVisibility,
                                      child: Image.asset(
                                        AppAssets.passwordLogo,
                                      ),
                                    ),
                                  ),
                                ),

                                //Confirm Password Field
                                Obx(
                                  () => AppTextField(
                                    hintText: 'Confirm Password',
                                    prefixIcon: Image.asset(
                                      AppAssets.passwordLogo,
                                    ),
                                    controller:
                                        controller.confirmPasswordController,
                                    isObscuredText:
                                        !controller
                                            .isConfirmPasswordVisible
                                            .value,
                                    suffixIcon: GestureDetector(
                                      onTap:
                                          () =>
                                              controller
                                                  .toggleConfirmPasswordVisibility,
                                      child: Image.asset(
                                        AppAssets.passwordLogo,
                                      ),
                                    ),
                                  ),
                                ),

                                //Country Field
                                AppTextField(
                                  hintText: 'Country',
                                  prefixIcon: Image.asset(
                                    AppAssets.countryLogo,
                                  ),
                                  controller: controller.countryController,
                                ),

                                //State and City Field
                                Row(
                                  spacing: 10.w,
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        hintText: 'State',
                                        prefixIcon: Image.asset(
                                          AppAssets.stateLogo,
                                        ),
                                        controller: controller.stateController,
                                      ),
                                    ),
                                    Expanded(
                                      child: AppTextField(
                                        hintText: 'City',
                                        prefixIcon: Image.asset(
                                          AppAssets.cityLogo,
                                        ),
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
                                  btnBackgroundColor: AppColors.colorFF8600,
                                  btnTxtColor: Colors.white,
                                  buttonWidth: double.infinity,
                                  onPressed:
                                      () => controller.registerEmployer(),
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
