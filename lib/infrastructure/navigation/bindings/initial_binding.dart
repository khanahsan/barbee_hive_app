
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/controllers/sign_up_employer_controller.dart';
import 'package:get/get.dart';

import '../../../presentation/auth/controllers/auth.controller.dart';
import '../../../presentation/home/controllers/home.controller.dart';
import '../../../presentation/sign_up_view/controllers/sign_up_view.controller.dart';
import '../../../presentation/splash/controllers/splash.controller.dart';

class InitialBindings implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SignUpViewController>(() => SignUpViewController());
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<SignUpEmployerController>(() => SignUpEmployerController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }

}