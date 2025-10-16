import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchSkills();
  }

  @override
  void onReady() {
    super.onReady();
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

  Future<void> registerEmployer() async {
    try {
      // 🔹 Step 1: Validate form before doing anything
      // if (!isChecked.value) {
      //   Get.snackbar(
      //     'Error',
      //     'Please agree to the Terms of Service',
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //   );
      //   return;
      // }

      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          countryController.text.isEmpty ||
          stateController.text.isEmpty ||
          cityController.text.isEmpty ||
          selectedSkill.value.isEmpty) {
        Get.snackbar(
          'Error',
          'All fields are required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
        final response = await AuthProvider.register(
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

        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.SIGN_IN_VIEW);
      } catch (apiError) {
        print("❌ Backend registration failed: $apiError");
        // 🔹 Step 5: Rollback Firebase user if backend fails
        await FirebaseAuth.instance.currentUser?.delete();
        print("⚠️ Firebase user deleted due to backend failure");

        Get.snackbar(
          'Error',
          apiError.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Firebase errors
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'Email already exists in Firebase');
      } else if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password is too weak');
      } else if (e.code == 'invalid-email') {
        Get.snackbar('Error', 'Invalid email format');
      } else {
        Get.snackbar('Error', '${e.code}: ${e.message}');
      }
    } catch (e) {
      print('❌ Unexpected Error: $e');
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
