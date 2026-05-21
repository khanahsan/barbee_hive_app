import 'dart:developer';
import 'dart:io';

import 'package:barbee_hive_app/data/api/api_service.dart';
import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/api/authentication/auth_api.dart';
import 'package:barbee_hive_app/data/api/firebase/firebase_service.dart';
import 'package:barbee_hive_app/data/model/city_response.dart';
import 'package:barbee_hive_app/data/model/country_response.dart';
import 'package:barbee_hive_app/data/model/state_response.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider, OAuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/model/color_response.dart';

class SignUpEmployerController extends GetxController {
  static const int fixedCountryId = 1;
  static const String fixedCountryName = 'United State of America';

  // ---------------------- TEXT CONTROLLERS ---------------------- //
  final nameController = TextEditingController();
  final businessTaxController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  // ---------------------- OBSERVABLES ---------------------- //
  final isChecked = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isCitiesLoading = false.obs;
  final errorMessage = ''.obs;

  final RxString selectedCountry = fixedCountryName.obs;
  final RxString selectedState = ''.obs;
  final RxString selectedCity = ''.obs;

  final selectedSkills = <String>[].obs; // for multi-select
  final skills = <Skill>[].obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<City> cities = <City>[].obs;

  final RxString profileImageUrl = ''.obs;
  final RxString googleAccessToken = ''.obs;
  final RxString googleIdToken = ''.obs;
  final RxString appleIdentityToken = ''.obs;
  final RxString appleAuthorizationCode = ''.obs;
  final RxString appleRawNonce = ''.obs;
  bool get isAppleSignup =>
      appleIdentityToken.value.isNotEmpty &&
      appleAuthorizationCode.value.isNotEmpty;
  final RxBool isGoogleSignInLoading = false.obs;
  final RxBool isAppleSignInLoading = false.obs;
  final selectedImage = Rx<File?>(null);

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _prefillFromGoogle();
    _prefillFromApple();
    fetchSkills();
    fetchStates();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // ---------------------- UI ACTIONS ---------------------- //
  void toggleCheckbox() => isChecked.toggle();

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void updateCountry(String? value) {
    selectedCountry.value = fixedCountryName;
  }

  void updateState(String? value) {
    if (value == null) return;
    selectedState.value = value;
    selectedCity.value = '';
    cityController.text = '';
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
    if (value == null) return;
    selectedCity.value = value;
    cityController.text = value;
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

  Future<void> fetchCities({required int stateId}) async {
    isCitiesLoading.value = true;
    try {
      final response = await AuthProvider.getCities(stateId: stateId);
      if (response.status) {
        cities.assignAll(response.data);
      }
    } finally {
      isCitiesLoading.value = false;
    }
  }

  // ---------------------- REGISTER EMPLOYER ---------------------- //
  Future<void> registerEmployer() async {
    print('### SignUpEmployerController.registerEmployer invoked');

    if (googleAccessToken.value.isNotEmpty && googleIdToken.value.isNotEmpty) {
      print(
        '### SignUpEmployerController.registerEmployer using Google credential signup path',
      );
      return _registerWithGoogleCredential();
    }
    if (appleIdentityToken.value.isNotEmpty &&
        appleAuthorizationCode.value.isNotEmpty) {
      print(
        '### SignUpEmployerController.registerEmployer using Apple credential signup path',
      );
      return _registerWithAppleCredential();
    }
    // 1️⃣ Validate terms. Profile image is optional.
    if (!_validateTerms()) return;

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
    if (selectedCity.value.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select a city',
        isSuccess: false,
      );
    }
    if (addressController.text.trim().isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please enter address',
        isSuccess: false,
      );
    }

    // 4️⃣ Map selected skills to Skill objects
    final userSkills =
        skills.where((skill) => selectedSkills.contains(skill.name)).toList();

    if (userSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select valid skills',
        isSuccess: false,
      );
    }

    final firestoreEmail = FirebaseService.firestoreEmailForEmailPasswordFlow(
      emailController.text.trim(),
    );
    print(
      '### SignUpEmployerController.registerEmployer email/password signup will use email: $firestoreEmail',
    );

    isLoading.value = true;

    try {
      // 5️⃣ Create Firebase User
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: firestoreEmail,
            password: passwordController.text.trim(),
          );

      final uid = userCredential.user!.uid;

      // 6️⃣ Get IDs for country and state
      final stateId =
          states
              .firstWhere(
                (s) =>
                    s.name.toLowerCase() == selectedState.value.toLowerCase(),
                orElse: () => throw Exception('Please select a valid state'),
              )
              .id;

      // 7️⃣ Call Backend API
      final apiResponse = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        businessTaxNumber: businessTaxController.text.trim(),

        ///emai check wrt to running environment
        email: firestoreEmail,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: 2,
        address: addressController.text,
        // Employer role
        country: fixedCountryId.toString(),
        state: stateId.toString(),
        city: selectedCity.value,
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
        'email': firestoreEmail,
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

  Future<void> _registerWithGoogleCredential() async {
    if (googleAccessToken.value.isEmpty || googleIdToken.value.isEmpty) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Google sign-in token missing. Please try again.',
        isSuccess: false,
      );
      return;
    }

    // Retain existing validations; profile image is optional.
    if (!_validateTerms()) return;
    if (selectedSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select at least one skill',
        isSuccess: false,
      );
    }
    if (selectedCountry.value.isEmpty || selectedState.value.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select both country and state',
        isSuccess: false,
      );
    }
    if (selectedCity.value.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select a city',
        isSuccess: false,
      );
    }
    if (addressController.text.trim().isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please enter address',
        isSuccess: false,
      );
    }

    // Fallback password if user left it blank
    if (passwordController.text.isEmpty) {
      final generated = 'Gg@${DateTime.now().millisecondsSinceEpoch}';
      passwordController.text = generated;
      confirmPasswordController.text = generated;
    }

    // Map selected skills to Skill objects
    final userSkills =
        skills.where((skill) => selectedSkills.contains(skill.name)).toList();

    if (userSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select valid skills',
        isSuccess: false,
      );
    }

    isLoading.value = true;
    try {
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

      final stateId =
          states
              .firstWhere(
                (s) =>
                    s.name.toLowerCase() == selectedState.value.toLowerCase(),
                orElse: () => throw Exception('Please select a valid state'),
              )
              .id;

      final apiResponse = await AuthApi.register(
        uid: uid,
        name: nameController.text.trim(),
        email: email,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: 2,
        // Employer role
        address: addressController.text.trim(),
        country: fixedCountryId.toString(),
        state: stateId.toString(),
        city: selectedCity.value,
        skillIds: userSkills.map((s) => s.id).toList(),
        profileImage: selectedImage.value,
        provider: 'google',
      );

      if (!apiResponse.status) throw Exception(apiResponse.message);

      ApiService.setToken(apiResponse.data.token);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': apiResponse.data.user.id ?? '',
        'name': nameController.text.trim(),
        'email': email,
        'role': 'employer',
        'profileImage': apiResponse.data.user.profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'authProvider': 'google',
      });

      Utilities.showSnackBar(
        title: 'Success',
        message: apiResponse.message,
        isSuccess: true,
      );

      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: '${e.code}: ${e.message}',
        isSuccess: false,
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (message.toLowerCase().contains('already registered')) {
        Utilities.showSnackBar(
          title: 'Error',
          message: message,
          isSuccess: false,
        );
        Get.offAllNamed(Routes.SIGN_IN_VIEW);
        return;
      }
      Utilities.showSnackBar(
        title: 'Error',
        message: message,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
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

  Future<void> _registerWithAppleCredential() async {
    if (appleIdentityToken.value.isEmpty ||
        appleAuthorizationCode.value.isEmpty) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Apple sign-in token missing. Please try again.',
        isSuccess: false,
      );
      return;
    }
    if (appleRawNonce.value.isEmpty) {
      Utilities.showSnackBar(
        title: 'Error',
        message: 'Apple sign-in expired. Please try again.',
        isSuccess: false,
      );
      return;
    }

    // Retain existing validations; profile image is optional.
    if (!_validateTerms()) return;
    if (selectedSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select at least one skill',
        isSuccess: false,
      );
    }
    if (selectedCountry.value.isEmpty || selectedState.value.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select both country and state',
        isSuccess: false,
      );
    }
    if (selectedCity.value.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select a city',
        isSuccess: false,
      );
    }
    if (addressController.text.trim().isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please enter address',
        isSuccess: false,
      );
    }

    // Fallback password if user left it blank
    if (passwordController.text.isEmpty) {
      final generated = 'Aa@${DateTime.now().millisecondsSinceEpoch}';
      passwordController.text = generated;
      confirmPasswordController.text = generated;
    }

    // Map selected skills to Skill objects
    final userSkills =
        skills.where((skill) => selectedSkills.contains(skill.name)).toList();

    if (userSkills.isEmpty) {
      return Utilities.showSnackBar(
        title: 'Error',
        message: 'Please select valid skills',
        isSuccess: false,
      );
    }

    isLoading.value = true;
    try {
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
      final businessName = nameController.text.trim();

      if (uid == null || email.isEmpty) {
        throw Exception('Unable to complete Apple signup. Please try again.');
      }

      final stateId =
          states
              .firstWhere(
                (s) =>
                    s.name.toLowerCase() == selectedState.value.toLowerCase(),
                orElse: () => throw Exception('Please select a valid state'),
              )
              .id;
      debugPrint('email: $email');

      final apiResponse = await AuthApi.register(
        uid: uid,
        name: businessName,
        email: email,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        role: 2,
        // Employer role
        address: addressController.text.trim(),
        country: fixedCountryId.toString(),
        state: stateId.toString(),
        city: selectedCity.value,
        skillIds: userSkills.map((s) => s.id).toList(),
        profileImage: selectedImage.value,
        provider: 'apple',
      );

      if (!apiResponse.status) throw Exception(apiResponse.message);

      ApiService.setToken(apiResponse.data.token);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'apiUserId': apiResponse.data.user.id ?? '',
        'name': businessName,
        'email': email,
        'role': 'employer',
        'profileImage': apiResponse.data.user.profileImage ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'authProvider': 'apple',
      });

      Utilities.showSnackBar(
        title: 'Success',
        message: apiResponse.message,
        isSuccess: true,
      );

      Get.offAllNamed(Routes.SIGN_IN_VIEW);
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(
        title: 'Error',
        message: '${e.code}: ${e.message}',
        isSuccess: false,
      );
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
}
