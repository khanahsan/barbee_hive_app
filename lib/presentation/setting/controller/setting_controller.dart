import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/api/token_storage.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_strings.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/api/auth_provider.dart';
import '../../../infrastructure/utils/utilities.dart';

class SettingController extends GetxController {
  RxBool isLoading = false.obs;

  // Observables for settings
  RxBool receiveMessage = false.obs;
  RxBool sound = false.obs;
  RxBool vibrate = false.obs;
  RxBool location = false.obs;
  RxInt showDistance = 0.obs;

  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> openCommunityGuidelines() async {
    final uri = Uri.parse(
      '${ApiEndPoints.basePoint}${AppStrings.communityGuidelines}',
    );

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Could not launch the Terms of Service',
        isSuccess: false,
      );
    }
  }


  Future<void> openTerms() async {
    final uri = Uri.parse(
      '${ApiEndPoints.basePoint}${AppStrings.termsConditions}',
    );

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Could not launch the Terms of Service',
        isSuccess: false,
      );
    }
  }

  // FETCH SETTINGS FROM API
  Future<void> fetchSettings() async {
    isLoading.value = true;

    try {
      final response = await AuthProvider.getSetting();

      if (response.status) {
        receiveMessage.value = response.data?.receiveMessages ?? false;
        sound.value = response.data?.sound ?? false;
        vibrate.value = response.data?.vibrate ?? false;
        location.value = response.data?.location ?? false;
        showDistance.value = response.data?.showDistance ?? 0;
      }
    } catch (e) {
      log("Failed to fetch Settings: $e");

      Utilities.showSnackBar(
        title: "Error",
        message: "Failed to fetch settings",
        isSuccess: false,
      );
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

      // Close loading dialog from root navigator
      final ctx = Get.overlayContext;
      if (ctx != null) {
        Navigator.of(ctx, rootNavigator: true).pop();
      }

      // 🟢 Success
      Utilities.showSnackBar(
        message: "Logged out successfully",
        title: 'Sign Out',
        isSuccess: true,
      );

      // navigate
      Get.offAllNamed<void>(Routes.SIGN_IN_VIEW);
    } catch (e) {
      // Close loading dialog from root navigator
      final ctx = Get.overlayContext;
      if (ctx != null) {
        Navigator.of(ctx, rootNavigator: true).pop();
      }

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

  /// Update `disableChat` on all chats where the current user is a participant
  Future<void> updateDisableChatForAllChats(bool disable) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('userIds', arrayContains: uid)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'disableChat': disable});
      }
      await batch.commit();

      log("disableChat set to $disable for ${querySnapshot.docs.length} chats");
    } catch (e) {
      log("Failed to update disableChat: $e");
    }
  }

  // UPDATE SETTINGS API CALL
  Future<void> updateSettings() async {
    isLoading.value = true;

    try {
      final response = await AuthProvider.updateSetting(
        receiveMessages: receiveMessage.value,
        sound: sound.value,
        vibrate: vibrate.value,
        location: location.value,
        showDistance: showDistance.value,
      );

      if (!response.status) {
        Utilities.showSnackBar(
          title: "Error",
          message: response.message ?? "",
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: "Error",
        message: e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      Utilities.showSnackBar(
        title: "Error",
        message: "Password cannot be empty",
        isSuccess: false,
      );
      return;
    }

    isLoading.value = true;

    try {
      // final user = FirebaseAuth.instance.currentUser;

      // if (user == null) {
      //   throw Exception("No user logged in");
      // }

      // 1️⃣ Reauthenticate Firebase user
      // final credential = EmailAuthProvider.credential(
      //   email: user.email!,
      //   password: password,
      // );
      // await user.reauthenticateWithCredential(credential);

      // 2️⃣ Call backend API to delete account
      final response = await AuthApi.deleteAccount(
        // email: user.email ?? '',
        email: '', // Provide email from your local storage if needed
        password: password,
      );

      final status = response['status'] as bool;
      final message = response['message'] as String;

      if (!status) {
        Utilities.showSnackBar(
          title: "Error",
          message: message,
          isSuccess: false,
        );
        return;
      }

      // 3️⃣ Delete Firestore user document
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .delete();

      // 4️⃣ Delete FirebaseAuth account
      // await user.delete();

      Utilities.showSnackBar(
        title: "Success",
        message: message,
        isSuccess: true,
      );

      await TokenStorage.clearToken();
      await SharedPreferenceHelper.remove(SharedPrefKeys.userRole);
      await SharedPreferenceHelper.remove(SharedPrefKeys.authToken);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userId);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userProfileImage);
      await SharedPreferenceHelper.remove(SharedPrefKeys.userName);
      await SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword);
      ApiService.clearToken();

      Get.offAllNamed(Routes.SIGN_IN_VIEW);

      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'wrong-password') {
      //     Utilities.showSnackBar(
      //       title: "Error",
      //       message: "Incorrect password",
      //       isSuccess: false,
      //     );
      //   } else {
      //     Utilities.showSnackBar(
      //       title: "Error",
      //       message: e.message ?? "Firebase error",
      //       isSuccess: false,
      //     );
      //   }

    } catch (e) {
      Utilities.showSnackBar(
        title: "Error",
        message: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

/*  Future<void> deleteAccount() async {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      Utilities.showSnackBar(
        title: "Error",
        message: "Password cannot be empty",
        isSuccess: false,
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No user logged in");
      }

      // 1️⃣ Reauthenticate Firebase user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 2️⃣ Call backend API to delete account
      final response = await AuthApi.deleteAccount(
        email: user.email ?? '',
        password: password,
      );
      final status = response['status'] as bool;
      final message = response['message'] as String;

      if (!status) {
        Utilities.showSnackBar(
          title: "Error",
          message: message,
          isSuccess: false,
        );
        return;
      }

      // 3️⃣ Delete Firestore user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // 4️⃣ Delete FirebaseAuth account
      await user.delete();

      Utilities.showSnackBar(
        title: "Success",
        message: "Account deleted successfully",
        isSuccess: true,
      );

      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Utilities.showSnackBar(
          title: "Error",
          message: "Incorrect password",
          isSuccess: false,
        );
      } else {
        Utilities.showSnackBar(
          title: "Error",
          message: e.message ?? "Firebase error",
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: "Error",
        message: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }*/

  void showDeleteAccountDialog() {
    final ctrl = this;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // prevent back button
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
          backgroundColor: AppColors.color000000,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.color000000,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.colorFF8600, width: 0.5),
            ),
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 10.h,
              bottom: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      ctrl.passwordController.clear();
                      final ctx = Get.overlayContext;
                      if (ctx != null) {
                        Navigator.of(ctx, rootNavigator: true).pop();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: AppColors.colorFF8600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                CustomText(
                  title: "Confirm Delete",
                  fontSize: 25.sp,
                  color: AppColors.colorFFFFFF,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 15.h),

                CustomText(
                  title: "Enter your password to delete your account.",
                  fontSize: 20.sp,
                  color: AppColors.colorFFFFFF,
                ),

                SizedBox(height: 25.h),

                AppTextField(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 16.h,
                  ),
                  controller: ctrl.passwordController,
                  hintText: "Password",
                  fillColor: AppColors.colorFFFFFF,
                  fontColor: AppColors.color000000,
                  fontSize: 16,
                ),

                SizedBox(height: 25.h),

                Row(
                  spacing: 10.w,
                  children: [
                    Expanded(
                      child: CustomBtn(
                        buttonHeight: 50.h,
                        btnTitle: "Cancel",
                        btnBackgroundColor: Colors.transparent,
                        btnTxtColor: Colors.white,
                        borderColor: AppColors.colorFF8600,
                        borderWidth: 1,
                        onPressed: () {
                          ctrl.passwordController.clear();
                          final ctx = Get.overlayContext;
                          if (ctx != null) {
                            Navigator.of(ctx, rootNavigator: true).pop();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomBtn(
                        buttonHeight: 50.h,
                        btnTitle: "Confirm",
                        btnBackgroundColor: AppColors.colorFF8600,
                        btnTxtColor: Colors.white,
                        onPressed: () {
                          if (ctrl.passwordController.text.isEmpty) {
                            Utilities.showSnackBar(
                              title: "Error",
                              message: "Password cannot be empty",
                              isSuccess: false,
                            );
                            return;
                          }

                          // Close dialog from root navigator
                          final ctx = Get.overlayContext;
                          if (ctx != null) {
                            Navigator.of(ctx, rootNavigator: true).pop();
                          }

                          // Show loading overlay while deleting account
                          ctrl.isLoading.value = true;
                          ctrl.deleteAccount().whenComplete(() {
                            ctrl.isLoading.value = false;
                            ctrl.passwordController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // cannot dismiss by tapping outside
    );
  }
}
