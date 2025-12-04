import 'dart:developer';
import 'package:get/get.dart';

import '../../../data/api/auth_provider.dart';
import '../../../infrastructure/utils/utilities.dart';

class SettingController extends GetxController {
  RxBool isLoading = false.obs;

  // Observables for settings
  RxBool receiveMessage = false.obs;
  RxBool sound = false.obs;
  RxBool vibrate = false.obs;
  RxBool location = false.obs;
  RxBool showDistance = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
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
        showDistance.value = response.data?.showDistance ?? false;
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

  // UPDATE SETTINGS API CALL
  Future<void> updateSettings() async {
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
    }
  }
}
