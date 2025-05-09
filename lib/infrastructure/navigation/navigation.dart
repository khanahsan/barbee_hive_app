import 'package:barbee_hive_app/infrastructure/navigation/bindings/initial_binding.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_drawer.dart';
import 'package:barbee_hive_app/presentation/auth/views/sign_in_view.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applications_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/create%20job%20_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/chat_screen.dart';
import 'package:barbee_hive_app/presentation/profile/profile_screen.dart';
import 'package:barbee_hive_app/presentation/setting/settings_screen.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/sign_up_employer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/auth/auth.screen.dart';
import '../../presentation/auth/views/forgot_password_view.dart';
import '../../presentation/bottom_nav/dashboard/dashboard_screen.dart';
import '../../presentation/bottom_nav/job/employee/apply_screen.dart';
import '../../presentation/home/home.screen.dart';
import '../../presentation/sign_up_view/sign_up_view.screen.dart';
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
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.SIGN_UP_VIEW,
      page: () => const SignUpViewScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
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
      name: Routes.APPLY_VIEW,
      page: () => const ApplyScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.PROFILE_SCREEN,
      page: () => const ProfileScreen(),
      binding: InitialBindings(),
    ),
    /*GetPage(
      name: Routes.chatScreen,
      page: () => ChatScreen(),
      binding: InitialBindings(),
    ),*/
    GetPage(
      name: Routes.chatScreen,
      page: () => ChatScreen(
        chatID: Get.arguments['chatID'],
        otherUserID: Get.arguments['otherUserID'],
        currentUserID: Get.arguments['currentUserID'],
      ),
    ),
    GetPage(
      name: Routes.settingsScreen,
      page: () => const SettingsScreen(),
      binding: InitialBindings(),
    ),

    GetPage(
      name: Routes.createJobScreen,
      page: () => const CreateJobScreen(),
      binding: InitialBindings(),
    ),
    GetPage(
      name: Routes.applicationsScreen,
      page: () => const ApplicationsScreen(),
      binding: InitialBindings(),
    ),
  ];
}
