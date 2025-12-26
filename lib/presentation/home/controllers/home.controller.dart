/*
import 'package:get/get.dart';
import '../../../data/api/firebase/firebase_service.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/utilities.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  final RxBool isGoogleSignInLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> signInWithGoogle() async {
    isGoogleSignInLoading.value = true;

    try {
      final userCredential = await FirebaseService.signInWithGoogle();

      if (userCredential == null) {
        // User cancelled the sign-in
        Utilities.showSnackBar(
          title: "Cancelled",
          message: "Google Sign-In was cancelled",
          isSuccess: false,
        );
        return;
      }

      // Successfully signed in
      Utilities.showSnackBar(
        title: "Success",
        message: "Successfully signed in with Google",
        isSuccess: true,
      );

      // Navigate to main screen
      Get.offAllNamed(Routes.CUSTOMDRAWER);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(
        title: "Google Sign-In Failed",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isGoogleSignInLoading.value = false;
    }
  }
}
*/
