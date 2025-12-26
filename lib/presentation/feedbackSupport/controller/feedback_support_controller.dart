import 'dart:developer';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/contact_types_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackSupportController extends GetxController {
  final RxString selectedType = ''.obs;
  final TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isSubmitLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Use RxList to store contact types from API
  final RxList<ContactType> typeOptions = <ContactType>[].obs;

  void selectType(String? value) {
    selectedType.value = value ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchContactTypes(); // Fetch contact types when controller initializes
  }

  void clearForm() {
    selectedType.value = '';
    messageController.clear();
  }

  Future<void> fetchContactTypes() async {
    isLoading.value = true;

    try {
      final response = await AuthProvider.getContactTypes();

      if (response.status) {
        // Populate typeOptions with the response data
        typeOptions.value = response.data;
        log("Contact Types fetched successfully: ${typeOptions.length} types");
      }
    } catch (e) {
      log("Failed to fetch Contact Types: $e");

      Utilities.showSnackBar(
        title: "Error",
        message: "Failed to fetch types",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> feedbackSupport() async {
    isSubmitLoading.value = true;

    try {
      // Fetch user data from SharedPreferences
      final name = SharedPreferenceHelper.getString(SharedPrefKeys.userName) ?? '';
      final email = SharedPreferenceHelper.getString(SharedPrefKeys.userEmail) ?? '';

      if (name.isEmpty || email.isEmpty) {
        Utilities.showSnackBar(
          title: "Error",
          message: "User information not found. Please login again.",
          isSuccess: false,
        );
        isSubmitLoading.value = false;
        return;
      }

      // Call the API
      final response = await AuthProvider.postFeedbackSupport(
        name: name,
        email: email,
        description: messageController.text,
        type: selectedType.value,
      );

      if (response.status) {

        Get.back<void>();
        Utilities.showSnackBar(
          title: "Success",
          message: response.message ?? "Feedback submitted successfully",
          isSuccess: true,
        );

        // Clear form and go back
        clearForm();

      } else {
        Utilities.showSnackBar(
          title: "Error",
          message: response.message ?? "Failed to submit feedback",
          isSuccess: false,
        );
      }
    } catch (e) {
      log("Failed to submit feedback: $e");

      Utilities.showSnackBar(
        title: "Error",
        message: e.toString().replaceFirst("Exception: ", ""),
        isSuccess: false,
      );
    } finally {
      isSubmitLoading.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
