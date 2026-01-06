import 'dart:io';

import 'package:barbee_hive_app/data/api/firebase/firebase_service.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_select_role_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';

class SelectRoleView extends StatelessWidget {
  const SelectRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    // State management for selected role
    final RxString selectedRole = ''.obs;

    Future<void> _handleGoogleContinue() async {
      if (selectedRole.value.isEmpty) {
        Utilities.showSnackBar(
          title: 'Select Role',
          message: 'Please select Employee or Employer first',
          isSuccess: false,
        );
        return;
      }

      try {
        final tokenResult = await FirebaseService.signInWithGoogleTokensOnly();
        if (tokenResult == null) return;

        final googleUser = tokenResult.account;
        final signUpArgs = {
          'name': googleUser.displayName ?? '',
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl ?? '',
          'googleAccessToken': tokenResult.authentication.accessToken ?? '',
          'googleIdToken': tokenResult.authentication.idToken ?? '',
        };

        if (selectedRole.value == 'employee') {
          Get.toNamed(Routes.SIGN_UP_VIEW, arguments: signUpArgs);
        } else {
          Get.toNamed(Routes.SIGN_UP_EMPLOYER, arguments: signUpArgs);
        }
      } catch (e) {
        Utilities.showSnackBar(
          title: 'Google Sign-In Failed',
          message: 'Please try again. $e',
          isSuccess: false,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            // Logo
            SvgPicture.asset(
              AppAssets.appIcon,
              width: 85.w,
              height: 85.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 40.h),

            // Main content container
            Container(
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18.0),
                    topLeft: Radius.circular(18.0),
                  ),
                ),
                child: Column(
                  children: [
                    // Title
                    const Text(
                      'Choose an account type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Role selection cards
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomSelectRoleWidget(
                            iconPath: AppAssets.employeeLogo,
                            onTap: () {
                              selectedRole.value = 'employee';
                            },
                            btnText: 'Employee',
                            isSelected: selectedRole.value == 'employee',
                          ),
                          CustomSelectRoleWidget(
                            iconPath: AppAssets.employerLogo,
                            onTap: () {
                              selectedRole.value = 'employer';
                            },
                            btnText: 'Employer',
                            isSelected: selectedRole.value == 'employer',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Continue with Email button
                    Obx(
                      () => CustomBtn(
                        buttonHeight: 55.h,
                        btnTitle: "Continue With Email",
                        btnBackgroundColor: AppColors.color000000,
                        borderColor: AppColors.colorFFFFFF,
                        btnTxtColor: AppColors.colorFFFFFF,
                        iconPath: AppAssets.emailLogo,
                        iconColor: AppColors.colorFFFFFF,
                        onPressed:
                            selectedRole.value.isEmpty
                                ? () {
                                  // Show message to select a role first
                                  Utilities.showSnackBar(
                                    title: 'Select Role',
                                    message:
                                        'Please select Employee or Employer first',
                                    isSuccess: false,
                                  );
                                }
                                : () {
                                  if (selectedRole.value == 'employee') {
                                    Get.toNamed(Routes.SIGN_UP_VIEW);
                                  } else {
                                    Get.toNamed(Routes.SIGN_UP_EMPLOYER);
                                  }
                                },
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Continue with Google button
                    Obx(
                      () => CustomBtn(
                        buttonHeight: 55.h,
                        btnTitle: "Continue With Google",
                        btnBackgroundColor: AppColors.color000000,
                        borderColor: AppColors.colorFFFFFF,
                        btnTxtColor: AppColors.colorFFFFFF,
                        iconPath: AppAssets.googleLogo,
                        onPressed:
                            selectedRole.value.isEmpty
                                ? () {
                                  Utilities.showSnackBar(
                                    title: 'Select Role',
                                    message:
                                        'Please select Employee or Employer first',
                                    isSuccess: false,
                                  );
                                }
                                : _handleGoogleContinue,
                      ),
                    ),
                    if(Platform.isIOS)...[
                      SizedBox(height: 15.h),

                      // Continue with Apple button
                      // Obx(
                      //       () => CustomBtn(
                      //     buttonHeight: 55.h,
                      //     btnTitle: "Continue With Apple",
                      //     btnBackgroundColor: AppColors.color000000,
                      //     borderColor: AppColors.colorFFFFFF,
                      //     btnTxtColor: AppColors.colorFFFFFF,
                      //     iconPath: AppAssets.appleLogo,
                      //     onPressed:
                      //     selectedRole.value.isEmpty
                      //         ? () {
                      //       Utilities.showSnackBar(
                      //         title: 'Select Role',
                      //         message:
                      //         'Please select Employee or Employer first',
                      //         isSuccess: false,
                      //       );
                      //     }
                      //         : () {
                      //       // TODO: Implement Apple Sign-In for registration
                      //       Get.snackbar(
                      //         'Coming Soon',
                      //         'Apple Sign-Up will be available soon',
                      //         backgroundColor: AppColors.colorFF8600,
                      //         colorText: Colors.white,
                      //         snackPosition: SnackPosition.BOTTOM,
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
