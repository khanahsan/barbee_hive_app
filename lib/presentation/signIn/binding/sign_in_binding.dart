import 'package:get/get.dart';
import '../controller/sign_in_controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    // Always provide a fresh controller; recreates if previously disposed
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
  }
}
