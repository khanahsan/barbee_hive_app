import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/services/current_user_subscription_controller.dart';
import 'package:barbee_hive_app/infrastructure/services/subscription_feature_guard.dart';
import 'package:get/get.dart';

import '../../../../../../data/model/job_application_response.dart';

class ApplicantProfileController extends GetxController {
  final CurrentUserSubscriptionController currentUserSubscriptionController =
      Get.find<CurrentUserSubscriptionController>();

  // final profile = Rxn<ApplicantProfileData>();

  final profile = Rxn<JobApplyData>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final userRole = 0.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   final userId = Get.arguments?['userId'] ?? 38;
  //
  //   fetchProfile(userId);
  // }

  @override
  void onInit() {
    super.onInit();
    userRole.value =
        SharedPreferenceHelper.getInt(SharedPrefKeys.userRole) ?? 0;
    currentUserSubscriptionController.refresh();

    final data = Get.arguments?['applicationData'];

    if (data != null && data is JobApplyData) {
      profile.value = data; // Use passed data directly
    }
  }

  SubscriptionFeatureGuard get featureGuard => SubscriptionFeatureGuard(
    subscription: currentUserSubscriptionController.currentSubscription,
    userRole: userRole.value,
  );

  bool get canAccessApplicantResumeForCurrentRole =>
      userRole.value == 2
          ? featureGuard.canEmployerUsePremiumFeatures
          : featureGuard.canEmployeeUsePremiumFeatures;

  ResumeAdMode get resumeAdMode => featureGuard.resumeAdMode;

  // Future fetchProfile(int userId) async {
  //   isLoading.value = true;
  //   errorMessage.value = '';
  //   try {
  //     print('Fetching profile for userId: $userId');
  //     final endpoint = '${ApiEndPoints.userProfile}/$userId';
  //     final data = await ApiService.get(endpoint, auth: true);
  //     print('GET Response: $data');
  //     final response = ApplicantProfileResponse.fromJson(data);
  //     if (response.status) {
  //       profile.value = response.data;
  //       print('Profile loaded: ${profile.value?.email}');
  //     } else {
  //       throw Exception(response.message);
  //     }
  //   } catch (e) {
  //     print('Fetch Profile Error: $e');
  //     LogUtil.logError('fetchProfile: $e');
  //     errorMessage.value =
  //         e.toString().contains('No internet connection')
  //             ? 'No internet connection. Please check your connection and try again.'
  //             : e.toString().replaceFirst('Exception: ', '');
  //     Utilities.showSnackBar(
  //       title: 'Error',
  //       message: errorMessage.value,
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
