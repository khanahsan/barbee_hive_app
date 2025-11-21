/*
import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/model/color_response.dart';

class SignUpEmployerController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  //final RxString selectedPositionSeeking = ''.obs;
  final RxString selectedSkill = ''.obs;

  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxList<Skill> skills = <Skill>[].obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;

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

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    update(); // Notify GetBuilder to rebuild
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
    update();
  }

  void updateSkill(String? value) {
    if (value != null) {
      selectedSkill.value = value;
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
      Utilities.showSnackBar(
        title: 'Error',
        message: errorMessage.value,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerEmployer() async {
    try {
      if (selectedImage.value == null) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Please upload a profile image',
          isSuccess: false,
        );
        return;
      }

      if (!isChecked.value) {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'You must agree to the terms & conditions',
          isSuccess: false,
        );
        return;
      }

      final userSkill = skills.firstWhere(
        (skill) => skill.name == selectedSkill.value,
        orElse: () => throw Exception('Invalid skill selected'),
      );

      isLoading.value = true;
      errorMessage.value = '';

      print("🔄 Starting Firebase registration...");

      // 🔹 Step 2: Create Firebase user
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user!.uid;
      print("✅ Firebase user created: $uid");

      try {
        // 🔹 Step 3: Register with backend API
        final response = await AuthApi.register(
          uid: uid,
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
          role: 2,
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          skillId: userSkill.id,
          profileImage: selectedImage.value,
        );

        if (!response.status) throw Exception(response.message);

        ApiService.setToken(response.data.token);
        print("✅ Backend registration successful");

        // 🔹 Step 4: Create Firestore document
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'apiUserId': '',
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'employer',
          'profileImage': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("✅ Firestore user document created");

        Utilities.showSnackBar(
          title: 'Success',
          message: response.message,
          isSuccess: true,
        );

        Get.offAllNamed(Routes.SIGN_IN_VIEW);
      } catch (apiError) {
        print("❌ Backend registration failed: $apiError");
        // 🔹 Step 5: Rollback Firebase user if backend fails
        await FirebaseAuth.instance.currentUser?.delete();
        print("⚠️ Firebase user deleted due to backend failure");

        Utilities.showSnackBar(
          title: 'Error',
          message: apiError.toString().replaceFirst('Exception: ', ''),
          isSuccess: false,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Firebase errors
      if (e.code == 'email-already-in-use') {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Email already exists in Firebase',
          isSuccess: false,
        );
      } else if (e.code == 'weak-password') {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Password is too weak',
          isSuccess: false,
        );
      } else if (e.code == 'invalid-email') {
        Utilities.showSnackBar(
          title: 'Error',
          message: 'Invalid email format',
          isSuccess: false,
        );
      } else {
        Utilities.showSnackBar(
          title: 'Error',
          message: '${e.code}: ${e.message}',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('❌ Unexpected Error: $e');
      Utilities.showSnackBar(
        title: 'Error',
        message: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
*/


import 'dart:io';
import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
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
  final selectedSkill = ''.obs;
  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final skills = <Skill>[].obs;
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

  void updateSkill(String? value) {
    if (value != null) selectedSkill.value = value;
  }

  // ---------------------- IMAGE PICKER ---------------------- //
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
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
  Future<void> registerEmployer() async {



    if (!_validateImage() || !_validateTerms()) return;

    try {
      final userSkill = skills.firstWhere(
            (s) => s.name == selectedSkill.value,
        orElse: () => throw Exception('Invalid skill selected'),
      );

      isLoading.value = true;

      // Create Firebase User
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // 🔍 Debug Print - Before registration
      print("=========== EMPLOYER REGISTRATION DATA ===========");
      print("Name: ${nameController.text}");
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");
      print("Confirm Password: ${confirmPasswordController.text}");
      print("Country: ${countryController.text}");
      print("State: ${stateController.text}");
      print("City: ${cityController.text}");
      print("Selected Skill: ${selectedSkill.value}");
      print("Skill ID: ${userSkill.id}");
      print("Image Selected: ${selectedImage.value != null}");
      if (selectedImage.value != null) {
        print("Image Path: ${selectedImage.value!.path}");
      }
      print("=================================================");

      try {
        // Register with Backend
        final apiResponse = await AuthApi.register(
          uid: uid,
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
          role: 2,
          country: countryController.text,
          state: stateController.text,
          city: cityController.text,
          skillId: userSkill.id,
          profileImage: selectedImage.value,
        );

        if (!apiResponse.status) throw Exception(apiResponse.message);

        ApiService.setToken(apiResponse.data.token);

        // Create Firestore User
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'apiUserId': '',
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'employer',
          'profileImage': apiResponse.data.user.profileImage,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Utilities.showSnackBar(
          title: 'Success',
          message: apiResponse.message,
          isSuccess: true,
        );

        Get.offAllNamed(Routes.SIGN_IN_VIEW);

      } catch (apiError) {
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
