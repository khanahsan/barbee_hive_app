import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/utils/form_validators.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dropdown.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/feedbackSupport/controller/feedback_support_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class FeedbackSupportScreen extends GetView<FeedbackSupportController> {
  const FeedbackSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color000000,
      appBar: customAppbar(
        leadingTapFunction: () => Get.back(),
        showHexagon: false,
        context: context,
        leadingIconPath: AppAssets.backIcon,
        title: 'Feedback & Support',
      ),
      body: Obx(
        () => controller.isLoading.value
            ? _buildShimmerLoading()
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    spacing: 25.h,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Select Type Field
                      _selectTypeField(controller),

                      //Message Field
                      _messageField(controller),

                      //Submit Button
                      Obx(() {
                        return CustomBtn(
                          isLoading: controller.isSubmitLoading.value,
                          btnTitle: "Submit",
                          btnBackgroundColor: AppColors.colorFF8600,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          buttonHeight: 50.h,
                          borderRadius: 15.r,
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.feedbackSupport();
                            }
                          },
                        );
                      }),

                      //Cancel Button
                  /*    CustomBtn(
                        btnTxtColor: AppColors.colorA3A3A3,
                        btnTitle: 'Cancel',
                        btnBackgroundColor: AppColors.color000000,
                        borderColor: AppColors.colorFF8600,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        buttonHeight: 50.h,
                        borderRadius: 15.r,
                        onPressed: () {
                          Get.back<void>();
                        },
                      ),*/
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _selectTypeField(FeedbackSupportController controller) {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomText(
          title: 'Select Type',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.colorFFFFFF,
        ),
        Obx(
          () => CustomDropdown(
            hint: 'Select Type',
            selectedValue: controller.selectedType,
            onChanged: controller.selectType,
            items: controller.typeOptions
                .map(
                  (contactType) => DropdownMenuItem<String>(
                    value: contactType.id,
                    child: Text(contactType.name),
                  ),
                )
                .toList(),
            fontSize: 17.sp,
            borderRadius: 12.r,
            backgroundColor: AppColors.color000000,
            textColor: AppColors.colorFFFFFF,
            dropdownColor: AppColors.colorFF8600,
            borderColor: AppColors.colorA3A3A3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a type';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _messageField(FeedbackSupportController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Title
        const CustomText(
          title: 'Message',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.colorFFFFFF,
        ),

        //Message Field
        AppTextField(
          controller: controller.messageController,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 10.h,
          ),
          textAlignVertical: TextAlignVertical.center,
          hintText: '',
          fontColor: AppColors.colorFFFFFF,
          fillColor: AppColors.color000000,
          enabledBorderColor: AppColors.colorFFFFFF,
          fontSize: 15.sp,
          maxLines: 7,
          textInputAction: TextInputAction.done,
          fontWeight: FontWeight.w400,
          validator:
              (String? value) =>
                  FormValidators.validateRequired(value, 'Message'),
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      child: Column(
        spacing: 25.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Type Field Shimmer
          Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer(
                height: 20,
                width: 100,
                borderRadius: BorderRadius.circular(5.r),
              ),
              AppShimmer(
                height: 55,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ],
          ),

          // Message Field Shimmer
          Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer(
                height: 20,
                width: 80,
                borderRadius: BorderRadius.circular(5.r),
              ),
              AppShimmer(
                height: 200,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ],
          ),

          // Submit Button Shimmer
          AppShimmer(
            height: 50,
            width: double.infinity,
            borderRadius: BorderRadius.circular(15.r),
          ),

          // Cancel Button Shimmer
          AppShimmer(
            height: 50,
            width: double.infinity,
            borderRadius: BorderRadius.circular(15.r),
          ),
        ],
      ),
    );
  }
}
