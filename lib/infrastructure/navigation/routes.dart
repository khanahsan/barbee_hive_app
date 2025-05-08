import 'package:barbee_hive_app/data/api/api_service.dart';

class Routes {
static Future<String> get initialRoute async {
  await ApiService.initToken();
  final token = ApiService.getToken();
  print('Token: $token, Route: ${token != null && token.isNotEmpty ? CUSTOMDRAWER : HOME}');
  return token != null && token.isNotEmpty ? CUSTOMDRAWER : HOME;
}

  static const AUTH = '/auth';
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const FORGOT_PASSWORD = '/forgot_password';
  static const SIGN_UP_VIEW = '/sign_up_view';
  static const SIGN_IN_VIEW = '/sign_in_view';
  static const SELECT_ROLE_VIEW = '/select_role_view';
  static const DASHBOARD = '/dashboard';
  static const SIGN_UP_EMPLOYER = '/sign_up_employer';
  static const MAIN = '/main';
  static const CUSTOMDRAWER = '/custom_drawer';
  static const APPLY_VIEW = '/apply_view';
  static const PROFILE_SCREEN = '/profile_screen';
  static const chatScreen = '/chat_screen';
  static const settingsScreen = '/settings_screen';
}
