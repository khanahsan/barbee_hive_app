import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/model/color_response.dart';

class SignUpEmployeeController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final dateController = TextEditingController();
  final RxString selectedDate = ''.obs;

  final RxString selectedGender = ''.obs;
  final RxString selectedHeight = ''.obs;
  final RxString selectedEyeColor = ''.obs;
  final RxString selectedHairColor = ''.obs;
  final RxString selectedSkill = ''.obs;

  final RxList<EyeColor> eyeColors = <EyeColor>[].obs;
  final RxList<HairColor> hairColors = <HairColor>[].obs;
  final RxList<Skill> skills = <Skill>[].obs;
  final Rx<File?> selectedImage = Rx<File?>(null); // Added for image selection
  final RxString profileImageUrl = ''.obs; // Added to store profile image URL


  final Rx<File?> selectedResume = Rx<File?>(null);

  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEyeColors();
    fetchHairColors();
    fetchSkills();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
   // experienceController.dispose();
    dateController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update();
  }

  void updateGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
    }
  }

  void updateHeight(String? value) {
    if (value != null) {
      selectedHeight.value = value;
    }
  }

  void updateEyeColor(String? value) {
    if (value != null) {
      selectedEyeColor.value = value;
    }
  }

  void updateHairColor(String? value) {
    if (value != null) {
      selectedHairColor.value = value;
    }
  }

  void updateSkill(String? value) {
    if (value != null) {
      selectedSkill.value = value;
    }
  }

  void pickDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final formattedDate = DateFormat('MM-dd-yyyy').format(date);
      selectedDate.value = formattedDate; // Update RxString
      dateController.text = formattedDate; // Sync with TextEditingController
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('Selected image: ${selectedImage.value!.path}');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Image picker error: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> showImagePickerOptions() async {
    await Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black, // Replace with AppColors.black
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.white),
              title: Text('Take Photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.white),
              title: Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.white),
              title: Text('Cancel', style: TextStyle(color: Colors.white)),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> pickResume() async {
    try {
      print('Picking resume');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        selectedResume.value = File(result.files.single.path!);
        print('Selected resume: ${selectedResume.value!.path}');
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('File picker error: $e');
      Get.snackbar(
        'Error',
        'Failed to pick resume: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchEyeColors() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching eye colors');
      final response = await AuthProvider.getEyeColors();
      if (response.status) {
        eyeColors.assignAll(response.data);
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Eye Colors Error: $e');
      errorMessage.value = 'Failed to fetch eye colors';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHairColors() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching hair colors');
      final response = await AuthProvider.getHairColors();
      if (response.status) {
        hairColors.assignAll(response.data);
        //print('Fetched ${hairColors.length} hair colors: ${hairColors.map((e) => e.name).toList()}');
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Hair Colors Error: $e');
      errorMessage.value = 'Failed to fetch hair colors';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSkills() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching skills');
      final response = await AuthProvider.getSkills();
      if (response.status) {
        skills.assignAll(response.data);
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Skills Error: $e');
      errorMessage.value = 'Failed to fetch skills';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!isChecked.value) {
      Get.snackbar(
        'Error',
        'Please agree to the Terms of Service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Validate inputs
      if (selectedImage.value == null||
          nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          selectedSkill.value.isEmpty ||
          selectedDate.value.isEmpty || // Use selectedDate
          selectedGender.value.isEmpty ||
          countryController.text.isEmpty ||
          stateController.text.isEmpty || // Use selectedDate
          cityController.text.isEmpty ||
          selectedHeight.value.isEmpty ||
          selectedEyeColor.value.isEmpty ||
          selectedHairColor.value.isEmpty
      /*||
        selectedSkill.value.isEmpty*/
      ) {
        throw Exception('All fields are required');
      }

      if (passwordController.text != confirmPasswordController.text) {
        throw Exception('Passwords do not match');
      }

      // Validate DOB format
      if (!RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(selectedDate.value)) {
        throw Exception('DOB must be in MM-DD-YYYY format');
      }

      final userSkill = skills.firstWhere(
            (skill) => skill.name == selectedSkill.value,
        orElse: () => throw Exception('Invalid Skill'),
      );

      // Find eye color ID
      final eyeColor = eyeColors.firstWhere(
            (color) => color.name == selectedEyeColor.value,
        orElse: () => throw Exception('Invalid eye color'),
      );

      // Find hair color ID
      final hairColor = hairColors.firstWhere(
            (color) => color.name == selectedHairColor.value,
        orElse: () => throw Exception('Invalid hair color'),
      );

      // Find skill ID
      /*final skill = skills.firstWhere(
      (skill) => skill.name == selectedSkill.value,
      orElse: () => throw Exception('Invalid skill'),
    );*/

      final response = await AuthProvider.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: 3,
        //experienceYears: userSkill.id,
        country: countryController.text,
        state: stateController.text,
        city: cityController.text,
        dob: selectedDate.value, // Use selectedDate
        gender: selectedGender.value.toLowerCase(),
        eyeColorId: eyeColor.id,
        hairColorId: hairColor.id,
        height: int.parse(selectedHeight.value),
        resume: selectedResume.value,
        skillId: userSkill.id,
        profileImage: selectedImage.value,
      );

      if (response.status) {
        ApiService.setToken(response.data.token);
        if (response.data.user.profileImage != null) {
          profileImageUrl.value = response.data.user.profileImage!; // Store profile image URL
        }
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.CUSTOMDRAWER);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Registration Error: $e');
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}


