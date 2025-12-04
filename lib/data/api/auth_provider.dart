import 'package:barbee_hive_app/data/api/endpoint_constants.dart';
import 'package:barbee_hive_app/data/model/color_response.dart';
import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:barbee_hive_app/data/model/gender_response.dart';
import 'package:barbee_hive_app/data/model/height_response.dart';
import 'package:barbee_hive_app/data/model/job_type_response.dart';
import 'package:barbee_hive_app/data/model/salary_type_response.dart';
import 'package:barbee_hive_app/data/model/setting_response.dart';
import 'package:barbee_hive_app/data/model/state_response.dart';
import 'package:flutter/cupertino.dart';

import '../../presentation/setting/model/update_setting_reponse.dart';
import '../model/experience_level_response.dart';
import 'api_service.dart';

class AuthProvider {
  static Future<DashboardResponse> getDashboardUsers({
    required String currentLatitude,
    required String currentLongitude,
  }) async {
    debugPrint("CURRENT LAT $currentLatitude CURRENT LONG $currentLongitude");
    final data = await ApiService.post(
      ApiEndPoints.dashboardUsers,
      {"latitude": currentLatitude, "longitude": currentLongitude},
      auth: true, // Requires token
    );
    return DashboardResponse.fromJson(data);
  }

  /// FETCH ALL EYE COLORS
  static Future<EyeColorResponse> getEyeColors() async {
    final data = await ApiService.get(
      ApiEndPoints.eyeColors,
      auth:
          false, // Assuming authentication is required; set to false if public
    );
    return EyeColorResponse.fromJson(data);
  }

  /// FETCH ALL HAIR COLORS
  static Future<HairColorResponse> getHairColors() async {
    final data = await ApiService.get(
      ApiEndPoints.hairColors,
      auth: false, // Set to false if public
    );
    return HairColorResponse.fromJson(data);
  }

  /// FETCH ALL SKILLS
  static Future<SkillsResponse> getSkills() async {
    final data = await ApiService.get(
      ApiEndPoints.getSkills,
      auth: false, // Set to false if public
    );
    return SkillsResponse.fromJson(data);
  }

  /// FETCH ALL EXPERIENCE LEVELS
  static Future<ExperienceLevelResponse> getExperienceLevels() async {
    final data = await ApiService.get(
      ApiEndPoints.getExperienceLevels,
      auth: false, // Set to false if public
    );
    return ExperienceLevelResponse.fromJson(data);
  }

  /// FETCH ALL JOB TYPES
  static Future<JobTypeResponse> getJobTypes() async {
    final data = await ApiService.get(
      ApiEndPoints.getJobTypes,
      auth: false, // Set to false if public
    );
    return JobTypeResponse.fromJson(data);
  }

  /// FETCH ALL GENDERS
  static Future<GenderResponse> getGenders() async {
    final data = await ApiService.get(ApiEndPoints.getGenders, auth: false);
    return GenderResponse.fromJson(data);
  }

  /// FETCH ALL HEIGHTS
  static Future<HeightResponse> getHeights() async {
    final data = await ApiService.get(ApiEndPoints.getHeights, auth: false);
    return HeightResponse.fromJson(data);
  }

  /// FETCH ALL COUNTRIES
  static Future<CountryResponse> getCountries() async {
    final data = await ApiService.get(ApiEndPoints.getCountries, auth: false);
    return CountryResponse.fromJson(data);
  }

  /// FETCH ALL STATES
  static Future<StateResponse> getStates() async {
    final data = await ApiService.get(ApiEndPoints.getStates, auth: false);
    return StateResponse.fromJson(data);
  }

  /// FETCH ALL SALARY TYPES
  static Future<SalaryTypeResponse> getSalaryTypes() async {
    final data = await ApiService.get(ApiEndPoints.getSalaryTypes, auth: false);
    return SalaryTypeResponse.fromJson(data);
  }

  /// FETCH SETTINGS
  static Future<SettingsResponse> getSetting() async {
    final data = await ApiService.get(ApiEndPoints.setting);
    return SettingsResponse.fromJson(data);
  }

  /// UPDATE SETTINGS
  static Future<UpdateSettingResponse> updateSetting({
    required bool receiveMessages,
    required bool sound,
    required bool vibrate,
    required bool location,
    required bool showDistance,
  }) async {
    final fields = {
      'receive_messages': receiveMessages,
      'sound': sound,
      'vibrate': vibrate,
      'location': location,
      'show_distance': showDistance,
    };

    final data = await ApiService.post(
      ApiEndPoints.updateSettings,
      fields,
      auth: true,
    );

    return UpdateSettingResponse.fromJson(data);
  }
}
