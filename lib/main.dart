import 'package:barbee_hive_app/infrastructure/navigation/bindings/initial_binding.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'data/api/api_service.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = await Routes.initialRoute;
  await ApiService.initToken();

  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInitializer(
      baseHeight: 956,
      baseWidth: 440,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 16.0),
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontSize: 16.0),
          ),
        ),
        initialRoute: initialRoute,
        getPages: Nav.routes,
        initialBinding: InitialBindings(),
        transitionDuration: const Duration(milliseconds: 500),

      ),
    );
  }
}
