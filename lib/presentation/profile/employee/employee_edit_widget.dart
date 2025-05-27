import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_dropdown.dart';
import '../../../infrastructure/widgets/custom_textfield.dart';

class EmployeeEditWidget extends StatelessWidget {
  EmployeeEditWidget({super.key});

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
              value: controller.currentSkillName.value,
              hintText: "Experience",
              items: controller.skills.map((e) => e.name).toList(),
              onChanged: (val) {
                controller.currentSkillName.value = val ?? '';

                final selected = controller.skills.firstWhereOrNull(
                  (e) => e.name == val,
                );
                controller.currentSkillId.value = selected?.id ?? 0;
              },
            ),
            _buildCustomTextField(
              hintText: "MM/DD/YYYY",
              controller: controller.dobController,
              // prefixIconPath: AppAssets.lockIcon,
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 20.w,
              children: [
                Obx(
                  () => Expanded(
                    child: CustomDropdown(
                      value: controller.currentGender.value,
                      hintText: "Gender",
                      items: controller.genderList,

                      onChanged: (val) {
                        controller.currentGender.value = val ?? '';
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Expanded(
                    child: CustomDropdown(
                      value: controller.currentHeight.value.toString(),
                      hintText: "Height",
                      items:
                          controller.heightList
                              .map((e) => e.toString())
                              .toList(),
                      onChanged: (val) {
                        controller.currentHeight.value =
                            int.tryParse(val ?? '') ?? 0;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 20.w,
              children: [
                Obx(
                  () => Expanded(
                    child: CustomDropdown(
                      value: controller.currentEyeColorName.value,
                      hintText: "Eye Color",
                      items: controller.eyeColors.map((e) => e.name).toList(),
                      onChanged: (val) {
                        controller.currentEyeColorName.value = val ?? '';
                        final selected = controller.eyeColors.firstWhereOrNull(
                          (e) => e.name == val,
                        );
                        controller.currentEyeColorId.value = selected?.id ?? 0;

                        debugPrint(
                          "${controller.currentEyeColorName.value} ${controller.currentEyeColorId.value}",
                        );
                      },
                    ),
                  ),
                ),
                Obx(
                  () => Expanded(
                    child: CustomDropdown(
                      value: controller.currentHairColorName.value,
                      hintText: "Hair Color",
                      items: controller.hairColors.map((e) => e.name).toList(),
                      onChanged: (val) {
                        controller.currentHairColorName.value = val ?? '';
                        final selected = controller.hairColors.firstWhereOrNull(
                          (e) => e.name == val,
                        );
                        controller.currentHairColorId.value = selected?.id ?? 0;

                        debugPrint(
                          "${controller.currentHairColorName.value} ${controller.currentHairColorId.value}",
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            _buildDottedBorder(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDottedBorder(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(13.r),
        // borderRadius: BorderRadius.circular(12.r), // Add your desired radius
        dashPattern: [6, 3],
        strokeWidth: 1.5,
        color: AppColors.color4C4C4C,
      ),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
          color: AppColors.textFieldBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          "Upload Resume/Certification",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 16.sp,
            color: AppColors.color4C4C4C,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    String? prefixIconPath,
    String? suffixIconPath,
  }) {
    return CustomTextField(
      fontColor: AppColors.color4C4C4C,
      controller: controller,
      filled: true,
      fillColor: AppColors.textFieldBackground,
      enabledBorderColor: Colors.transparent,
      hintText: hintText,
      prefixIcon:
          prefixIconPath != null
              ? SvgPicture.asset(
                prefixIconPath,
                fit: BoxFit.scaleDown,
                color: AppColors.color4C4C4C,
              )
              : null,
      suffixIcon:
          suffixIconPath != null
              ? SvgPicture.asset(
                suffixIconPath,
                fit: BoxFit.scaleDown,
                color: AppColors.color4C4C4C,
              )
              : null,
    );
  }
}
