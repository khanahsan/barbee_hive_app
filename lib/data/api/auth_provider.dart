

import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/model/login_response.dart';

import 'api_service.dart';
class AuthProvider {
  static Future<LoginResponse> login(String email, String password) async {
    final data = await ApiService.post(
      Endpoints.login,
      {
        'email': email,
        'password': password,
      },
    );
    return LoginResponse.fromJson(data);
  }

  static Future<void> logout() async {
    await ApiService.post(
      Endpoints.logout,
      {},
      auth: true,
    );
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await ApiService.post(
      Endpoints.forgotPassword,
      {'email': email},
      auth: false,
    );
    return {
      'status': response['status'] ?? false,
      'message': response['message'] ?? 'Request processed',
    };
  }
}