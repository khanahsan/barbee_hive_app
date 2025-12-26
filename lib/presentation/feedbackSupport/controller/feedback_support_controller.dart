import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackSupportController extends GetxController {
  final RxString selectedType = ''.obs;
  final TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> typeOptions = [
    'Support Ticket',
    'Feedback',
    'User Inquiry',
  ];

  void selectType(String? value) {
    selectedType.value = value ?? '';
  }

  void clearForm() {
    selectedType.value = '';
    messageController.clear();
  }

  Future<void> feedbackSupport() async {
    isLoading.value = true;

    // await AuthApi.feedbackSupport(
    //   selectedType: selectedType.value ?? '',
    //   message: messageController.text,
    //   successCallback: (String message) async {
    //     isLoading.value = false;
    //
    //     Get.back<void>();
    //
    //     Utilities.showSnackBar(message: message, title: 'Success', isSuccess: true);
    //   },
    //   failureCallback: (String error) {
    //     isLoading.value = false;
    //     Utilities.showSnackBar(message: error, title: 'Error', isSuccess: false);
    //   },
    // );
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
