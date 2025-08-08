// import 'package:barbee_hive_app/data/api/auth_provider.dart';
// import 'package:barbee_hive_app/data/model/dashboard_response.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class DashboardController extends GetxController {
//   final RxList<User> employees = <User>[].obs; // Role 3 (Hive)
//   final RxList<User> employers = <User>[].obs; // Role 2 (B2B)
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchDashboardUsers();
//   }
//
//   Future<void> fetchDashboardUsers() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     try {
//       print('Fetching dashboard users');
//       final response = await AuthProvider.getDashboardUsers();
//       print('Dashboard Response: status=${response.status}, message=${response.message}');
//       // Swap assignments to match roles
//       employees.assignAll(response.data.employers); // Role 3 (Hive)
//       employers.assignAll(response.data.employees); // Role 2 (B2B)
//       print('Loaded ${employees.length} employees (Hive, role 3), ${employers.length} employers (B2B, role 2)');
//       for (var emp in employees) {
//         print('Employee ID: ${emp.id}, Role: ${emp.role}, Name: ${emp.employee?.name ?? 'None'}, Email: ${emp.email}');
//       }
//       for (var emp in employers) {
//         print('Employer ID: ${emp.id}, Role: ${emp.role}, Business Name: ${emp.employer?.businessName ?? 'None'}, Email: ${emp.email}');
//       }
//     } catch (e) {
//       print('Dashboard Error: $e');
//       errorMessage.value = e.toString().replaceFirst('Exception: GET request error: Exception: ', '');
//       errorMessage.value = errorMessage.value.startsWith('Exception: ')
//           ? errorMessage.value.replaceFirst('Exception: ', '')
//           : errorMessage.value;
//       Get.snackbar(
//         "Error",
//         errorMessage.value,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:barbee_hive_app/data/api/auth_provider.dart';
import 'package:barbee_hive_app/data/model/dashboard_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/helpers/location_service.dart';

class DashboardController extends GetxController {
  //final RxList<User> employees = <User>[].obs;// Role 3 (Hive)

  final RxList<User> employees = List<User>.generate(15, (index) {
    return User(
      id: index + 1, // IDs from 1 to 200
      email: 'email${index + 1}@example.com', // Unique email per user
      role: 3,
      isVerified: true,
      isActive: true,
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
      profileImage: '', // Empty (or set a default image)
    );
  }).obs; // .obs makes it reactive (RxList)
  final RxList<User> employers = <User>[].obs; // Role 2 (B2B)
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  RxDouble currentLatitude = 0.0.obs;
  RxDouble currentLongitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchDashboardUsers();
    getUserLocationAndFetchDashboard();
  }

  void getUserLocationAndFetchDashboard() async {
    try {
      final position = await LocationService.determinePosition();

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;

      print('Lat: ${position.latitude}, Lng: ${position.longitude}');

      await fetchDashboardUsers(); // ✅ Fetch users after getting location
    } catch (e) {
      print('Location error: $e');
      Get.snackbar(
        "Location Error",
        "Could not get current location.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<void> fetchDashboardUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      employers.clear();
      print('Fetching dashboard users');
      final response = await AuthProvider.getDashboardUsers(
        currentLatitude: currentLatitude.value.toString(),
        currentLongitude: currentLongitude.value.toString()
      );
      print(
        'Dashboard Response: status=${response.status}, message=${response.message}',
      );

      debugPrint("EMPLOYERS ${response.data.employers}");
      debugPrint("EMPLOYEES ${response.data.employees}");

      //employees.assignAll(response.data.employees); // Role 3 (Hive)
      employers.assignAll(response.data.employers); // Role 2 (B2B)
    } catch (e) {
      print('Dashboard Error: $e');
      errorMessage.value = e.toString().replaceFirst(
        'Exception: GET request error: Exception: ',
        '',
      );
      errorMessage.value =
          errorMessage.value.startsWith('Exception: ')
              ? errorMessage.value.replaceFirst('Exception: ', '')
              : errorMessage.value;
      Get.snackbar(
        "Error",
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
