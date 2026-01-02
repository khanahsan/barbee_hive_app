import 'package:get/get.dart';
import '../controller/sign_in_controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    // Delete any existing instance first to ensure clean state
    Get.delete<SignInController>(force: true);

    // Create a fresh instance every time
    Get.put(SignInController());
  }
}
