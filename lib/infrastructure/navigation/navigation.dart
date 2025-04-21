import 'package:barbee_hive_app/infrastructure/navigation/bindings/initial_binding.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/auth/auth.screen.dart';
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
      name: Routes.SIGN_UP_VIEW,
      page: () => const SignUpViewScreen(),
      binding: InitialBindings(),
    ),
  ];
}
