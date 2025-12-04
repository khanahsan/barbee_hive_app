import 'dart:developer';
import 'dart:io';

import '../../model/user_profile_response.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class ProfileApi {
  /// FETCH USER PROFILE DATA
  static Future<UserProfileResponse> getUserProfile(int userId) async {
    log("USER ID: $userId");
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
    List<int>? skillIds,
    File? resume,
    File? profileImage,
    File? coverImage,
  }) async {
    final fields = <String, String>{
      'name': name,
      'email': email,
      'country': country,
      'state': state,
      'city': city,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (eyeColorId != null) 'eye_color_id': '$eyeColorId',
      if (hairColorId != null) 'hair_color_id': '$hairColorId',
      if (height != null) 'height': '$height',
      // if (skillId != null) 'skill_id': '$skillId',
    };

    if (skillIds != null && skillIds.isNotEmpty) {
      for (var i = 0; i < skillIds.length; i++) {
        fields['skill_id[$i]'] = skillIds[i].toString();
      }

      // ✅ Print the skill IDs
      log("Skills being sent: ${skillIds.join(', ')}");
    } else {
      log("No skills selected");
    }

    log("RESUME PATH: ${resume?.path}");
    log("PROFILE IMAGE PATH: ${profileImage?.path}");
    log("COVER IMAGE PATH: ${coverImage?.path}");

    final files = <String, File>{
      if (resume != null) 'resume': resume,
      if (profileImage != null) 'profile_image': profileImage,
      if (coverImage != null) 'cover_photo': coverImage,
    };

    final data = await ApiService.multipartPost(
      ApiEndPoints.updateProfile,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      auth: true,
    );

    return UserProfileResponse.fromJson(data);
  }
}
