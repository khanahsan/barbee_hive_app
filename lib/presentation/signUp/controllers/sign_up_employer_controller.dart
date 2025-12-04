/*
import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'package:barbee_hive_app/data/model/state_response.dart';

import '../../../data/model/color_response.dart';

class SignUpEmployerController extends GetxController {
  // ---------------------- TEXT CONTROLLERS ---------------------- //
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();

  // ---------------------- OBSERVABLES ---------------------- //
  // final selectedSkill = ''.obs;
  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;


  final selectedSkills = <String>[].obs; // for multi-select
  final skills = <Skill>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;

  final selectedImage = Rx<File?>(null);

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchSkills();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }

  // ---------------------- UI ACTIONS ---------------------- //
  void toggleCheckbox() => isChecked.toggle();

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
    update();
  }

  void updateCountry(String? value) {
    if (value != null) selectedCountry.value = value;
  }
  void updateState(String? value) {
    if (value != null) selectedState.value = value;
  }

  // void updateSkill(String? value) {
  //   if (value != null) selectedSkill.value = value;
  // }

  // ---------------------- IMAGE PICKER ---------------------- //
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to pick image: $e',
        isSuccess: false,
      );
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
        Utilities.showSnackBar(
          title: 'Error',
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to fetch countries',
        isSuccess: false,
      );
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
        Utilities.showSnackBar(
          title: 'Error',
          message: response.message,
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to fetch states',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
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
            _bottomOption(Icons.camera_alt, 'Take Photo', () {
              Get.back();
              pickImage(ImageSource.camera);
            }),
            _bottomOption(Icons.photo_library, 'Choose from Gallery', () {
              Get.back();
              pickImage(ImageSource.gallery);
            }),
            _bottomOption(Icons.cancel, 'Cancel', () => Get.back()),
          ],
        ),
      ),
    );
  }

  ListTile _bottomOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // ---------------------- FETCH SKILLS ---------------------- //
  Future<void> fetchSkills() async {
    isLoading.value = true;

    try {
      final response = await AuthProvider.getSkills();

      if (response.status) {
        skills.assignAll(response.data);
      } else {
        errorMessage.value = response.message;
        Utilities.showSnackBar(
          title: 'Error',
          message: errorMessage.value,
          isSuccess: false,
        );
      }
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to fetch skills',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------- REGISTER EMPLOYER ---------------------- //
  // Future<void> registerEmployer() async {
  //   if (!_validateImage() || !_validateTerms()) return;
  //
  //   try {
  //     // final userSkill = skills.firstWhere(
  //     //   (s) => s.name == selectedSkill.value,
  //     //   orElse: () => throw Exception('Invalid skill selected'),
  //     // );
  //
  //     final skillIds =
  //         selectedSkills
  //             .map((name) => skills.firstWhere((s) => s.name == name).id)
  //             .toList();
  //
  //     isLoading.value = true;
  //
  //     // Create Firebase User
  //     final userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text.trim(),
  //         );
  //
  //     final uid = userCredential.user!.uid;
  //
  //     // 🔍 Debug Print - Before registration
  //     print("=========== EMPLOYER REGISTRATION DATA ===========");
  //     print("Name: ${nameController.text}");
  //     print("Email: ${emailController.text}");
  //     print("Password: ${passwordController.text}");
  //     print("Confirm Password: ${confirmPasswordController.text}");
  //     print("Country: ${countryController.text}");
  //     print("State: ${stateController.text}");
  //     print("City: ${cityController.text}");
  //     // print("Selected Skill: ${selectedSkill.value}");
  //     // print("Skill ID: ${userSkill.id}");
  //     print("Image Selected: ${selectedImage.value != null}");
  //     if (selectedImage.value != null) {
  //       print("Image Path: ${selectedImage.value!.path}");
  //     }
  //     print("=================================================");
  //
  //     try {
  //       // Register with Backend
  //       final apiResponse = await AuthApi.register(
  //         uid: uid,
  //         name: nameController.text,
  //         email: emailController.text,
  //         password: passwordController.text,
  //         passwordConfirmation: confirmPasswordController.text,
  //         role: 2,
  //         country: countryController.text,
  //         state: stateController.text,
  //         city: cityController.text,
  //         skillIds: skillIds,
  //         profileImage: selectedImage.value,
  //       );
  //
  //       if (!apiResponse.status) throw Exception(apiResponse.message);
  //
  //       ApiService.setToken(apiResponse.data.token);
  //
  //       // Create Firestore User
  //       await FirebaseFirestore.instance.collection('users').doc(uid).set({
  //         'uid': uid,
  //         'apiUserId': '',
  //         'name': nameController.text.trim(),
  //         'email': emailController.text.trim(),
  //         'role': 'employer',
  //         'profileImage': apiResponse.data.user.profileImage,
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });
  //
  //       Utilities.showSnackBar(
  //         title: 'Success',
  //         message: apiResponse.message,
  //         isSuccess: true,
  //       );
  //
  //       Get.offAllNamed(Routes.SIGN_IN_VIEW);
  //     } catch (apiError) {
  //       await FirebaseAuth.instance.currentUser?.delete();
  //       Utilities.showSnackBar(
  //         title: 'Error',
  //         message: apiError.toString().replaceFirst('Exception: ', ''),
  //         isSuccess: false,
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     _handleFirebaseErrors(e);
  //   } catch (e) {
  //     Utilities.showSnackBar(
  //       title: 'Error',
  //       message: e.toString().replaceFirst('Exception: ', ''),
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> registerEmployer() async {
    // 1️⃣ Validate Terms and Profile Image
    if (!_validateImage() || !_validateTerms()) return;

    // 2️⃣ Validate selected skills
    if (selectedSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select at least one skill',
        isSuccess: false,
      );
    }

    late List<Skill> userSkills;

    try {
      // Map selected skill names to Skill objects
      userSkills =
          skills.where((skill) => selectedSkills.contains(skill.name)).toList();
      if (userSkills.isEmpty) throw Exception('Please select valid skills');
    } catch (e) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    }

    isLoading.value = true;

    try {
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
        print("===== Employer Registration Parameters =====");
        print("UID: $uid");
        print("Name: ${nameController.text}");
        print("Email: ${emailController.text}");
        print("Country: ${countryController.text}");
        print("State: ${stateController.text}");
        print("City: ${cityController.text}");
        print("Skill IDs: ${userSkills.map((s) => s.id).toList()}");
        print("Profile Image Path: ${selectedImage.value?.path}");
        print("===========================================");

        final apiResponse = await AuthApi.register(
          uid: uid,
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
          role: 2,
          // Employer role
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          skillIds: userSkills.map((s) => s.id).toList(),
          profileImage: selectedImage.value,
        );

        if (!apiResponse.status) throw Exception(apiResponse.message);

        ApiService.setToken(apiResponse.data.token);

        // 5️⃣ Create Firestore User
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'apiUserId': apiResponse.data.user.id ?? '',
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'employer',
          'profileImage': apiResponse.data.user.profileImage ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        Utilities.showSnackBar(
          title: 'Success',
          message: apiResponse.message,
          isSuccess: true,
        );

        Get.offAllNamed(Routes.SIGN_IN_VIEW);
      } catch (apiError) {
        // Delete Firebase user if backend registration fails
        await FirebaseAuth.instance.currentUser?.delete();
        Utilities.showSnackBar(
          title: 'Error',
          message: apiError.toString().replaceFirst('Exception: ', ''),
          isSuccess: false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseErrors(e);
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------- VALIDATION HELPERS ---------------------- //
  bool _validateImage() {
    if (selectedImage.value == null) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Please upload a profile image',
        isSuccess: false,
      );
      return false;
    }
    return true;
  }

  bool _validateTerms() {
    if (!isChecked.value) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'You must agree to the terms & conditions',
        isSuccess: false,
      );
      return false;
    }
    return true;
  }

  void _handleFirebaseErrors(FirebaseAuthException e) {
    String msg;

    switch (e.code) {
      case 'email-already-in-use':
        msg = 'Email already exists in Firebase';
        break;
      case 'weak-password':
        msg = 'Password is too weak';
        break;
      case 'invalid-email':
        msg = 'Invalid email format';
        break;
      default:
        msg = '${e.code}: ${e.message}';
    }

    Utilities.showSnackBar(title: 'Error', message: msg, isSuccess: false);
  }
}
*/


import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'package:barbee_hive_app/data/model/state_response.dart';

import '../../../data/model/color_response.dart';

class SignUpEmployerController extends GetxController {
  // ---------------------- TEXT CONTROLLERS ---------------------- //
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();

  // ---------------------- OBSERVABLES ---------------------- //
  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;

  final selectedSkills = <String>[].obs; // for multi-select
  final skills = <Skill>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;

  final selectedImage = Rx<File?>(null);

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchSkills();
    fetchCountries();
    fetchStates();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    cityController.dispose();
    super.onClose();
  }

  // ---------------------- UI ACTIONS ---------------------- //
  void toggleCheckbox() => isChecked.toggle();

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void updateCountry(String? value) {
    if (value != null) selectedCountry.value = value;
  }

  void updateState(String? value) {
    if (value != null) selectedState.value = value;
  }

  // ---------------------- IMAGE PICKER ---------------------- //
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) selectedImage.value = File(picked.path);
    } catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Failed to pick image: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;
    try {
      final response = await AuthProvider.getCountries();
      if (response.status) countries.assignAll(response.data);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchSkills() async {
    isLoading.value = true;
    try {
      final response = await AuthProvider.getSkills();
      if (response.status) skills.assignAll(response.data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStates() async {
    isLoading.value = true;
    try {
      final response = await AuthProvider.getStates();
      if (response.status) states.assignAll(response.data);
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------- REGISTER EMPLOYER ---------------------- //
  // Future<void> registerEmployer() async {
  //   if (!_validateImage() || !_validateTerms()) return;
  //
  //   if (selectedSkills.isEmpty) {
  //     return Utilities.showSnackBar(
  //       title: 'Error',
  //       message: 'Please select at least one skill',
  //       isSuccess: false,
  //     );
  //   }
  //
  //   if (selectedCountry.value.isEmpty || selectedState.value.isEmpty) {
  //     return Utilities.showSnackBar(
  //       title: 'Error',
  //       message: 'Please select both country and state',
  //       isSuccess: false,
  //     );
  //   }
  //
  //   final userSkills = skills
  //       .where((skill) => selectedSkills.contains(skill.name))
  //       .toList();
  //
  //   isLoading.value = true;
  //
  //   try {
  //     // 1️⃣ Create Firebase User
  //     final userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //
  //     final uid = userCredential.user!.uid;
  //
  //     // 2️⃣ Register with Backend API
  //     final apiResponse = await AuthApi.register(
  //       uid: uid,
  //       name: nameController.text.trim(),
  //       email: emailController.text.trim(),
  //       password: passwordController.text,
  //       passwordConfirmation: confirmPasswordController.text,
  //       role: 2, // Employer role
  //       country: selectedCountry.value,
  //       state: selectedState.value,
  //       city: cityController.text.trim(),
  //       skillIds: userSkills.map((s) => s.id).toList(),
  //       profileImage: selectedImage.value,
  //     );
  //
  //     if (!apiResponse.status) throw Exception(apiResponse.message);
  //
  //     ApiService.setToken(apiResponse.data.token);
  //
  //     // 3️⃣ Create Firestore User
  //     await FirebaseFirestore.instance.collection('users').doc(uid).set({
  //       'uid': uid,
  //       'apiUserId': apiResponse.data.user.id ?? '',
  //       'name': nameController.text.trim(),
  //       'email': emailController.text.trim(),
  //       'role': 'employer',
  //       'profileImage': apiResponse.data.user.profileImage ?? '',
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });
  //
  //     Utilities.showSnackBar(
  //       title: 'Success',
  //       message: apiResponse.message,
  //       isSuccess: true,
  //     );
  //
  //     Get.offAllNamed(Routes.SIGN_IN_VIEW);
  //   } on FirebaseAuthException catch (e) {
  //     _handleFirebaseErrors(e);
  //   } catch (e) {
  //     Utilities.showSnackBar(
  //       title: 'Error',
  //       message: e.toString().replaceFirst('Exception: ', ''),
  //       isSuccess: false,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> registerEmployer() async {
    // 1️⃣ Validate profile image and terms
    if (!_validateImage() || !_validateTerms()) return;

    // 2️⃣ Validate selected skills
    if (selectedSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select at least one skill',
        isSuccess: false,
      );
    }

    // 3️⃣ Validate country and state selection
    if (selectedCountry.value.isEmpty || selectedState.value.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select both country and state',
        isSuccess: false,
      );
    }

    // 4️⃣ Map selected skills to Skill objects
    final userSkills = skills
        .where((skill) => selectedSkills.contains(skill.name))
        .toList();

    if (userSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select valid skills',
        isSuccess: false,
      );
    }

    isLoading.value = true;

    try {
      // 5️⃣ Create Firebase User
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // 6️⃣ Get IDs for country and state
      final countryId = countries
          .firstWhere(
            (c) => c.name.toLowerCase() == selectedCountry.value.toLowerCase(),
        orElse: () => throw Exception('Please select a valid country'),
      )
          .id;

      final stateId = states
          .firstWhere(
            (s) => s.name.toLowerCase() == selectedState.value.toLowerCase(),
        orElse: () => throw Exception('Please select a valid state'),
      )
          .id;

      // 7️⃣ Call Backend API
      final apiResponse = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: 2, // Employer role
        country: countryId.toString(),
        state: stateId.toString(),
        city: cityController.text.trim(),
        skillIds: userSkills.map((s) => s.id).toList(),
        profileImage: selectedImage.value,
      );

      if (!apiResponse.status) throw Exception(apiResponse.message);

      ApiService.setToken(apiResponse.data.token);

      // 8️⃣ Create Firestore User
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': apiResponse.data.user.id ?? '',
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': 'employer',
        'profileImage': apiResponse.data.user.profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Utilities.showSnackBar(
        title: 'Success',
        message: apiResponse.message,
        isSuccess: true,
      );

      Get.offAllNamed(Routes.SIGN_IN_VIEW);

    } on FirebaseAuthException catch (e) {
      _handleFirebaseErrors(e);
    } catch (e) {

      log("EXCEPTION: ${e.toString()}");
      Utilities.showSnackBar(
        title: 'Error',
        message: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------- VALIDATION HELPERS ---------------------- //
  bool _validateImage() {
    if (selectedImage.value == null) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Please upload a profile image',
        isSuccess: false,
      );
      return false;
    }
    return true;
  }

  bool _validateTerms() {
    if (!isChecked.value) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'You must agree to the terms & conditions',
        isSuccess: false,
      );
      return false;
    }
    return true;
  }

  void _handleFirebaseErrors(FirebaseAuthException e) {
    String msg;
    switch (e.code) {
      case 'email-already-in-use':
        msg = 'Email already exists in Firebase';
        break;
      case 'weak-password':
        msg = 'Password is too weak';
        break;
      case 'invalid-email':
        msg = 'Invalid email format';
        break;
      default:
        msg = '${e.code}: ${e.message}';
    }
    Utilities.showSnackBar(title: 'Error', message: msg, isSuccess: false);
  }
}
