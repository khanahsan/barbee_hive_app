import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/model/gender_response.dart';
import 'package:barbee_hive_app/data/model/height_response.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/model/color_response.dart';

class SignUpEmployeeController extends GetxController {
  // ======== Text Controllers ========
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // ======== Reactive Variables ========
  final RxString selectedDate = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString selectedHeight = ''.obs;
  final RxString selectedEyeColor = ''.obs;
  final RxString selectedHairColor = ''.obs;
  final RxString selectedSkill = ''.obs;

  final RxList<EyeColor> eyeColors = <EyeColor>[].obs;
  final RxList<HairColor> hairColors = <HairColor>[].obs;
  final RxList<Skill> skills = <Skill>[].obs;
  final RxList<Gender> genders = <Gender>[].obs;
  final RxList<Height> heights = <Height>[].obs;

  final Rx<File?> selectedImage = Rx<File?>(null); // Profile image
  final Rx<String> profileImageUrl = ''.obs; // Profile image URL

  final Rx<File?> selectedResume = Rx<File?>(null); // Resume file

  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final formKey = GlobalKey<FormState>();

  // ======== Lifecycle Methods ========
  @override
  void onInit() {
    super.onInit();
    // Fetch dropdown data
    Future.wait([
      fetchEyeColors(),
      fetchHairColors(),
      fetchSkills(),
      fetchGenders(),
      fetchHeights(),
    ]);
  }

  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dateController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }

  // ======== UI Helper Methods ========
  void toggleCheckbox() => isChecked.value = !isChecked.value;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update();
  }

  void updateGender(String? value) {
    if (value != null) selectedGender.value = value;
  }

  void updateHeight(String? value) {
    if (value != null) selectedHeight.value = value;
  }

  void updateEyeColor(String? value) {
    if (value != null) selectedEyeColor.value = value;
  }

  void updateHairColor(String? value) {
    if (value != null) selectedHairColor.value = value;
  }

  void updateSkill(String? value) {
    if (value != null) selectedSkill.value = value;
  }

  // ======== Date Picker ========
  void pickDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final formattedDate = DateFormat('MM-dd-yyyy').format(date);
      selectedDate.value = formattedDate;
      dateController.text = formattedDate;
    }
  }

  // ======== Image Picker ========
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
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
          color: Colors.black,
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
              title: Text(
                'Choose from Gallery',
                style: TextStyle(color: Colors.white),
              ),
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

  // ======== Resume Picker ========
  Future<void> pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        selectedResume.value = File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick resume: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ======== Fetch Dropdown Data ========
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

  Future<void> fetchGenders() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching Genders');
      final response = await AuthProvider.getGenders();
      if (response.status) {
        genders.assignAll(response.data);
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
      errorMessage.value = 'Failed to fetch genders';
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

  Future<void> fetchHeights() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Fetching Heights');
      final response = await AuthProvider.getHeights();
      if (response.status) {
        heights.assignAll(response.data);
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
      errorMessage.value = 'Failed to fetch heights';
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

  // ======== Registration ========
  Future<void> registerEmployee() async {
    // 1️⃣ Validate Terms, Resume, and Profile Image
    if (!isChecked.value) {
      return _showError('Please agree to the Terms of Service');
    }
    if (selectedResume.value == null) {
      return _showError('Please upload your resume');
    }
    if (selectedImage.value == null) {
      return _showError('Please upload a profile image');
    }

    // 2️⃣ Validate Dropdown selections
    late Skill userSkill;
    late EyeColor eyeColor;
    late HairColor hairColor;
    late Gender userGender;
    late Height userHeight;

    try {
      userSkill = skills.firstWhere(
        (skill) => skill.name == selectedSkill.value,
        orElse: () => throw Exception('Please select a skill'),
      );
      eyeColor = eyeColors.firstWhere(
        (color) => color.name == selectedEyeColor.value,
        orElse: () => throw Exception('Please select an eye color'),
      );
      hairColor = hairColors.firstWhere(
        (color) => color.name == selectedHairColor.value,
        orElse: () => throw Exception('Please select a hair color'),
      );

      userGender = genders.firstWhere(
        (gender) => gender.name == selectedGender.value,
        orElse: () => throw Exception('Please select a gender'),
      );

      userHeight = heights.firstWhere(
        (height) => height.name == selectedHeight.value,
        orElse: () => throw Exception('Please select a gender'),
      );
    } catch (e) {
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    }

    isLoading.value = true;

    try {
      print("🔄 Starting Firebase registration...");

      // 3️⃣ Create Firebase User
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user!.uid;
      print("✅ Firebase user created: $uid");

      try {
        // 4️⃣ Register with Backend API

        // Before calling the API
        print("===== Registration Parameters =====");
        print("UID: $uid");
        print("Name: ${nameController.text}");
        print("Email: ${emailController.text}");
        print("Password: ${passwordController.text}");
        print("Password Confirmation: ${confirmPasswordController.text}");
        print("Role: 3 (Employee)");
        print("Country: ${countryController.text}");
        print("State: ${stateController.text}");
        print("City: ${cityController.text}");
        print("Date of Birth: ${selectedDate.value}");
        print("Gender: ${userGender.name} - ${userGender.id}");
        print("EyeColor ID: ${eyeColor.id}");
        print("HairColor ID: ${hairColor.id}");
        print("Height: ${selectedHeight.value}");
        print("Resume Path: ${selectedResume.value?.path}");
        print("Skill ID: ${userSkill.id}");
        print("Profile Image Path: ${selectedImage.value?.path}");
        print("==================================");

        final response = await AuthApi.register(
          uid: uid,
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
          role: 3,
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          dob: selectedDate.value,
          gender: userGender.id,
          eyeColorId: eyeColor.id,
          hairColorId: hairColor.id,
          height: userHeight.id,
          resume: selectedResume.value,
          skillId: userSkill.id,
          profileImage: selectedImage.value,
        );

        log("EMPLOYEE REGISTER SIGN UP: ${response.data}");

        if (!response.status) throw Exception(response.message);

        ApiService.setToken(response.data.token);

        if (response.data.user.profileImage != null) {
          profileImageUrl.value = response.data.user.profileImage!;
        }

        // 5️⃣ Create Firestore document
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'apiUserId': response.data.user.id ?? '',
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'employee',
          'profileImage': response.data.user.profileImage ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        Utilities.showSnackBar(
          title: 'Success',
          message: response.message,
          isSuccess: true,
        );
        Get.offAllNamed(Routes.SIGN_IN_VIEW);
      } catch (apiError) {
        print("❌ Backend registration failed: $apiError");
        await FirebaseAuth.instance.currentUser?.delete();
        print("⚠️ Firebase user deleted due to backend failure");
        return _showError(apiError.toString().replaceFirst('Exception: ', ''));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return _showError('Email already exists in Firebase');
      } else if (e.code == 'weak-password') {
        return _showError('Password is too weak');
      } else if (e.code == 'invalid-email') {
        return _showError('Invalid email format');
      } else {
        return _showError('${e.code}: ${e.message}');
      }
    } catch (e) {
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ======== Helper Method for Error SnackBar ========
  void _showError(String message) {
    Utilities.showSnackBar(title: 'Error', message: message, isSuccess: false);
  }
}
