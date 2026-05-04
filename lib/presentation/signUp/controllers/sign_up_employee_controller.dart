import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/firebase/firebase_service.dart';
import 'package:barbee_hive_app/data/model/city_response.dart';
import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/data/model/experience_level_response.dart';
import 'package:barbee_hive_app/data/model/gender_response.dart';
import 'package:barbee_hive_app/data/model/height_response.dart';
import 'package:barbee_hive_app/data/model/state_response.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider, OAuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/color_response.dart';
import '../../../infrastructure/navigation/routes.dart';

class SignUpEmployeeController extends GetxController {
  static const int _maxResumeSizeKb = 5000;

  // ======== Text Controllers ========
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // ======== Reactive Variables ========
  final RxString selectedDate = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString selectedHeight = ''.obs;
  final RxString selectedEyeColor = ''.obs;
  final RxString selectedHairColor = ''.obs;
  final RxString selectedCountry = ''.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;

  // final RxString selectedSkill = ''.obs;

  final RxList<EyeColor> eyeColors = <EyeColor>[].obs;
  final RxList<HairColor> hairColors = <HairColor>[].obs;
  final RxList<Skill> skills = <Skill>[].obs;
  final RxList<ExperienceLevel> experienceLevels = <ExperienceLevel>[].obs;
  final RxList<Gender> genders = <Gender>[].obs;
  final RxList<Height> heights = <Height>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<City> cities = <City>[].obs;

  RxList<String> selectedSkills = <String>[].obs;

  final Rx<File?> selectedImage = Rx<File?>(null); // Profile image
  final Rx<String> profileImageUrl = ''.obs; // Profile image URL

  final Rx<File?> selectedResume = Rx<File?>(null); // Resume file
  final RxString googleAccessToken = ''.obs;
  final RxString googleIdToken = ''.obs;
  final RxString appleIdentityToken = ''.obs;
  final RxString appleAuthorizationCode = ''.obs;
  final RxString appleRawNonce = ''.obs;
  bool get isAppleSignup =>
      appleIdentityToken.value.isNotEmpty &&
      appleAuthorizationCode.value.isNotEmpty;

  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isCitiesLoading = false.obs;
  final isGoogleSignInLoading = false.obs;
  final isAppleSignInLoading = false.obs;
  final errorMessage = ''.obs;

  final formKey = GlobalKey<FormState>();

  // ======== Lifecycle Methods ========
  @override
  void onInit() {
    super.onInit();
    _prefillFromGoogle();
    _prefillFromApple();
    // Fetch dropdown data
    fetchSignupDropdowns();
  }

  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dateController.dispose();
    addressController.dispose();
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
    if (value == null) return;
    selectedState.value = value;
    selectedCity.value = '';
    cities.clear();

    final state = states.firstWhere(
      (s) => s.name == value,
      orElse: () => StateModel(id: 0, name: ''),
    );
    if (state.id != 0) {
      fetchCities(stateId: state.id);
    }
  }

  void updateCity(String? value) {
    if (value != null) selectedCity.value = value;
  }

  void updateExperienceLevel(String? value) {
    if (value != null) selectedExperienceLevel.value = value;
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
  Future<void> fetchSignupDropdowns() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await AuthProvider.getDashboardDropdowns();
      if (response.status) {
        final data = response.data;

        eyeColors.assignAll(
          data.eyeColors
              .map(
                (item) =>
                    EyeColor(id: _dropdownIdToInt(item.id), name: item.name),
              )
              .toList(),
        );

        hairColors.assignAll(
          data.hairColors
              .map(
                (item) =>
                    HairColor(id: _dropdownIdToInt(item.id), name: item.name),
              )
              .toList(),
        );

        skills.assignAll(
          data.skills
              .map(
                (item) => Skill(id: _dropdownIdToInt(item.id), name: item.name),
              )
              .toList(),
        );

        experienceLevels.assignAll(
          data.experienceLevels
              .map(
                (item) =>
                    ExperienceLevel(id: item.id.toString(), name: item.name),
              )
              .toList(),
        );

        genders.assignAll(
          data.genders
              .map((item) => Gender(id: item.id.toString(), name: item.name))
              .toList(),
        );

        heights.assignAll(
          data.heights
              .map(
                (item) =>
                    Height(id: _dropdownIdToInt(item.id), name: item.name),
              )
              .toList(),
        );

        countries.assignAll(
          data.countries
              .map(
                (item) =>
                    Country(id: _dropdownIdToInt(item.id), name: item.name),
              )
              .toList(),
        );

        states.assignAll(
          data.states
              .map(
                (item) =>
                    StateModel(id: _dropdownIdToInt(item.id), name: item.name),
              )
              .toList(),
        );
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Failed to fetch dropdown data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCities({required int stateId}) async {
    isCitiesLoading.value = true;

    try {
      print('Fetching cities');
      final response = await AuthProvider.getCities(stateId: stateId);
      if (response.status) {
        cities.assignAll(response.data);
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Failed to fetch cities');
    } finally {
      isCitiesLoading.value = false;
    }
  }

  int _dropdownIdToInt(dynamic id) {
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0;
  }

  String _resolveAppleDisplayName(String? firebaseDisplayName, String email) {
    final candidates = [
      nameController.text.trim(),
      firebaseDisplayName?.trim() ?? '',
      email.contains('@') ? email.split('@').first.trim() : '',
    ];

    for (final candidate in candidates) {
      if (candidate.isNotEmpty) return candidate;
    }

    return 'Apple User';
  }

  Future<void> registerEmployee() async {
    if (googleAccessToken.value.isNotEmpty && googleIdToken.value.isNotEmpty) {
      return _registerWithGoogleCredential();
    }
    if (appleIdentityToken.value.isNotEmpty &&
        appleAuthorizationCode.value.isNotEmpty) {
      return _registerWithAppleCredential();
    }
    // 1️⃣ Validate Terms, Resume, Profile Image, and Skills
    if (!isChecked.value) {
      return _showError('Please agree to the Terms of Service');
    }
    if (selectedResume.value == null) {
      return _showError('Please upload your resume');
    }
    if (!await _ensureResumeWithinLimit()) {
      return;
    }
    // if (selectedImage.value == null && profileImageUrl.value.isEmpty) {
    //   return _showError('Please upload a profile image');
    // }

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
      debugPrint('emailController.text.trim(): ${emailController.text.trim()}');
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: FirebaseService.firestoreEmailForEmailPasswordFlow(
              emailController.text.trim(),
            ),
            password: passwordController.text.trim(),
          );
      debugPrint(
        'email: ${FirebaseService.firestoreEmailForEmailPasswordFlow(emailController.text.trim())}',
      );
      final uid = userCredential.user!.uid;

      // 3️⃣ Register with Backend API
      final response = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        email: FirebaseService.firestoreEmailForEmailPasswordFlow(
          emailController.text.trim(),
        ),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
        role: 3,
        country: countryId.toString(),
        state: stateId.toString(),
        city: selectedCity.value,
        address: addressController.text.trim(),
        experienceYears: selectedExperienceLevel.value,
        dob: selectedDate.value,
        gender: userGender.id,
        eyeColorId: eyeColor.id,
        hairColorId: hairColor.id,
        height: userHeight.id,
        resume: selectedResume.value,
        skillIds: userSkills.map((s) => s.id).toList(),
        profileImage: selectedImage.value,
      );

      debugPrint('response: ${response.data}');
      if (!response.status) throw Exception(response.message);

      ApiService.setToken(response.data.token);

      // 4️⃣ Create Firestore document
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': response.data.user.id ?? '',
        'name': nameController.text.trim(),
        'email': FirebaseService.firestoreEmailForEmailPasswordFlow(
          emailController.text.trim(),
        ),
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

  // ======== Helper Method for Error SnackBar ========
  void _showError(String message) {
    Utilities.showSnackBar(title: 'Error', message: message, isSuccess: false);
  }

  Future<bool> _ensureResumeWithinLimit() async {
    final file = selectedResume.value;
    if (file == null) {
      return false;
    }

    try {
      final sizeBytes = await file.length();
      final maxBytes = _maxResumeSizeKb * 1024;
      if (sizeBytes > maxBytes) {
        final maxMb = _maxResumeSizeKb / 1024;
        final sizeMb = sizeBytes / (1024 * 1024);
        _showError(
          'Resume must be less than ${maxMb.toStringAsFixed(2)} MB (current: ${sizeMb.toStringAsFixed(2)} MB).',
        );
        return false;
      }
    } catch (e) {
      _showError('Unable to read resume file size');
      return false;
    }

    return true;
  }

  // ======== Google Sign Up Method ========
  Future<void> signUpWithGoogle() async {
    isGoogleSignInLoading.value = true;

    try {
      final tokenResult = await FirebaseService.signInWithGoogleTokensOnly();

      if (tokenResult == null) {
        Utilities.showSnackBar(
          title: "Cancelled",
          message: "Google Sign-In was cancelled",
          isSuccess: false,
        );
        return;
      }

      final accessToken = tokenResult.authentication.accessToken;
      final idToken = tokenResult.authentication.idToken;

      if (accessToken == null || accessToken.isEmpty) {
        Utilities.showSnackBar(
          title: "Error",
          message: "Unable to retrieve Google access token",
          isSuccess: false,
        );
        return;
      }

      // Get FCM token
      String fcmToken = '';
      try {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      } catch (e) {
        debugPrint("⚠️ Failed to get FCM token: $e");
      }

      // Try to sign in with backend first
      try {
        final response = await AuthApi.googleLogin(accessToken, fcmToken);

        // User already registered, redirect to sign in
        Utilities.showSnackBar(
          title: "Already Registered",
          message: "This Google account is already registered. Please sign in.",
          isSuccess: false,
        );
        Get.back();
        return;
      } catch (backendError) {
        // User not registered, continue with signup flow
        // Pre-fill the form with Google data
        nameController.text = tokenResult.account.displayName ?? '';
        emailController.text = tokenResult.account.email;
        profileImageUrl.value = tokenResult.account.photoUrl ?? '';
        googleAccessToken.value = accessToken;
        googleIdToken.value = idToken ?? '';

        Utilities.showSnackBar(
          title: "Complete Your Profile",
          message:
              "Please fill in the remaining details to complete registration",
          isSuccess: true,
        );
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(
        title: "Google Sign-Up Failed",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isGoogleSignInLoading.value = false;
    }
  }

  // ======== Apple Sign Up Method ========
  Future<void> signUpWithApple() async {
    isAppleSignInLoading.value = true;

    try {
      final appleResult = await FirebaseService.signInWithAppleTokensOnly();

      if (appleResult == null) {
        Utilities.showSnackBar(
          title: "Cancelled",
          message: "Apple Sign-In was cancelled",
          isSuccess: false,
        );
        return;
      }

      final identityToken = appleResult.identityToken;
      final authorizationCode = appleResult.authorizationCode;
      final rawNonce = appleResult.rawNonce;
      debugPrint("🔑 Apple Identity Token: $identityToken");
      debugPrint("🔑 Apple Authorization Code: $authorizationCode");
      debugPrint("🔑 Apple Raw Nonce: $rawNonce");

      if (identityToken.isEmpty) {
        Utilities.showSnackBar(
          title: "Error",
          message: "Unable to retrieve Apple identity token",
          isSuccess: false,
        );
        return;
      }

      // Get FCM token
      String fcmToken = '';
      try {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      } catch (e) {
        debugPrint("⚠️ Failed to get FCM token: $e");
      }

      // Try to sign in with backend first
      try {
        final response = await AuthApi.appleLogin(
          identityToken: identityToken,
          authorizationCode: authorizationCode,
          rawNonce: rawNonce,
          fcmToken: fcmToken,
        );

        // User already registered, redirect to sign in
        Utilities.showSnackBar(
          title: "Already Registered",
          message: "This Apple account is already registered. Please sign in.",
          isSuccess: false,
        );
        Get.back();
        return;
      } catch (backendError) {
        // User not registered, continue with signup flow
        // Pre-fill the form with Apple data
        if (appleResult.fullName != null && appleResult.fullName!.isNotEmpty) {
          nameController.text = appleResult.fullName!;
        }
        if (appleResult.email != null && appleResult.email!.isNotEmpty) {
          emailController.text = appleResult.email!;
        }
        appleIdentityToken.value = identityToken;
        appleAuthorizationCode.value = appleResult.authorizationCode;
        appleRawNonce.value = appleResult.rawNonce;

        Utilities.showSnackBar(
          title: "Complete Your Profile",
          message:
              "Please fill in the remaining details to complete registration",
          isSuccess: true,
        );
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      Utilities.showSnackBar(
        title: "Apple Sign-Up Failed",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isAppleSignInLoading.value = false;
    }
  }

  void _prefillFromGoogle() {
    final args = Get.arguments;
    if (args is! Map) return;

    final name = args['name'] as String?;
    final email = args['email'] as String?;
    final photoUrl = args['photoUrl'] as String?;
    final accessToken = args['googleAccessToken'] as String?;
    final idToken = args['googleIdToken'] as String?;

    if (name != null && name.isNotEmpty) nameController.text = name;
    if (email != null && email.isNotEmpty) emailController.text = email;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      profileImageUrl.value = photoUrl;
    }
    if (accessToken != null && accessToken.isNotEmpty) {
      googleAccessToken.value = accessToken;
    }
    if (idToken != null && idToken.isNotEmpty) {
      googleIdToken.value = idToken;
    }
  }

  void _prefillFromApple() {
    final args = Get.arguments;
    if (args is! Map) return;

    final name = args['name'] as String?;
    final email = args['email'] as String?;
    final identityToken = args['appleIdentityToken'] as String?;
    final authorizationCode = args['appleAuthorizationCode'] as String?;
    final rawNonce = args['appleRawNonce'] as String?;
    final resolvedEmail =
        (email != null && email.isNotEmpty)
            ? email
            : identityToken != null
            ? FirebaseService.emailFromAppleIdentityToken(identityToken) ?? ''
            : '';
    final resolvedName =
        (name != null && name.isNotEmpty)
            ? name
            : _resolveAppleDisplayName(null, resolvedEmail);

    if (resolvedName.isNotEmpty) nameController.text = resolvedName;
    if (resolvedEmail.isNotEmpty) emailController.text = resolvedEmail;
    if (identityToken != null && identityToken.isNotEmpty) {
      appleIdentityToken.value = identityToken;
    }
    if (authorizationCode != null && authorizationCode.isNotEmpty) {
      appleAuthorizationCode.value = authorizationCode;
    }
    if (rawNonce != null && rawNonce.isNotEmpty) {
      appleRawNonce.value = rawNonce;
    }
  }

  Future<void> _registerWithGoogleCredential() async {
    if (googleAccessToken.value.isEmpty || googleIdToken.value.isEmpty) {
      return _showError('Google sign-in token missing. Please try again.');
    }

    // Keep existing form validations for resume/terms/skills.
    if (!isChecked.value) {
      return _showError('Please agree to the Terms of Service');
    }
    if (selectedResume.value == null) {
      return _showError('Please upload your resume');
    }
    if (!await _ensureResumeWithinLimit()) {
      return;
    }
    if (selectedImage.value == null && profileImageUrl.value.isEmpty) {
      return _showError('Please upload a profile image');
    }

    // Fallback password to satisfy API if user didn’t type one
    if (passwordController.text.isEmpty) {
      final generated = 'Gg@${DateTime.now().millisecondsSinceEpoch}';
      passwordController.text = generated;
      confirmPasswordController.text = generated;
    }

    // Continue with the regular registration logic using Google Firebase UID
    try {
      isLoading.value = true;

      // Sign in to Firebase with Google credential to get UID
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAccessToken.value,
        idToken: googleIdToken.value,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final uid = userCredential.user?.uid;
      final email = userCredential.user?.email ?? emailController.text.trim();

      if (uid == null || email.isEmpty) {
        throw Exception('Unable to complete Google signup. Please try again.');
      }

      // Reuse existing registerEmployee flow pieces by calling backend register
      // with the Google UID but skipping Firebase email/password creation.

      // Map selections (reuse the same validation logic)
      late List<Skill> userSkills;
      late EyeColor eyeColor;
      late HairColor hairColor;
      late Gender userGender;
      late Height userHeight;
      late int countryId;
      late int stateId;

      try {
        userSkills =
            skills
                .where((skill) => selectedSkills.contains(skill.name))
                .toList();
        if (userSkills.isEmpty) {
          throw Exception('Please select valid skills');
        }

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
          orElse: () => throw Exception('Please select a height'),
        );
        countryId =
            countries
                .firstWhere(
                  (c) => c.name == selectedCountry.value,
                  orElse: () => throw Exception('Please select a country'),
                )
                .id;
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

      final response = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        email: email,
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
        role: 3,
        country: countryId.toString(),
        state: stateId.toString(),
        city: selectedCity.value,
        address: addressController.text.trim(),
        experienceYears: selectedExperienceLevel.value,
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

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': response.data.user.id ?? '',
        'name': nameController.text.trim(),
        'email': email,
        'role': 'employee',
        'profileImage': response.data.user.profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'authProvider': 'google',
      });

      Utilities.showSnackBar(
        title: 'Success',
        message: response.message,
        isSuccess: true,
      );
      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      return _showError('${e.code}: ${e.message}');
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message.toLowerCase().contains('already registered')) {
        _showError(message);
        Get.offAllNamed(Routes.SIGN_IN_VIEW);
        return;
      }
      return _showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _registerWithAppleCredential() async {
    if (appleIdentityToken.value.isEmpty ||
        appleAuthorizationCode.value.isEmpty) {
      return _showError('Apple sign-in token missing. Please try again.');
    }
    if (appleRawNonce.value.isEmpty) {
      return _showError('Apple sign-in expired. Please try again.');
    }

    // Keep existing form validations for resume/image/terms/skills
    if (!isChecked.value) {
      return _showError('Please agree to the Terms of Service');
    }
    if (selectedResume.value == null) {
      return _showError('Please upload your resume');
    }
    if (!await _ensureResumeWithinLimit()) {
      return;
    }

    // Fallback password to satisfy API if user didn't type one
    if (passwordController.text.isEmpty) {
      final generated = 'Aa@${DateTime.now().millisecondsSinceEpoch}';
      passwordController.text = generated;
      confirmPasswordController.text = generated;
    }

    // Continue with the regular registration logic using Apple Firebase UID
    try {
      isLoading.value = true;

      // Sign in to Firebase with Apple credential to get UID
      final credential = OAuthProvider('apple.com').credential(
        idToken: appleIdentityToken.value,
        accessToken: appleAuthorizationCode.value,
        rawNonce: appleRawNonce.value,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final uid = userCredential.user?.uid;
      final email = userCredential.user?.email ?? emailController.text.trim();
      final resolvedName = _resolveAppleDisplayName(
        userCredential.user?.displayName,
        email,
      );

      if (uid == null || email.isEmpty) {
        throw Exception('Unable to complete Apple signup. Please try again.');
      }

      // Reuse existing registerEmployee flow pieces by calling backend register
      // with the Apple UID but skipping Firebase email/password creation.

      // Map selections (reuse the same validation logic)
      late List<Skill> userSkills;
      EyeColor? eyeColor;
      late HairColor hairColor;
      late Gender userGender;
      late Height userHeight;
      late int countryId;
      late int stateId;

      try {
        userSkills =
            skills
                .where((skill) => selectedSkills.contains(skill.name))
                .toList();
        if (userSkills.isEmpty) {
          throw Exception('Please select valid skills');
        }

        if (selectedEyeColor.value.isNotEmpty) {
          eyeColor = eyeColors.firstWhere(
            (color) => color.name == selectedEyeColor.value,
            orElse: () => throw Exception('Please select a valid eye color'),
          );
        }
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
          orElse: () => throw Exception('Please select a height'),
        );
        countryId =
            countries
                .firstWhere(
                  (c) => c.name == selectedCountry.value,
                  orElse: () => throw Exception('Please select a country'),
                )
                .id;
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

      final response = await AuthApi.register(
        uid: uid,
        name: resolvedName,
        email: email,
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
        role: 3,
        country: countryId.toString(),
        state: stateId.toString(),
        city: selectedCity.value,
        address: addressController.text.trim(),
        experienceYears: selectedExperienceLevel.value,
        dob: selectedDate.value,
        gender: userGender.id,
        eyeColorId: eyeColor?.id,
        hairColorId: hairColor.id,
        height: userHeight.id,
        resume: selectedResume.value,
        skillIds: userSkills.map((s) => s.id).toList(),
        profileImage: selectedImage.value,
      );

      if (!response.status) throw Exception(response.message);

      ApiService.setToken(response.data.token);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': response.data.user.id ?? '',
        'name': resolvedName,
        'email': email,
        'role': 'employee',
        'profileImage': response.data.user.profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'authProvider': 'apple',
      });

      Utilities.showSnackBar(
        title: 'Success',
        message: response.message,
        isSuccess: true,
      );
      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      return _showError('${e.code}: ${e.message}');
    } catch (e) {
      return _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
