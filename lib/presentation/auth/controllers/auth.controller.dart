/*
import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/api/firebase/firebase_service.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';
import '../../../infrastructure/widgets/custom_text.dart';

class AuthController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fEmailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxBool rememberMe = false.obs;

  final isLoading = false.obs;
  final fPasswordIsLoading = false.obs;
  final RxBool isObscured = true.obs;

  @override
  void onInit() async {
    super.onInit();
    // fetchDashboardUsers();
    // await LocationService.determinePosition();

    String savedEmail =
        SharedPreferenceHelper.getString(SharedPrefKeys.savedEmail) ?? '';
    String savedPassword =
        SharedPreferenceHelper.getString(SharedPrefKeys.savedPassword) ?? '';

    if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
      nameController.text =
          SharedPreferenceHelper.getString(SharedPrefKeys.savedEmail) ?? "";
      passwordController.text =
          SharedPreferenceHelper.getString(SharedPrefKeys.savedPassword) ?? "";
    }
  }

  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  // Method to show the dialog
  Future<void> showResetPasswordDialog(
    BuildContext context,
    String email,
  ) async {
    print('Showing reset password dialog for email: $email'); // Debug log
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          email: email,
          title: "Reset Password",
          subTitle: "A link to reset your password has been sent to",
        );
      },
    );
  }

  Future<void> login() async {
    final email = nameController.text.trim();
    final password = passwordController.text.trim();

    isLoading.value = true;

    try {
      print('Attempting login with email: $email');
      final response = await AuthApi.login(email, password);
      print('Login Response: $response');
      TokenStorage.saveToken(response.token);

      /// SAVE USER ROLE
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userRole,
        response.user.role,
      );

      /// SAVE AUTH TOKEN
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.authToken,
        response.token,
      );

      /// SAVE USER ID
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userId,
        response.user.id,
      );

      /// SAVE USER PROFILE
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userProfileImage,
        response.user.profileImage ?? '',
      );

      /// SAVE USER NAME
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userName,
        response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
      );

      if (rememberMe.value) {
        await SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedEmail,
          email,
        );

        await SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedPassword,
          password,
        );
      } else {
        await SharedPreferenceHelper.remove(SharedPrefKeys.savedEmail);
        await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      }

      ApiService.setToken(response.token);
      await FirebaseService.syncUserWithFirebase(
        apiUserId: response.user.id,
        email: response.user.email,
        password: password,
        name:
            response.user.role == 3
                ? response.user.employee?.name ?? ""
                : response.user.employer?.businessName ?? "",
        role: response.user.role == 3 ? "employee" : "employer",
        profileImage: response.user.profileImage,
      );

      Utilities.showSnackBar(
        title: "Success",
        message: response.message,
        isSuccess: true,
      );
      Get.offAllNamed(Routes.CUSTOMDRAWER);
    } catch (e) {
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
              ? errorMessage.replaceFirst('Exception: ', '')
              : errorMessage;
      Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red);
      print(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> logout() async {
  //   isLoading.value = true;
  //
  //   try {
  //     await AuthApi.logout();
  //     await TokenStorage.clearToken();
  //     ApiService.clearToken();
  //     Get.snackbar("Success", "Logged out successfully");
  //     Get.offAllNamed(Routes.HOME);
  //   } catch (e) {
  //     String errorMessage = e.toString().replaceFirst(
  //       'Exception: POST request error: Exception: ',
  //       '',
  //     );
  //     errorMessage =
  //         errorMessage.startsWith('Exception: ')
  //             ? errorMessage.replaceFirst('Exception: ', '')
  //             : errorMessage;
  //     Get.snackbar("Logout Failed", errorMessage, backgroundColor: Colors.red);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> logout() async {
    // Show loading dialog
    Get.dialog<void>(
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.colorFFFFFF,
          ),
          child: Column(
            spacing: 20.h,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(color: AppColors.colorE4A74C),
              const CustomText(
                title: 'Signing Out..',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.color000000,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // 🔄 Use Function 2 API call
      await AuthApi.logout();

      // 🔐 Clear tokens (from Function 2)
      await TokenStorage.clearToken();
      await SharedPreferenceHelper.remove(SharedPrefKeys.userRole);
      await SharedPreferenceHelper.remove(SharedPrefKeys.authToken);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userId);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userProfileImage);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userName);
      await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      ApiService.clearToken();
      nameController.clear();
      passwordController.clear();

      Get.back<void>(); // close dialog

      // 🟢 Success
      Utilities.showSnackBar(
        message: "Logged out successfully",
        title: 'Sign Out',
        isSuccess: true,
      );

      // navigate
      Get.offAllNamed<void>(Routes.SIGN_IN_VIEW);
    } catch (e) {
      Get.back<void>(); // close dialog

      // Clean error message (from Function 2)
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
              ? errorMessage.replaceFirst('Exception: ', '')
              : errorMessage;

      // 🔴 Error
      Utilities.showSnackBar(
        message: errorMessage,
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    final email = fEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email required", backgroundColor: Colors.red);
      return; // Keep return to prevent API call
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.red,
      );
      return;
    }

    fPasswordIsLoading.value = true;

    try {
      print('Attempting forgot password for email: $email');
      final response = await AuthApi.forgotPassword(email);
      final status = response['status'] as bool; // Status is a boolean
      final message = response['message'] as String;
      print('Forgot Password Response: status=$status, message=$message');

      if (status) {
        print('Status is true, showing dialog');
        await showResetPasswordDialog(
          context,
          email,
        ); // Wait for dialog to close
        print('Dialog closed, navigating to SIGN_IN_VIEW');
        Get.offNamed(Routes.SIGN_IN_VIEW); // Navigate after dialog is closed
      } else {
        Get.snackbar(
          "Forgot Password Failed",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Forgot Password Error: $e');
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
          errorMessage.startsWith('Exception: ')
              ? errorMessage.replaceFirst('Exception: ', '')
              : errorMessage;
      Get.snackbar(
        "Forgot Password Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      fPasswordIsLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    fEmailController.dispose();
    super.onClose();
  }
}
*/


import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/api/firebase/firebase_service.dart';
import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/helpers/shared_preference_helper.dart';

class AuthController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fEmailController = TextEditingController();
  final TextEditingController emailController = TextEditingController();


  final formKey = GlobalKey<FormState>();
  final RxBool rememberMe = false.obs;

  final isLoading = false.obs;
  final fPasswordIsLoading = false.obs;
  final RxBool isObscured = true.obs;

  @override
  void onInit() async {
    super.onInit();
    _loadSavedCredentials();
  }
  void _loadSavedCredentials() {
    String savedEmail =
        SharedPreferenceHelper.getString(SharedPrefKeys.savedEmail) ?? '';
    String savedPassword =
        SharedPreferenceHelper.getString(SharedPrefKeys.savedPassword) ?? '';

    emailController.text = savedEmail;

    if (savedPassword.isNotEmpty) {
      passwordController.text = savedPassword;
      rememberMe.value = true;
    } else {
      passwordController.clear();
      rememberMe.value = false;
    }
  }


  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  // Method to show the dialog
  Future<void> showResetPasswordDialog(
      BuildContext context,
      String email,
      ) async {
    print('Showing reset password dialog for email: $email'); // Debug log
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          email: email,
          title: "Reset Password",
          subTitle: "A link to reset your password has been sent to",
        );
      },
    );
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoading.value = true;

    try {



      //print('Attempting login with email: $email');
      final response = await AuthApi.login(email, password,   "");
      print('Login Response: $response');
      TokenStorage.saveToken(response.token);

      /// SAVE USER ROLE
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userRole,
        response.user.role,
      );

      /// SAVE AUTH TOKEN
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.authToken,
        response.token,
      );

      /// SAVE USER ID
      await SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userId,
        response.user.id,
      );

      /// SAVE USER PROFILE
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userProfileImage,
        response.user.profileImage ?? '',
      );

      /// SAVE USER NAME
      await SharedPreferenceHelper.saveString(
        SharedPrefKeys.userName,
        response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
      );

      if (rememberMe.value) {
        await SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedEmail,
          email,
        );

        await SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedPassword,
          password,
        );
      } else {
        await SharedPreferenceHelper.remove(SharedPrefKeys.savedEmail);
        await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      }

      ApiService.setToken(response.token);
      await FirebaseService.syncUserWithFirebase(
        apiUserId: response.user.id,
        email: response.user.email,
        password: password,
        name:
        response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
        role: response.user.role == 3 ? "employee" : "employer",
        profileImage: response.user.profileImage,
      );

      Utilities.showSnackBar(
        title: "Success",
        message: response.message,
        isSuccess: true,
      );
      Get.offAllNamed(Routes.CUSTOMDRAWER);
    } catch (e) {
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
      errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;
      Get.snackbar("Login Failed", errorMessage, backgroundColor: Colors.red);
      print(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // Show loading dialog
    Get.dialog<void>(
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.colorFFFFFF,
          ),
          child: Column(
            spacing: 20.h,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(color: AppColors.colorE4A74C),
              const CustomText(
                title: 'Signing Out..',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.color000000,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // 🔄 Use Function 2 API call
      await AuthApi.logout();

      // 🔐 Clear tokens (from Function 2)
      await TokenStorage.clearToken();
      await SharedPreferenceHelper.remove(SharedPrefKeys.userRole);
      await SharedPreferenceHelper.remove(SharedPrefKeys.authToken);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userId);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userProfileImage);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userName);
      await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      ApiService.clearToken();
      passwordController.clear();

      Get.back<void>(); // close dialog

      // 🟢 Success
      Utilities.showSnackBar(
        message: "Logged out successfully",
        title: 'Sign Out',
        isSuccess: true,
      );

      // navigate
      Get.offAllNamed<void>(Routes.SIGN_IN_VIEW);
    } catch (e) {
      Get.back<void>(); // close dialog

      // Clean error message (from Function 2)
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
      errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;

      // 🔴 Error
      Utilities.showSnackBar(
        message: errorMessage,
        title: 'Error',
        isSuccess: false,
      );
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    final email = fEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email required", backgroundColor: Colors.red);
      return; // Keep return to prevent API call
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.red,
      );
      return;
    }

    fPasswordIsLoading.value = true;

    try {
      print('Attempting forgot password for email: $email');
      final response = await AuthApi.forgotPassword(email);
      final status = response['status'] as bool; // Status is a boolean
      final message = response['message'] as String;
      print('Forgot Password Response: status=$status, message=$message');

      if (status) {
        print('Status is true, showing dialog');
        await showResetPasswordDialog(
          context,
          email,
        ); // Wait for dialog to close
        print('Dialog closed, navigating to SIGN_IN_VIEW');
        Get.offNamed(Routes.SIGN_IN_VIEW); // Navigate after dialog is closed
      } else {
        Get.snackbar(
          "Forgot Password Failed",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Forgot Password Error: $e');
      String errorMessage = e.toString().replaceFirst(
        'Exception: POST request error: Exception: ',
        '',
      );
      errorMessage =
      errorMessage.startsWith('Exception: ')
          ? errorMessage.replaceFirst('Exception: ', '')
          : errorMessage;
      Get.snackbar(
        "Forgot Password Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    } finally {
      fPasswordIsLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    fEmailController.dispose();
    emailController.dispose();

    super.onClose();
  }
}
