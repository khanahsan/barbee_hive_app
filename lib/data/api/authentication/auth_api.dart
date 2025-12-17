import 'dart:io';

import '../../model/employee_register_response.dart';
import '../../model/login_response.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class AuthApi {
  /// LOGIN API
  static Future<LoginResponse> login(String email, String password) async {
    final data = await ApiService.post(ApiEndPoints.login, {
      'email': email,
      'password': password,
    });
    return LoginResponse.fromJson(data);
  }

  /// LOGOUT API
  static Future<void> logout() async =>
      ApiService.post(ApiEndPoints.logout, {}, auth: true);

  /// FORGOT PASSWORD API
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await ApiService.post(ApiEndPoints.forgotPassword, {
      'email': email,
    }, auth: false);
    return {
      'status': response['status'] ?? false,
      'message': response['message'] ?? 'Request processed',
    };
  }

  /// CHANGE PASSWORD API
  static Future<Map<String, dynamic>> changePassword({
    required String currentPass,
    required String newPass,
    required String confirmPass,
  }) async {
    final response = await ApiService.post(ApiEndPoints.changePassword, {
      'current_password': currentPass,
      'password': newPass,
      'password_confirmation': confirmPass,
    }, auth: true);
    return {
      'status': response['status'] ?? false,
      'message': response['message'] ?? 'Request processed',
    };
  }

  /// FORGOT PASSWORD API
  static Future<Map<String, dynamic>> deleteAccount({required String email, required String password}) async {
    final response = await ApiService.post(ApiEndPoints.deleteAccount, {
      'password': password,
    }, auth: true);
    return {
      'status': response['status'] ?? false,
      'message': response['message'] ?? 'Request processed',
    };
  }

  /// REGISTER API
  static Future<RegisterResponse> register({
    required String uid,
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int role,
    required String country,
    required String state,
    required String city,
    String? dob,
    String? gender,
    int? eyeColorId,
    int? hairColorId,
    int? height,
    File? resume,
    // int? skillId,
    List<int>? skillIds,
    File? profileImage,
  }) async {
    final fields = <String, String>{
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role.toString(),
      'country_id': country,
      'state_id': state,
      'city': city,
    };

    // Add nullable fields only if they are not null
    if (dob != null) fields['dob'] = dob;
    if (gender != null) fields['gender'] = gender;
    if (eyeColorId != null) fields['eye_color_id'] = eyeColorId.toString();
    if (hairColorId != null) fields['hair_color_id'] = hairColorId.toString();
    if (height != null) fields['height'] = height.toString();
    // if (skillId != null) fields['skill_id'] = skillId.toString();

    if (skillIds != null && skillIds.isNotEmpty) {
      // For APIs that accept multiple values as skill_ids[]
      for (var i = 0; i < skillIds.length; i++) {
        fields['skill_id[$i]'] = skillIds[i].toString();
      }
    }

    print(
      'Register Payload: $fields, Resume: ${resume?.path}, ProfileImage: ${profileImage?.path}',
    );

    // Prepare files for multipart request
    final files = <String, File>{};
    if (resume != null) files['resume'] = resume;
    if (profileImage != null) {
      files['profile_image'] = profileImage; // Add profile image
    }

    final data = await ApiService.multipartPost(
      ApiEndPoints.registerEmployee,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      auth: false,
    );

    print("🔥 FULL RAW REGISTER RESPONSE:\n$data\n");

    return RegisterResponse.fromJson(data);
  }
}
