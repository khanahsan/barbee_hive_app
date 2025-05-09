import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/custom_dialog.dart';
import '../../../infrastructure/widgets/custom_textfield.dart';
import '../controllers/auth.controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  // Method to show the dialog
  void showResetPasswordDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          email: email,
          title: "Reset Password",
          subTitle: "A link to reset your password has been send to",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.logo,
                width: 200.w,
                //height: 120.h,
              ),
              SizedBox(height: 30.h),

              Container(
                padding: EdgeInsets.only(top: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0.r),
                    topRight: Radius.circular(20.0.r),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18.0),
                      topLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // spacing: 10.h,
                    children: [
                      CustomTextField(
                        hintText: 'Email Address',
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
                                  'We Will send you a message to set or reset your\n\t\t\tnew password',
                              style: TextStyle(
                                color: AppColors.textFieldTextColor,
                                fontSize: 15.sp, // Match CustomText style
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
                          btnBackgroundColor: AppColors.primary,
                          btnTxtColor: AppColors.white,
                          onPressed: () => controller.forgotPassword(),
                          isLoading: controller.fPasswordIsLoading.value,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20.w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
