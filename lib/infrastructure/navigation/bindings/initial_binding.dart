import 'package:barbee_hive_app/infrastructure/widgets/customDrawer/controller/custom_drawer_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/controller/apply_screen_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applicant_profile/controller/applicant_profile_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applications_screen/controller/application_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_update/controller/job_update_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/controllers/sign_up_employer_controller.dart';
import 'package:get/get.dart';

import '../../../presentation/auth/controllers/auth.controller.dart';
import '../../../presentation/home/controllers/home.controller.dart';
import '../../../presentation/sign_up_view/controllers/sign_up_employee_controller.dart';
import '../../../presentation/splash/controllers/splash.controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CustomDrawerController>(() => CustomDrawerController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SignUpEmployeeController>(() => SignUpEmployeeController());
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<SignUpEmployerController>(() => SignUpEmployerController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<JobController>(() => JobController());
    Get.lazyPut<ApplyScreenController>(() => ApplyScreenController());
    Get.lazyPut<ApplicationsController>(() => ApplicationsController());
    Get.lazyPut<ApplicantProfileController>(() => ApplicantProfileController());
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<JobUpdateController>(() => JobUpdateController(), fenix: true);
  }
}
