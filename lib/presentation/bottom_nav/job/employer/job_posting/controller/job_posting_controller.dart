/*
import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/experience_level_response.dart';
import 'package:barbee_hive_app/data/model/job_type_response.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../data/api/job/job_api.dart';
import '../../../../../../data/model/color_response.dart' as colorModel;

class JobPostingController extends GetxController {
  final TextEditingController minSalaryController = TextEditingController();
  final TextEditingController maxSalaryController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController recruiterController = TextEditingController();
  final TextEditingController jobDesController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final RxString selectedSkill = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;
  final RxString selectedJobType = ''.obs;

  final formKey = GlobalKey<FormState>();

  final Rx<File?> selectedImage = Rx<File?>(null);

  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final RxList<JobType> jobTypes = <JobType>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    print('fetchAllData called');
    isLoading.value = true;
    try {
      await Future.wait([
        fetchSkills(),
        fetchExperienceLevels(),
        fetchJobTypes(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    minSalaryController.dispose();
    maxSalaryController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    recruiterController.dispose();
    jobDesController.dispose();
    super.onClose();
  }

  Future<void> showResetPasswordDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Congratulations",
          subTitle: "Your Job Application Has Been Submitted",
        );
      },
    );
  }

  void _showError(String title, String message) {
    Utilities.showSnackBar(title: title, message: message, isSuccess: false);
  }

  void updateJobType(String? value) {
    if (value != null) {
      selectedJobType.value = value;
    }
  }

  void updateSkill(String? value) {
    if (value != null) {
      selectedSkill.value = value;
    }
  }

  void updateExperienceLevel(String? value) {
    if (value != null) selectedExperienceLevel.value = value;
  }

  Future<void> fetchSkills() async {
    try {
      print('Fetching skills');
      final response = await AuthProvider.getSkills();
      if (response.status) {
        skills.assignAll(response.data);
      } else {
        debugPrint(response.message);
        _showError('Error', 'Failed to fetch skills');
      }
    } catch (e) {
      print('Skills Error: $e');
      debugPrint('Failed to fetch skills');
      _showError('Error', 'Failed to fetch skills');
    } finally {}
  }

  Future<void> fetchExperienceLevels() async {
    try {
      final response = await AuthProvider.getExperienceLevels();
      if (response.status) {
        experienceLevels.assignAll(response.data);
      } else {
        _showError('Error', response.message);
      }
    } catch (e) {
      _showError('Error', 'Failed to fetch experience levels');
    } finally {}
  }

  Future<void> fetchJobTypes() async {
    try {
      print('Fetching Job Types');
      final response = await AuthProvider.getJobTypes();
      if (response.status) {
        jobTypes.assignAll(response.data);
      } else {
        _showError('Error', response.message);
      }
    } catch (e) {
      _showError('Error', 'Failed to fetch experience levels');
    } finally {}
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();

      // Show bottom sheet
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      );

      if (source == null) return; // user cancelled

      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('Selected image: ${selectedImage.value!.path}');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Image picker error: $e');
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to pick image: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> postJob(BuildContext context) async {
    log('postJob called');


    try {
      final userSkill = skills.firstWhere(
        (skill) => skill.name == selectedSkill.value,
        orElse: () => throw Exception('Invalid Skill'),
      );

      final userExperienceLevel = experienceLevels.firstWhere(
        (exp) => exp.name == selectedExperienceLevel.value,
        orElse: () => throw Exception('Invalid Experience Level'),
      );

      final userJobType = jobTypes.firstWhere(
        (job) => job.name == selectedJobType.value,
        orElse: () => throw Exception('Invalid Job Type'),
      );

      print('Posting job with fields:');

      isLoading.value = true;
      errorMessage.value = '';

      final response = await JobApi.postJob(
        description: jobDesController.text,
        experienceLevel: userExperienceLevel.id,
        minSalary: minSalaryController.text,
        maxSalary: maxSalaryController.text,
        jobType: userJobType.id,
        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        recruiterName: recruiterController.text,
        noOfDays: 2,
        skillId: userSkill.id,
        image: selectedImage.value,
      );

      log("RESPONSE MESSAGE: ${response.message}");

      if (response.status) {
        await showResetPasswordDialog(context);
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Job Post Error: $e');
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(
        title: 'Job Post Error',
        message: errorMessage.value,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
*/

import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/dropdown_response.dart';
import 'package:barbee_hive_app/data/model/duration_model.dart';
import 'package:barbee_hive_app/data/model/job_posting_model.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:barbee_hive_app/infrastructure/services/stripe_service.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../data/api/job/job_api.dart';

class JobPostingController extends GetxController {
  /// TEXT CONTROLLERS
  final TextEditingController minSalaryController = TextEditingController();
  final TextEditingController maxSalaryController = TextEditingController();

  // final TextEditingController countryController = TextEditingController();
  // final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController recruiterController = TextEditingController();
  final TextEditingController jobDesController = TextEditingController();

  /// LOADING & ERROR
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Nullable RX strings (Fix to avoid null errors)
  final RxString selectedSkill = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;
  final RxString selectedJobType = ''.obs;
  final RxString selectedSalaryType = ''.obs;
  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedDurationLabel = ''.obs;
  final Rx<DurationModel?> selectedDuration = Rx<DurationModel?>(null);

  /// IMAGE
  final Rx<File?> selectedImage = Rx<File?>(null);

  /// DATA LISTS
  final RxList<DropdownItem> skills = <DropdownItem>[].obs;
  final RxList<DropdownItem> experienceLevels = <DropdownItem>[].obs;
  final RxList<DropdownItem> jobTypes = <DropdownItem>[].obs;
  final RxList<DropdownItem> salaryTypes = <DropdownItem>[].obs;
  final RxList<DropdownItem> countries = <DropdownItem>[].obs;
  final RxList<DurationModel> durations = <DurationModel>[].obs;
  final RxList<DropdownItem> states = <DropdownItem>[].obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    Future.wait([fetchDurations(), fetchAllData()]);
  }

  Future<void> fetchDurations() async {
    try {
      final response = await AuthProvider.getDurations();
      durations.assignAll(response.duration);
      // if (durations.isNotEmpty) {
      //   selectedDurationLabel.value = durationLabel(durations.first);
      //   selectedDuration.value = durations.first;
      // }
    } catch (_) {}
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;

    try {
      final response = await AuthProvider.getDashboardDropdowns();
      if (response.status) {
        skills.assignAll(response.data.skills);
        experienceLevels.assignAll(response.data.experienceLevels);
        jobTypes.assignAll(response.data.jobTypes);
        salaryTypes.assignAll(response.data.salaryTypes);
        countries.assignAll(response.data.countries);
        states.assignAll(response.data.states);
      } else {
        Utilities.showSnackBar(
          title: 'Error',
          message: response.message,
          isSuccess: false,
        );
      }

      /// SET DEFAULT SELECTIONS (Fix for null value crashes)
      selectedSkill.value = '';
      selectedExperienceLevel.value = '';
      selectedJobType.value = '';
    } catch (e) {
      debugPrint("Fetch data error: $e");
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to fetch dropdown data',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    minSalaryController.dispose();
    maxSalaryController.dispose();
    // countryController.dispose();
    // stateController.dispose();
    cityController.dispose();
    recruiterController.dispose();
    jobDesController.dispose();
    super.onClose();
  }

  /// UPDATE METHODS
  void updateJobType(String? value) => selectedJobType.value = value ?? '';

  void updateSkill(String? value) => selectedSkill.value = value ?? '';

  void updateExperienceLevel(String? value) =>
      selectedExperienceLevel.value = value ?? '';

  void updateSalaryType(String? value) =>
      selectedSalaryType.value = value ?? '';

  void updateCountry(String? value) => selectedCountry.value = value ?? '';

  void updateState(String? value) => selectedState.value = value ?? '';

  Future<bool> _processPaymentIfRequired(JobPostResult? data) async {
    if (data == null || data.paymentRequired != true) return true;

    final clientSecret = data.payment?.clientSecret;

    if (clientSecret == null || clientSecret.isEmpty) {
      Utilities.showSnackBar(
        title: "Payment Error",
        message: "Payment details are missing. Please try again.",
        isSuccess: false,
      );
      return false;
    }

    try {
      if (Platform.isIOS) {
        await StripeService.instance.initPaymentSheetIOS(
          clientSecret: clientSecret,
          merchantDisplayName: 'Barbee Hive',
        );
      } else {
        await StripeService.instance.initPaymentSheetAndroid(
          clientSecret: clientSecret,
          merchantDisplayName: 'Barbee Hive',
        );
      }

      final paymentSuccess =
          await StripeService.instance.presentPaymentSheet();

      if (!paymentSuccess) {
        Utilities.showSnackBar(
          title: "Payment",
          message: "Payment was cancelled",
          isSuccess: false,
        );
      }

      return paymentSuccess;
    } catch (e) {
      Utilities.showSnackBar(
        title: "Payment Error",
        message: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  void updateDuration(String? value) {
    selectedDurationLabel.value = value ?? '';
    try {
      selectedDuration.value = durations.firstWhere(
        (duration) => durationLabel(duration) == value,
      );
    } catch (_) {
      selectedDuration.value = null;
    }
  }

  String durationLabel(DurationModel duration) {
    return '${duration.days} Day';
  }

  /// IMAGE PICKER WITH BOTTOM SHEET
  Future<void> pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();

      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          );
        },
      );

      if (source == null) return;

      final XFile? file = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (file != null) selectedImage.value = File(file.path);
    } catch (e) {
      Utilities.showSnackBar(
        title: "Error",
        message: "Image pick failed: $e",
        isSuccess: false,
      );
    }
  }

  /// POST JOB
  Future<void> postJob(BuildContext context) async {
    try {
      /// VALIDATION BEFORE API CALL
      if (selectedSkill.value == null ||
          selectedExperienceLevel.value == null ||
          selectedJobType.value == null) {
        Utilities.showSnackBar(
          title: "Missing Fields",
          message: "Please select Skill, Experience Level, and Job Type",
          isSuccess: false,
        );
        return;
      }

      if (jobDesController.text.isEmpty ||
          recruiterController.text.isEmpty ||
          cityController.text.isEmpty) {
        Utilities.showSnackBar(
          title: "Missing Fields",
          message: "Please fill all required fields",
          isSuccess: false,
        );
        return;
      }

      if (selectedDuration.value == null) {
        Utilities.showSnackBar(
          title: "Missing Fields",
          message: "Please select a duration",
          isSuccess: false,
        );
        return;
      }

      print("===== FIELD VALUES BEFORE API CALL =====");
      print("Description: ${jobDesController.text}");
      print("Min Salary: ${minSalaryController.text}");
      print("Max Salary: ${maxSalaryController.text}");
      print("City: ${cityController.text}");
      print("Recruiter: ${recruiterController.text}");
      print("Selected Skill: ${selectedSkill.value}");
      print("Selected Experience Level: ${selectedExperienceLevel.value}");
      print("Selected Job Type: ${selectedJobType.value}");
      print("========================================");

      /// MAPPING SELECTED MODELS
      final userSkill = skills.firstWhere(
        (s) => s.name == selectedSkill.value,
        orElse: () => throw Exception("Invalid Skill Selected"),
      );

      final userExp = experienceLevels.firstWhere(
        (e) => e.name == selectedExperienceLevel.value,
        orElse: () => throw Exception("Invalid Experience Level Selected"),
      );

      final userJob = jobTypes.firstWhere(
        (j) => j.name == selectedJobType.value,
        orElse: () => throw Exception("Invalid Job Type Selected"),
      );

      final salaryType = salaryTypes.firstWhere(
        (j) => j.name == selectedSalaryType.value,
        orElse: () => throw Exception("Invalid Salary Type Selected"),
      );

      final country = countries.firstWhere(
        (j) => j.name == selectedCountry.value,
        orElse: () => throw Exception("Invalid Country Selected"),
      );

      final state = states.firstWhere(
        (j) => j.name == selectedState.value,
        orElse: () => throw Exception("Invalid State Selected"),
      );

      isLoading.value = true;

      /// API CALL
      final response = await JobApi.postJob(
        description: jobDesController.text,
        experienceLevel: userExp.id,
        minSalary: minSalaryController.text,
        maxSalary: maxSalaryController.text,
        jobType: userJob.id,
        country: country.id.toString(),
        state: state.id.toString(),
        city: cityController.text,
        recruiterName: recruiterController.text,
        noOfDays: selectedDuration.value?.days ?? 0,
        skillId: userSkill.id,
        image: selectedImage.value,
        salaryType: salaryType.id,
      );

      if (response.status) {
        final paymentOk = await _processPaymentIfRequired(response.data);
        if (!paymentOk) return;

        // Finalize job if payment was required (activates the posting)
        if (response.data?.paymentRequired == true) {
          final jobId = response.data?.jobId;
          final paymentIntentId = response.data?.payment?.paymentIntentId;

          if (jobId == null || paymentIntentId == null) {
            Utilities.showSnackBar(
              title: "Payment Error",
              message: "Missing payment confirmation details.",
              isSuccess: false,
            );
            return;
          }

          final finalizeRes = await JobApi.finalizeJob(
            jobId: jobId,
            paymentIntentId: paymentIntentId,
          );

          if (!finalizeRes.status) {
            Utilities.showSnackBar(
              title: "Error",
              message: finalizeRes.message,
              isSuccess: false,
            );
            return;
          }
        }

        final controller = Get.find<JobController>();

        controller.fetchEmployerJobs();

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => CustomDialog(
                title: "Congratulations",
                subTitle: "Your Job Application Has Been Submitted",
                onDone: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Get.back();
                  Get.back();
                },
              ),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      log(e.toString().replaceFirst("Exception: ", ""));
      Utilities.showSnackBar(
        title: "Job Post Error",
        message: e.toString().replaceFirst("Exception: ", ""),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
