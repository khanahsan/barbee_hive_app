import 'package:barbee_hive_app/infrastructure/widgets/customDrawer/controller/custom_drawer_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/dashboardController.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/controller/apply_screen_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/myApplications/controller/my_applications_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applicant_profile/controller/applicant_profile_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applications_screen/controller/application_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_update/controller/job_update_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/controller/pricing_plans_controller.dart';
import 'package:barbee_hive_app/presentation/feedbackSupport/controller/feedback_support_controller.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../../presentation/auth/controllers/auth.controller.dart';
import '../../../presentation/bottom_nav/dashboard/controller/b2b_controller.dart';
import '../../../presentation/bottom_nav/dashboard/controller/hive_profile_controller.dart';
import '../../../presentation/bottom_nav/job/employer/job_posting/controller/job_posting_controller.dart';
import '../../../presentation/changePassword/controller/change_password_controller.dart';
import '../../../presentation/home/controllers/home.controller.dart';
import '../../../presentation/setting/controller/setting_controller.dart';
import '../../../presentation/signIn/controller/sign_in_controller.dart';
import '../../../presentation/signUp/controllers/sign_up_employee_controller.dart';
import '../../../presentation/signUp/controllers/sign_up_employer_controller.dart';
import '../../../presentation/splash/controllers/splash.controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    // Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<B2BController>(() => B2BController());
    Get.lazyPut<HiveProfileController>(() => HiveProfileController());
    Get.lazyPut<CustomDrawerController>(() => CustomDrawerController(),
        fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
    Get.lazyPut<SignUpEmployeeController>(() => SignUpEmployeeController());
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<SignUpEmployerController>(() => SignUpEmployerController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<JobController>(() => JobController(), fenix: true);
    Get.lazyPut<ApplyScreenController>(() => ApplyScreenController());
    Get.lazyPut<ApplicationsController>(() => ApplicationsController());
    Get.lazyPut<ApplicantProfileController>(() => ApplicantProfileController());
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<JobUpdateController>(() => JobUpdateController(), fenix: true);
    Get.lazyPut<MyApplicationsController>(() => MyApplicationsController(), fenix: true);
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    Get.lazyPut<FeedbackSupportController>(() => FeedbackSupportController(), fenix: true);
    Get.lazyPut<JobPostingController>(
      () => JobPostingController(),
      // fenix: true,
    );
    Get.lazyPut<PricingPlansController>(
      () => PricingPlansController(),
      fenix: true,
    );
  }
}
