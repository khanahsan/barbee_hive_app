import 'dart:io';

import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/model/color_response.dart';
import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/data/model/login_response.dart';
import 'package:flutter/cupertino.dart';

import '../model/employee_register_response.dart';
import '../model/user_profile_response.dart';
import 'api_service.dart';

class AuthProvider {
  static Future<LoginResponse> login(String email, String password) async {
    final data = await ApiService.post(Endpoints.login, {
      'email': email,
      'password': password,
    });
    return LoginResponse.fromJson(data);
  }

  static Future<void> logout() async {
    await ApiService.post(Endpoints.logout, {}, auth: true);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await ApiService.post(Endpoints.forgotPassword, {
      'email': email,
    }, auth: false);
    return {
      'status': response['status'] ?? false,
      'message': response['message'] ?? 'Request processed',
    };
  }

  static Future<DashboardResponse> getDashboardUsers({
    required String currentLatitude,
    required String currentLongitude,
  }) async {

    debugPrint("CURRENT LAT $currentLatitude CURRENT LONG $currentLongitude");
    final data = await ApiService.post(
      Endpoints.dashboardUsers,
      {"latitude": currentLatitude, "longitude": currentLongitude},
      auth: true, // Requires token
    );
    return DashboardResponse.fromJson(data);
  }

  static Future<EyeColorResponse> getEyeColors() async {
    final data = await ApiService.get(
      Endpoints.eyeColors,
      auth:
          false, // Assuming authentication is required; set to false if public
    );
    return EyeColorResponse.fromJson(data);
  }

  static Future<HairColorResponse> getHairColors() async {
    final data = await ApiService.get(
      Endpoints.hairColors,
      auth: false, // Set to false if public
    );
    return HairColorResponse.fromJson(data);
  }

  static Future<SkillsResponse> getSkills() async {
    final data = await ApiService.get(
      Endpoints.getSkills,
      auth: false, // Set to false if public
    );
    return SkillsResponse.fromJson(data);
  }

  /* static Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int role,
    String? experienceYears,
    required String country,
    required String state,
    required String city,
    String? dob,
    String? gender,
    int? eyeColorId,
    int? hairColorId,
    int? height,
    File? resume,
    int? skillId,
  }) async {
    final fields = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role.toString(),
      'experience_years': experienceYears,
      'country': country,
      'state': state,
      'city': city,
      'dob': dob,
      'gender': gender,
      'eye_color_id': eyeColorId.toString(),
      'hair_color_id': hairColorId.toString(),
      'height': height.toString(),
      'skill_id': skillId.toString(),
    };
    print('Register Payload: $fields, Resume: ${resume?.path}');
    final data = await ApiService.multipartPost(
      Endpoints.registerEmployee,
      fields: fields,
      file: resume,
      fileField: 'resume',
      auth: false, // Register typically doesn't require auth
    );

    return RegisterResponse.fromJson(data);
  }*/

  static Future<RegisterResponse> register({
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
    int? skillId,
  }) async {
    final fields = <String, String>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role.toString(),
      'country': country,
      'state': state,
      'city': city,
    };

    // Add nullable fields only if they are not null
    if (dob != null) fields['dob'] = dob;
    if (gender != null) fields['gender'] = gender;
    if (eyeColorId != null) fields['eye_color_id'] = eyeColorId.toString();
    if (hairColorId != null) fields['hair_color_id'] = hairColorId.toString();
    if (height != null) fields['height'] = height.toString();
    if (skillId != null) fields['skill_id'] = skillId.toString();

    print('Register Payload: $fields, Resume: ${resume?.path}');
    final data = await ApiService.multipartPost(
      Endpoints.registerEmployee,
      fields: fields,
      file: resume,
      fileField: 'resume',
      auth: false,
    );

    return RegisterResponse.fromJson(data);
  }

  static Future<UserProfileResponse> getUserProfile(int userId) async {
    final data = await ApiService.get(
      '${Endpoints.userProfile}/$userId',
      auth: true,
    );
    return UserProfileResponse.fromJson(data);
  }
}
