import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../model/user_profile_response.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class ProfileApi {
  /// FETCH USER PROFILE DATA
  static Future<UserProfileResponse> getUserProfile(int userId) async {
    final data = await ApiService.get(
      '${ApiEndPoints.userProfile}/$userId',
      auth: true,
    );
    return UserProfileResponse.fromJson(data);
  }

  /// UPDATE USER PROFILE
  static Future<UserProfileResponse> updateUserProfile({
    required String name,
    required String email,
    required String country,
    required String state,
    required String city,
    String? dob,
    String? gender,
    int? eyeColorId,
    int? hairColorId,
    int? height,
    int? skillId,
    File? resume,
  }) async {
    final fields = <String, String>{
      'name': name,
      'email': email,
      'country': country,
      'state': state,
      'city': city,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (eyeColorId != null) 'eyeColorId': '$eyeColorId',
      if (hairColorId != null) 'hairColorId': '$hairColorId',
      if (height != null) 'height': '$height',
      if (skillId != null) 'skillId': '$skillId',
    };

    final files = <String, File>{if (resume != null) 'resume': resume};

    final data = await ApiService.multipartPost(
      ApiEndPoints.updateProfile,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      auth: true,
    );

    return UserProfileResponse.fromJson(data);
  }
}
