import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/city_response.dart';
import 'package:barbee_hive_app/data/model/experience_level_response.dart';
import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../data/api/job/job_api.dart';
import '../../../../../../data/model/color_response.dart' as colorModel;
import '../../../../../../data/model/country_response.dart';
import '../../../../../../data/model/job_type_response.dart';
import '../../../../../../data/model/salary_type_response.dart';
import '../../../../../../data/model/state_response.dart';
import '../../../../../../infrastructure/utils/utilities.dart';
import '../../../controller/job_controller.dart';

class JobUpdateController extends GetxController {
  final TextEditingController minSalaryController = TextEditingController();
  final TextEditingController maxSalaryController = TextEditingController();

  final TextEditingController recruiterController = TextEditingController();
  final TextEditingController jobDesController = TextEditingController();

  // Loading & error
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  // Dropdown selections
  final RxString selectedSkill = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;
  final RxString selectedCountry = ''.obs;
  final RxString selectedSalaryType = ''.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedJobType = ''.obs;
  final RxString imageUrl = ''.obs;

  // Image
  final Rx<File?> selectedImage = Rx<File?>(null);

  // API Data
  final RxList<colorModel.Skill> skills = <colorModel.Skill>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<SalaryType> salaryTypes = <SalaryType>[].obs;
  final RxList<JobType> jobTypes = <JobType>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<City> cities = <City>[].obs;
  final isCitiesLoading = false.obs;

  late JobListData job;

  @override
  void onInit() {
    super.onInit();
    fetchAllDropdowns();

    if (Get.arguments != null && Get.arguments is JobListData) {
      job = Get.arguments as JobListData;

      /// Set controllers text with job data
      // jobRoleController.text = job.title;
      // experienceLevelController.text = job.experienceLevel;
      minSalaryController.text = job.salaryRange.min;
      maxSalaryController.text = job.salaryRange.max;
      selectedCountry.value = job.country?.name ?? '';
      selectedSalaryType.value = job.salaryRange.type.name;

      selectedState.value = job.state?.name ?? '';
      selectedCity.value = job.city;
      recruiterController.text = job.recruiterName ?? "";
      jobDesController.text = job.description;
      imageUrl.value = job.image ?? '';
      selectedJobType.value = job.jobType.name;

      selectedSkill.value = job.skills.name ?? "";
      selectedExperienceLevel.value = job.experienceLevel ?? "";
    }
  }

  @override
  void onClose() {
    // jobRoleController.dispose();
    // experienceLevelController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    // countryController.dispose();
    // stateController.dispose();
    recruiterController.dispose();
    jobDesController.dispose();
    super.onClose();
  }

  Future<void> fetchAllDropdowns() async {
    isLoading.value = true;
    await Future.wait([
      fetchSkills(),
      fetchExperienceLevels(),
      fetchCountries(),
      fetchSalaryTypes(),
      fetchStates(),
      fetchJobTypes(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchSkills() async {
    try {
      final response = await AuthProvider.getSkills();
      if (response.status) skills.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchExperienceLevels() async {
    try {
      final response = await AuthProvider.getExperienceLevels();
      if (response.status) experienceLevels.assignAll(response.data);
    } catch (_) {}
  }



  Future<void> fetchSalaryTypes() async {
    try {
      final response = await AuthProvider.getSalaryTypes();
      if (response.status) salaryTypes.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchJobTypes() async {
    try {
      final response = await AuthProvider.getJobTypes();
      if (response.status) jobTypes.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchCountries() async {
    try {
      final response = await AuthProvider.getCountries();
      if (response.status) countries.assignAll(response.data);
    } catch (_) {}
  }

  Future<void> fetchStates() async {
    try {
      final response = await AuthProvider.getStates();
      if (response.status) {
        states.assignAll(response.data);
        if (selectedState.value.isNotEmpty) {
          final state = states.firstWhere(
            (s) => s.name == selectedState.value,
            orElse: () => StateModel(id: 0, name: ''),
          );
          if (state.id != 0) {
            await fetchCities(stateId: state.id);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> fetchCities({required int stateId}) async {
    isCitiesLoading.value = true;
    try {
      final response = await AuthProvider.getCities(stateId: stateId);
      if (response.status) {
        cities.assignAll(response.data);
      } else {
        Utilities.showSnackBar(
          title: 'Error',
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (_) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to fetch cities',
        isSuccess: false,
      );
    } finally {
      isCitiesLoading.value = false;
    }
  }


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

  Future<void> updateJob(BuildContext context) async {
    // Validate all fields
    if (
    // jobRoleController.text.isEmpty ||
    jobDesController.text.isEmpty ||
        // experienceLevelController.text.isEmpty ||
        minSalaryController.text.isEmpty ||
        maxSalaryController.text.isEmpty ||
        selectedJobType.value == null ||
        // countryController.text.isEmpty ||
        // stateController.text.isEmpty ||
        selectedCity.value.isEmpty ||
        recruiterController.text.isEmpty ||
        selectedSkill.value == null) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'All fields are required',
        isSuccess: false,
      );
      return;
    }

    // Map selected skill to skill ID
    final jobSkill = skills.firstWhere(
      (skill) => skill.name == selectedSkill.value,
      orElse: () => throw Exception('Invalid skill selected'),
    );

    final jobExperience = experienceLevels.firstWhere(
      (exp) => exp.name == selectedExperienceLevel.value,
      orElse: () => throw Exception('Invalid experience selected'),
    );

    final jobCountry = countries.firstWhere(
      (count) => count.name == selectedCountry.value,
      orElse: () => throw Exception('Invalid Country selected'),
    );

    final jobState = states.firstWhere(
      (state) => state.name == selectedState.value,
      orElse: () => throw Exception('Invalid State selected'),
    );

    final jobType = jobTypes.firstWhere(
      (type) => type.name == selectedJobType.value,
      orElse: () => throw Exception('Invalid State selected'),
    );

    final salaryType = salaryTypes.firstWhere(
      (stype) => stype.name == selectedSalaryType.value,
      orElse: () => throw Exception('Invalid Salary selected'),
    );

    // Start loading
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await JobApi.updateJob(
        salaryType: salaryType.id,
        id: job.id,
        skillId: jobSkill.id,
        experienceLevel: jobExperience.id,
        minSalary: minSalaryController.text,
        maxSalary: maxSalaryController.text,
        jobType: jobType.id,
        country: jobCountry.id.toString(),
        state: jobState.id.toString(),
        city: selectedCity.value,
        recruiterName: recruiterController.text,
        noOfDays: 2,
        // If you have a controller, replace this
        image: selectedImage.value,
        description: jobDesController.text,
      );

      if (response.status == true) {
        final controller = Get.find<JobController>();

        controller.fetchEmployerJobs();

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => CustomDialog(
                title: "Congratulations",
                subTitle: "Your Job Application Has Been Updated",
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
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(
        title: 'Error',
        message: errorMessage.value,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String get selectedImageName {
    // If user picked a new image (File)
    if (selectedImage.value != null) {
      return selectedImage.value!.path.split('/').last;
    }

    // If job already has an image URL
    if (job.image != null && job.image!.isNotEmpty) {
      return job.image!.split('/').last;
    }

    return 'Upload Image';
  }

  // Update Dropdown Selections
  void updateSkill(String? val) => selectedSkill.value = val ?? '';

  void updateExperienceLevel(String? val) =>
      selectedExperienceLevel.value = val ?? '';

  void updateJobType(String? val) => selectedJobType.value = val ?? '';

  void updateCountry(String? val) => selectedCountry.value = val ?? '';

  void updateState(String? val) {
    if (val == null) return;
    selectedState.value = val;
    selectedCity.value = '';
    cities.clear();

    final state = states.firstWhere(
      (s) => s.name == val,
      orElse: () => StateModel(id: 0, name: ''),
    );
    if (state.id != 0) {
      fetchCities(stateId: state.id);
    }
  }

  void updateCity(String? val) => selectedCity.value = val ?? '';

  void updateSalaryType(String? val) => selectedSalaryType.value = val ?? '';
}


