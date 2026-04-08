import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/services/logout_service.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/signIn/controller/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class CustomDrawerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> drawerScaleAnimation;
  late Animation<double> dashboardStackScaleAnimation;

  final isDrawerOpen = false.obs;
  final isAnimated = false.obs;
  final userName = ''.obs;
  final userProfileImage = ''.obs;
  int? role;
  RxInt currentIndex = 0.obs;
  RxnInt currentJobID = RxnInt();


  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments != null) {
      final args = Get.arguments;
      currentIndex.value = args['index'] ?? 0;
      currentJobID.value = args['jobId'];
      // currentIndex.value = Get.arguments;
    }

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 600),
      vsync: this,
    );

    offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Off-screen right
      end: Offset.zero, // Center
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: isDrawerOpen.value ? Curves.easeIn : Curves.easeInOut,
      ),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    drawerScaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    dashboardStackScaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();

    final jobId = currentJobID.value;
    if (jobId != null) {
      Get.toNamed(
        Routes.applicationsScreen,
        arguments: {'jobId': jobId},
      );

      // reset to avoid duplicate navigation
      currentJobID.value = null;
    }
  }


  Future<void> toggleDrawer() async {
    // Toggle drawer state
    if (isDrawerOpen.value) {
      animationController.duration = const Duration(
        milliseconds: 600,
      ); // faster close
      animationController.reverse();
    } else {
      animationController.duration = const Duration(
        milliseconds: 600,
      ); // normal open
      animationController.forward();
    }

    if (isDrawerOpen.value) {
      await Future.delayed(Duration(milliseconds: 600));
    }
    isDrawerOpen.value = !isDrawerOpen.value;
    //isAnimated.value = !isAnimated.value;  // Toggle drawer state
  }

  // Future<void> logout() async {
  //   // Show loading dialog
  //   Get.dialog<void>(
  //     Center(
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10.r),
  //           color: AppColors.colorFFFFFF,
  //         ),
  //         child: Column(
  //           spacing: 20.h,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             CircularProgressIndicator(color: AppColors.colorE4A74C),
  //             const CustomText(
  //               title: 'Signing Out..',
  //               fontSize: 16,
  //               fontWeight: FontWeight.w500,
  //               color: AppColors.color000000,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  //
  //   try {
  //     // 🔄 Use Function 2 API call
  //     await AuthApi.logout();
  //
  //     // 🔐 Clear tokens (from Function 2)
  //     await TokenStorage.clearToken();
  //     await SharedPreferenceHelper.remove(SharedPrefKeys.userRole);
  //     await SharedPreferenceHelper.remove(SharedPrefKeys.authToken);
  //     await SharedPreferenceHelper.remove(SharedPrefKeys.userId);
  //     await SharedPreferenceHelper.remove(SharedPrefKeys.userProfileImage);
  //     await SharedPreferenceHelper.remove(SharedPrefKeys.userName);
  //     await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
  //     ApiService.clearToken();
  //
  //     // Refresh sign-in fields to reflect saved credentials after logout
  //     // if (Get.isRegistered<SignInController>()) {
  //     //   Get.find<SignInController>().refreshSavedCredentials();
  //     // }// close dialog
  //
  //     // 🟢 Success
  //     // Utilities.showSnackBar(
  //     //   message: "Logged out successfully",
  //     //   title: 'Sign Out',
  //     //   isSuccess: true,
  //     // );
  //
  //     Get.back<void>();
  //
  //     // navigate
  //     Get.offAllNamed<void>(Routes.SIGN_IN_VIEW);
  //   } catch (e) {
  //     Get.back<void>(); // close dialog
  //
  //     // Clean error message (from Function 2)
  //     String errorMessage = e.toString().replaceFirst(
  //       'Exception: POST request error: Exception: ',
  //       '',
  //     );
  //     errorMessage =
  //     errorMessage.startsWith('Exception: ')
  //         ? errorMessage.replaceFirst('Exception: ', '')
  //         : errorMessage;
  //
  //     // 🔴 Error
  //     Utilities.showSnackBar(
  //       message: errorMessage,
  //       title: 'Error',
  //       isSuccess: false,
  //     );
  //   }
  // }

  Future<void> logout() async {
    await LogoutService.logout();
  }

  Future<void> loadUserData() async {
    final currentUserName = SharedPreferenceHelper.getString(
      SharedPrefKeys.userName,
    );
    final currentProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );
    role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);

    userName.value = currentUserName ?? "";
    userProfileImage.value = currentProfileImage ?? "";
  }

  @override
  void onClose() {
    userName.value = '';
    userProfileImage.value = '';
    animationController.dispose();
    super.onClose();
  }
}
