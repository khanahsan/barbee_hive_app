import 'package:barbee_hive_app/infrastructure/navigation/bindings/initial_binding.dart';
import 'package:barbee_hive_app/infrastructure/widgets/customDrawer/custom_drawer.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/b2b/b2b_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/hive/hive_profile_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employee/myApplications/my_applications_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applicant_profile/applicant_profile_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applications_screen/applications_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/create%20job%20_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_posting/job_posting_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/job_update/job_update_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/job_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/pricing_plans_screen.dart';
import 'package:barbee_hive_app/presentation/changePassword/change_password_screen.dart';
import 'package:barbee_hive_app/presentation/notifications/notifications_screen.dart';
import 'package:barbee_hive_app/presentation/feedbackSupport/feedback_support_screen.dart';
import 'package:barbee_hive_app/presentation/profile/profile_screen.dart';
import 'package:barbee_hive_app/presentation/setting/settings_screen.dart';
import 'package:barbee_hive_app/presentation/signIn/sign_in_view.dart';
import 'package:barbee_hive_app/presentation/signUp/views/select_role_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/auth/auth.screen.dart';
import '../../presentation/auth/views/forgot_password_view.dart';
import '../../presentation/bottom_nav/dashboard/dashboard_screen.dart';
import '../../presentation/bottom_nav/job/employee/apply_screen.dart';
import '../../presentation/bottom_nav/message/chat_screen.dart';
import '../../presentation/home/home.screen.dart';
import '../../presentation/signUp/sign_up_employee_screen.dart';
import '../../presentation/signUp/sign_up_employer_screen.dart';
import '../../presentation/splash/splash.screen.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;

  EnvironmentsBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
          location: BannerLocation.topStart,
          message: env!,
          color: env == Environments.QAS ? Colors.blue : Colors.purple,
          child: child,
        )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
/*    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: InitialBindings(),
    ),*/
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: InitialBindings(),
    ),
    // GetPage(
    //   name: Routes.AUTH,
    //   page: () => const AuthScreen(),
    //   binding: InitialBindings(),
    // ),
    GetPage(
      name: Routes.selectRole,
      page: () => const SelectRoleView(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.SIGN_UP_VIEW,
      page: () => const SignUpEmployeeScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.SIGN_UP_EMPLOYER,
      page: () => const SignUpEmployerScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.CUSTOMDRAWER,
      page: () => const CustomDrawer(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.SIGN_IN_VIEW,
      page: () => const SignInView(),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.APPLY_VIEW,
      page:
          () => ApplyScreen(
            jobId: Get.arguments['jobId'],
            profileImage: Get.arguments['profileImage'],
          ),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.PROFILE_SCREEN,
      page: () => const ProfileScreen(),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.chatScreen,
      page:
          () => ChatScreen(
            // chatId: Get.arguments['chatID'],
            otherUserId: Get.arguments['otherUserID'],
          ),
    ),
    GetPage(
      name: Routes.settingsScreen,
      page: () => const SettingsScreen(),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.pricingPlansScreen,
      page:
          () => PricingPlansScreen(
            showBackButton: Get.arguments["showBackButton"],
          ),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.createJobScreen,
      page: () => const CreateJobScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.applicationsScreen,
      page: () => ApplicationsScreen(jobId: Get.arguments["jobId"]),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.b2bScreen,
      page: () => B2BScreen(currentUser: Get.arguments["currentUser"]),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.hiveProfileScreen,
      page: () => HiveProfileScreen(currentUser: Get.arguments["currentUser"]),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.jobPostingScreen,
      page: () => JobPostingScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.jobUpdateScreen,
      page: () => JobUpdateScreen(),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.feedbackSupportScreen,
      page: () => FeedbackSupportScreen(),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.applicantProfile,
      page: () => ApplicantProfileScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.myJobs,
      page: () => MyApplicationsScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.jobs,
      page: () => JobScreen(showBackButton: Get.arguments["showBackButton"]),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.notificationsScreen,
      page: () => NotificationsScreen(),
      binding: InitialBindings(),
    ),

  ];
}
