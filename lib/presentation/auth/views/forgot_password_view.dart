import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/custom_select_role_widget.dart';
import '../../../infrastructure/widgets/custom_text_field.dart';
import '../../../infrastructure/widgets/reset_password_dialog.dart';
import '../controllers/auth.controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  // Method to show the dialog
  void showResetPasswordDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return ResetPasswordDialog(email: email);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
                  child:  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 10.h,
                      children: [
                        SizedBox(height: 10.h),
                        CustomTextField(
                          hint: 'Email address',
                          icon: AppAssets.nameLogo,
                          controller: controller.nameController,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: '* ',
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                text: 'We Will send you a message to set or reset your new password',
                                style: TextStyle(
                                  color: AppColors.textFieldTextColor,
                                  fontSize: 14.0.sp, // Match CustomText style
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 60.h),
                        CustomBtn(
                          btnTitle: 'Send Code',
                          btnBackgroundColor: AppColors.primary,
                          btnTxtColor: Colors.white,
                          width: double.infinity,
                          onPressed: () {
                            showResetPasswordDialog(context, 'abc@gmail.com');
                          },
                        ),

                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
