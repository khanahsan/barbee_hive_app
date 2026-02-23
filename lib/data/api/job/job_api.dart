import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';

import '../../../infrastructure/utils/log_util.dart';
import '../../model/applied_job_response.dart';
import '../../model/job_application_response.dart';
import '../../model/job_list_response.dart';
import '../../model/job_posting_model.dart';
import '../api_service.dart';
import '../endpoint_constants.dart';

class JobApi {
  static Future<JobPostResponse> postJob({
    required String description,
    required String experienceLevel,
    required String minSalary,
    required String maxSalary,
    required String jobType,
    required String country,
    required String state,
    required String city,
    required String recruiterName,
    required String salaryType,
    required int noOfDays,
    required int skillId,
    File? image,
  }) async {
    final fields = <String, String>{
      'description': description,
      'experience_level': experienceLevel,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'job_type': jobType,
      'country_id': country,
      'state_id': state,
      'city': city,
      'recruiter_name': recruiterName,
      'salary_type': salaryType,
      'no_of_days': '$noOfDays',
      'skill_id': '$skillId',
    };

    final files = <String, File>{if (image != null) 'image': image};

    // --- Print all fields for debugging ---
    print('--- Posting Job ---');
    fields.forEach((key, value) {
      print('$key: $value');
    });
    if (image != null) {
      print('image: ${image.path}');
    } else {
      print('image: null');
    }
    print('-------------------');

    final data = await ApiService.multipartPost(
      ApiEndPoints.jobStore,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      auth: true,
    );

    return JobPostResponse.fromJson(data);
  }

  static Future<JobPostResponse> finalizeJob({
    required int jobId,
    required String paymentIntentId,
  }) async {
    final payload = {'job_id': jobId, 'payment_intent_id': paymentIntentId};

    final data = await ApiService.post(
      ApiEndPoints.finalizeJob,
      payload,
      auth: true,
    );

    return JobPostResponse.fromJson(data);
  }

  static Future<JobPostResponse> renewJobIntent({
    required int jobId,
    required int days,
  }) async {
    final payload = {'job_id': jobId, 'days': days};

    final data = await ApiService.post(
      ApiEndPoints.jobRenewIntent,
      payload,
      auth: true,
    );

    return JobPostResponse.fromJson(data);
  }

  // static Future<JobPostResponse> postJob({
  //   required String title,
  //   required String description,
  //   required String experienceLevel,
  //   required String minSalary,
  //   required String maxSalary,
  //   required String jobType,
  //   required String country,
  //   required String state,
  //   required String city,
  //   required String recruiterName,
  //   required int noOfDays,
  //   required int skillId,
  //   File? image,
  // }) async {
  //   final fields = <String, String>{
  //     'title': title,
  //     'description': description,
  //     'experience_level': experienceLevel,
  //     'min_salary': minSalary,
  //     'max_salary': maxSalary,
  //     'job_type': jobType,
  //     'country': country,
  //     'state': state,
  //     'city': city,
  //     'recruiter_name': recruiterName,
  //     'no_of_days': '$noOfDays',
  //     'skill_id': '$skillId',
  //   };
  //
  //   final files = <String, File>{if (image != null) 'image': image};
  //
  //   final data = await ApiService.multipartPost(
  //     ApiEndPoints.jobStore,
  //     fields: fields,
  //     files: files.isNotEmpty ? files : null,
  //     auth: true,
  //   );
  //
  //   return JobPostResponse.fromJson(data);
  // }

  static Future<JobListResponse> getJobs(int? userId) async {
    final data = await ApiService.get(
      '${ApiEndPoints.jobs}?user_id=$userId',
      auth: true,
    );
    return JobListResponse.fromJson(data);
  }

  static Future<AppliedJobsResponse> getAppliedJobs(int? userId) async {
    final data = await ApiService.get(
      '${ApiEndPoints.appliedJobs}?user_id=$userId',
      auth: true,
    );
    return AppliedJobsResponse.fromJson(data);
  }

  static Future<JobApplyResponse> applyJob({
    required int jobId,
    required String experienceLevel,
    required int yearsOfExperience,
    required String jobType,
    required String expectedSalary,
  }) async {
    final fields = {
      'job_id': '$jobId',
      'experience_level': experienceLevel,
      'years_of_experience': '$yearsOfExperience',
      'job_type': jobType,
      'expected_salary': expectedSalary,
    };

    final data = await ApiService.post(
      ApiEndPoints.applyJob,
      fields,
      auth: true,
    );
    return JobApplyResponse.fromJson(data);
  }

  static Future<JobApplyResponse> getJobApplications(
    int jobId, {
    Map<String, dynamic>? filters,
  }) async {

    log("BEARER TOKEN: ${SharedPreferenceHelper.getString(SharedPrefKeys.authToken)}");
    try {
      String endpoint = '${ApiEndPoints.jobApplications}/$jobId';
      if (filters != null && filters.isNotEmpty) {
        final queryParams = filters.entries
            .map((e) => '${e.key}=${e.value}')
            .join('&');
        endpoint += '?$queryParams';
      }
      print('GET Request URL: ${ApiEndPoints.baseUrl}$endpoint');
      final data = await ApiService.get(endpoint, auth: true);
      print('GET Response: $data');
      return JobApplyResponse.fromJson(data);
    } catch (e) {
      print('Get Job Applications Error: $e');
      LogUtil.logError('getJobApplications: $e');
      if (e.toString().contains('Exception: ')) {
        final message = e.toString().replaceFirst('Exception: ', '');
        throw Exception(message);
      }
      rethrow;
    }
  }

  static Future<JobListResponse> getEmployeeJobs() async {
    final userID = await SharedPreferenceHelper.getInt(SharedPrefKeys.userId);

    final data = await ApiService.get(
      '${ApiEndPoints.jobs}',
      auth: true,
    );
    return JobListResponse.fromJson(data);
  }

  static Future<JobPostResponse> updateJob({
    required int id,
    required String description,
    required String experienceLevel,
    required String minSalary,
    required String maxSalary,
    required String jobType,
    required String country,
    required String state,
    required String city,
    required String recruiterName,
    required String salaryType,
    required int noOfDays,
    required int skillId,
    File? image, // Added image parameter
  }) async {
    final fields = <String, String>{
      'id': id.toString(),
      'skill_id': '$skillId',
      'experience_level': experienceLevel,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'salary_type': salaryType,
      'country_id': country,
      'state_id': state,
      'city': city,
      'recruiter_name': recruiterName,
      'description': description,
      'job_type': jobType,
      'no_of_days': noOfDays.toString(),
    };

    print('Job Post Payload: $fields, Image: ${image?.path}');
    final files = <String, File>{};
    if (image != null) files['resume'] = image;
    final data = await ApiService.multipartPost(
      ApiEndPoints.jobUpdate,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      // fileField: 'image', // Matches API field
      auth: true, // Requires authentication
    );

    return JobPostResponse.fromJson(data);
  }
}
