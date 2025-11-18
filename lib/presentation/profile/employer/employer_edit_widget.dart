/*
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';
import '../../../infrastructure/widgets/app_text_field.dart';

class EmployerEditWidget extends StatelessWidget {
  EmployerEditWidget({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15.h,
          children: [
            _buildCustomTextField(
              hintText: "Name",
              controller: controller.nameController,
              prefixIconPath: AppAssets.editIcon,
            ),
            _buildCustomTextField(
              hintText: "Email Address",
              controller: controller.emailController,
              prefixIconPath: AppAssets.envelopeIcon,
            ),
            _buildCustomTextField(
              hintText: "Password",
              controller: controller.passController,
              prefixIconPath: AppAssets.lockIcon,
            ),
            _buildCustomTextField(
              hintText: "Confirm Password",
              controller: controller.confirmPassController,
              prefixIconPath: AppAssets.lockIcon,
            ),
            CustomDropdown(
              prefixIconPath: AppAssets.experienceIcon,
              value: controller.selectedExperience.value,
              hintText: "Experience",
              items: controller.experienceList,
              onChanged: (val) {
                controller.selectedExperience.value = val ?? '';
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required String prefixIconPath,
  }) {
    return CustomTextField(
      fontColor: AppColors.color4C4C4C,
      controller: controller,
      filled: true,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      hintText: hintText,
      prefixIcon: SvgPicture.asset(
        prefixIconPath,
        fit: BoxFit.scaleDown,
        color: AppColors.color4C4C4C,
      ),
    );
  }
}
*/

import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/app_text_field.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';

class EmployerEditWidget extends GetView<ProfileController> {
  const EmployerEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15.h,
          children: [
            /// NAME FIELD
            _buildCustomTextField(
              hintText: "Name",
              controller: controller.nameController,
              prefixIconPath: AppAssets.editIcon,
            ),

            /// EMAIL FIELD
            _buildCustomTextField(
              hintText: "Email Address",
              controller: controller.emailController,
              prefixIconPath: AppAssets.envelopeIcon,
            ),

            /// PASSWORD FIELD
            _buildCustomTextField(
              hintText: "Password",
              controller: controller.passController,
              prefixIconPath: AppAssets.lockIcon,
            ),

            /// CONFIRM PASSWORD FIELD
            _buildCustomTextField(
              hintText: "Confirm Password",
              controller: controller.confirmPassController,
              prefixIconPath: AppAssets.lockIcon,
            ),

            /// EXPERIENCE FIELD
            Obx(
              () => CustomDropdown(
                hint: "Experience",
                iconPath: AppAssets.cardIcon,
                selectedValue: controller.currentSkillName,
                items:
                    controller.skills
                        .map(
                          (skill) => DropdownMenuItem<String>(
                            value: skill.name,
                            child: Text(skill.name),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  controller.currentSkillName.value = val ?? '';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required String prefixIconPath,
  }) {
    return AppTextField(
      fontColor: AppColors.color4C4C4C,
      controller: controller,
      filled: true,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      hintText: hintText,
      prefixIcon: SvgPicture.asset(
        prefixIconPath,
        fit: BoxFit.scaleDown,
        color: AppColors.color4C4C4C,
      ),
    );
  }
}
