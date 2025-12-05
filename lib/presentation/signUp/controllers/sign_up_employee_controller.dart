import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/data/model/gender_response.dart';
import 'package:barbee_hive_app/data/model/height_response.dart';
import 'package:barbee_hive_app/data/model/state_response.dart';
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

import '../../../data/api/api_service.dart';
import '../../../data/model/color_response.dart';
import '../../../infrastructure/navigation/routes.dart';

class SignUpEmployeeController extends GetxController {
  // ======== Text Controllers ========
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // ======== Reactive Variables ========
  final RxString selectedDate = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString selectedHeight = ''.obs;
  final RxString selectedEyeColor = ''.obs;
  final RxString selectedHairColor = ''.obs;
  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;

  // final RxString selectedSkill = ''.obs;

  final RxList<EyeColor> eyeColors = <EyeColor>[].obs;
  final RxList<HairColor> hairColors = <HairColor>[].obs;
  final RxList<Skill> skills = <Skill>[].obs;
  final RxList<Gender> genders = <Gender>[].obs;
  final RxList<Height> heights = <Height>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;

  RxList<String> selectedSkills = <String>[].obs;

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
      fetchCountries(),
      fetchStates(),
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

  void updateCountry(String? value) {
    if (value != null) selectedCountry.value = value;
  }

  void updateState(String? value) {
    if (value != null) selectedState.value = value;
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
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to pick image: $e',
        isSuccess: false,
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
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to pick resume: $e',
        isSuccess: false,
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

  Future<void> fetchCountries() async {
    isLoading.value = true;

    try {
      print('Fetching countries');
      final response = await AuthProvider.getCountries();
      if (response.status) {
        countries.assignAll(response.data);
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Failed to fetch countries');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStates() async {
    isLoading.value = true;

    try {
      print('Fetching states');
      final response = await AuthProvider.getStates();
      if (response.status) {
        states.assignAll(response.data);
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Failed to fetch states');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> registerEmployee() async {
    // 1️⃣ Validate Terms, Resume, Profile Image, and Skills
    if (!isChecked.value) {
      return _showError('Please agree to the Terms of Service');
    }
    if (selectedResume.value == null) {
      return _showError('Please upload your resume');
    }
    if (selectedImage.value == null) {
      return _showError('Please upload a profile image');
    }

    late List<Skill> userSkills;
    late EyeColor eyeColor;
    late HairColor hairColor;
    late Gender userGender;
    late Height userHeight;
    late int countryId;
    late int stateId;

    try {
      // ✅ Map selected skills to Skill objects
      userSkills =
          skills.where((skill) => selectedSkills.contains(skill.name)).toList();
      if (userSkills.isEmpty) throw Exception('Please select valid skills');

      // ✅ Map selected eye color
      eyeColor = eyeColors.firstWhere(
        (color) => color.name == selectedEyeColor.value,
        orElse: () => throw Exception('Please select an eye color'),
      );

      // ✅ Map selected hair color
      hairColor = hairColors.firstWhere(
        (color) => color.name == selectedHairColor.value,
        orElse: () => throw Exception('Please select a hair color'),
      );

      // ✅ Map selected gender
      userGender = genders.firstWhere(
        (gender) => gender.name == selectedGender.value,
        orElse: () => throw Exception('Please select a gender'),
      );

      // ✅ Map selected height
      userHeight = heights.firstWhere(
        (height) => height.name == selectedHeight.value,
        orElse: () => throw Exception('Please select a height'),
      );

      // ✅ Map country name to ID
      countryId =
          countries
              .firstWhere(
                (c) => c.name == selectedCountry.value,
                orElse: () => throw Exception('Please select a country'),
              )
              .id;

      // ✅ Map state name to ID
      stateId =
          states
              .firstWhere(
                (s) => s.name == selectedState.value,
                orElse: () => throw Exception('Please select a state'),
              )
              .id;
    } catch (e) {
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    }

    isLoading.value = true;

    try {
      // 2️⃣ Create Firebase Auth User
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      final uid = userCredential.user!.uid;

      // 3️⃣ Register with Backend API
      final response = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
        role: 3,
        country: countryId.toString(),
        state: stateId.toString(),
        city: cityController.text,
        dob: selectedDate.value,
        gender: userGender.id,
        eyeColorId: eyeColor.id,
        hairColorId: hairColor.id,
        height: userHeight.id,
        resume: selectedResume.value,
        skillIds: userSkills.map((s) => s.id).toList(),
        profileImage: selectedImage.value,
      );

      if (!response.status) throw Exception(response.message);

      ApiService.setToken(response.data.token);

      // 4️⃣ Create Firestore document
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': response.data.user.id ?? '',
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': 'employee',
        'profileImage': response.data.user.profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 5️⃣ Success feedback
      Utilities.showSnackBar(
        title: 'Success',
        message: response.message,
        isSuccess: true,
      );
      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return _showError('Email already exists in Firebase');
      }
      if (e.code == 'weak-password') return _showError('Password is too weak');
      if (e.code == 'invalid-email') return _showError('Invalid email format');
      return _showError('${e.code}: ${e.message}');
    } catch (e) {
      log('EXCEPTION: ${e.toString()}');
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /* Future<void> registerEmployee() async {
    // 1️⃣ Validate Terms, Resume, and Profile Image
    if (!isChecked.value) return _showError('Please agree to the Terms of Service');
    if (selectedResume.value == null) return _showError('Please upload your resume');
    if (selectedImage.value == null) return _showError('Please upload a profile image');
    if (selectedSkills.isEmpty) return _showError('Please select at least one skill');

    late List<Skill> userSkills;
    late EyeColor eyeColor;
    late HairColor hairColor;
    late Gender userGender;
    late Height userHeight;
    late int countryId;
    late int stateId;

    try {
      // ✅ Map selected skills to Skill objects
      userSkills = skills.where((skill) => selectedSkills.contains(skill.name)).toList();
      if (userSkills.isEmpty) throw Exception('Please select valid skills');

      // ✅ Map selected eye color
      eyeColor = eyeColors.firstWhere(
            (color) => color.name == selectedEyeColor.value,
        orElse: () => throw Exception('Please select an eye color'),
      );

      // ✅ Map selected hair color
      hairColor = hairColors.firstWhere(
            (color) => color.name == selectedHairColor.value,
        orElse: () => throw Exception('Please select a hair color'),
      );

      // ✅ Map selected gender
      userGender = genders.firstWhere(
            (gender) => gender.name == selectedGender.value,
        orElse: () => throw Exception('Please select a gender'),
      );

      // ✅ Map selected height
      userHeight = heights.firstWhere(
            (height) => height.name == selectedHeight.value,
        orElse: () => throw Exception('Please select a height'),
      );

      // ✅ Map country name to ID
      countryId = countries.firstWhere(
            (c) => c.name == selectedCountry.value,
        orElse: () => throw Exception('Please select a country'),
      ).id;

      // ✅ Map state name to ID
      stateId = states.firstWhere(
            (s) => s.name == selectedState.value,
        orElse: () => throw Exception('Please select a state'),
      ).id;
    } catch (e) {
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    }

    isLoading.value = true;

    try {
      // Create Firebase User
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final uid = userCredential.user!.uid;

      // Register with Backend API
      final response = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
        role: 3,
        country: countryId.toString(),
        state: stateId.toString(),
        city: cityController.text,
        dob: selectedDate.value,
        gender: userGender.id,
        eyeColorId: eyeColor.id,
        hairColorId: hairColor.id,
        height: userHeight.id,
        resume: selectedResume.value,
        skillIds: userSkills.map((s) => s.id).toList(), // ✅ Pass selected skill IDs
        profileImage: selectedImage.value,
      );

      if (!response.status) throw Exception(response.message);

      ApiService.setToken(response.data.token);



      Utilities.showSnackBar(title: 'Success', message: response.message, isSuccess: true);
      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') return _showError('Email already exists in Firebase');
      if (e.code == 'weak-password') return _showError('Password is too weak');
      if (e.code == 'invalid-email') return _showError('Invalid email format');
      return _showError('${e.code}: ${e.message}');
    } catch (e) {
      log('EXCEPTION: ${e.toString()}');
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }*/

  // ======== Helper Method for Error SnackBar ========
  void _showError(String message) {
    Utilities.showSnackBar(title: 'Error', message: message, isSuccess: false);
  }
}
