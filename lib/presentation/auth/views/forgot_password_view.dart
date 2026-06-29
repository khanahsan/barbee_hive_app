import 'package:barbee_hive_app/presentation/auth/controllers/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/form_validators.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/app_text_field.dart';
import '../controllers/auth.controller.dart';

class ForgotPasswordView extends GetView<ForgetPasswordController> {
  const ForgotPasswordView({super.key});


  @override
  Widget build(BuildContext context) {
    //controller.fEmailController.text = "employee11@gmail.com";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body:  SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              reverse: true, // scroll to bottom when keyboard opens
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.minHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.logo,
                        width: 200.w,
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        padding: EdgeInsets.only(top: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.colorFF8600,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(18.r),
                              topLeft: Radius.circular(18.r),
                            ),
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  validator: FormValidators.validateEmail,
                                  hintText: 'Email Address',
                                  focusNode: controller.focusNode,
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.envelopeIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  controller: controller.fEmailController,
                                  fillColor: AppColors.color101010,
                                  filled: true,
                                  enabledBorderColor: Colors.transparent,
                                  fontColor: AppColors.color4C4C4C,
                                ),
                                SizedBox(height: 20.h),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: '* ',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      TextSpan(
                                        text:
                                        'We will send you a message to reset your\n\t\t\tnew password',
                                        style: TextStyle(
                                          color: AppColors.colorFFFFFF,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                Obx(
                                      () => CustomBtn(
                                    buttonHeight: 55.h,
                                    btnTitle: 'Send Code',
                                    btnBackgroundColor: AppColors.colorFF8600,
                                    btnTxtColor: AppColors.colorFFFFFF,
                                    onPressed: () {
                                      if (controller.formKey.currentState!.validate()) {
                                        controller.forgotPassword(context);
                                      }
                                    },
                                    isLoading: controller.fPasswordIsLoading.value,
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 20.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
