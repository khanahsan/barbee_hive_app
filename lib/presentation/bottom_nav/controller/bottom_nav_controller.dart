import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/widgets/customDrawer/controller/custom_drawer_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../job/controller/job_controller.dart';

class BottomNavController extends GetxController {
  /// STATE VARIABLES
  var currentBottomIndex = 0.obs;

  int? currentUserID;
  int? role;
  String? userProfileImage;

  // FILTERS
  // RxString? selectedJob = RxString('');
  // RxString? selectedPosition = RxString('');
  // RxString? selectedMinAge = RxString('');
  // RxString? selectedMaxAge = RxString('');
  // RxString? selectedGender = RxString('');
  // RxString? selectedHeight = RxString('');
  // RxString? selectedEyeColor = RxString('');
  // RxString? selectedHairColor = RxString('');

  // final List<String> jobList = ['All Jobs', 'Part Time', 'Full Time', 'Remote'];
  // final List<String> positionList = [
  //   'All Jobs',
  //   'Part Time',
  //   'Full Time',
  //   'Remote',
  // ];
  // final List<String> minAgeList = List.generate(
  //   100,
  //   (index) => (index + 1).toString(),
  // );
  // final List<String> maxAgeList = List.generate(
  //   100,
  //   (index) => (index + 1).toString(),
  // );
  // final List<String> genderList = ['Any', 'Male', 'Female', 'Other'];
  // final List<String> heightList = ['< 4ft', '4ft - 5ft', '5ft - 6ft', '> 6ft'];
  // final List<String> eyeColorList = [
  //   'Any',
  //   'Brown',
  //   'Blue',
  //   'Green',
  //   'Hazel',
  //   'Grey',
  //   'Black',
  // ];
  // final List<String> hairColorList = [
  //   'Any',
  //   'Black',
  //   'Brown',
  //   'Blonde',
  //   'Red',
  //   'Grey',
  //   'White',
  // ];

  // -----------------------
  // LIFECYCLE
  // -----------------------
  @override
  Future<void> onInit() async {
    super.onInit();
      getIndex();
    _loadUserData();
  }

  getIndex(){
    if(Get.find<CustomDrawerController>().currentIndex.value == 2){
      tabChangeForEmployeeNotifications(2);
    }
  }



  // -----------------------
  // METHODS
  // -----------------------
  Future<void> _loadUserData() async {
    currentUserID = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);
    role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);
    userProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );
    update();
  }

  void onItemTapped(int index) {
    currentBottomIndex.value = index;
    // if (index == 0) {
    //   Get.find<DashboardController>().onInit();
    // } else if (index == 2) {
    //   Get.find<JobController>().onInit();
    // }
  }

  tabChangeForEmployeeNotifications(int index) async {
    currentBottomIndex.value = index;
    currentBottomIndex.refresh();

    var jobController = Get.find<JobController>();
     print("jobController.isScreenLoaded : ${jobController.isScreenLoaded}}");
    //
    // bool isEmpty
    if(jobController.isScreenLoaded){
      await jobController.fetchEmployeeJobs();
    }


  }

  // void applyFilters() {
  //   debugPrint("Applied Filters:");
  //   debugPrint("Job: ${selectedJob?.value}");
  //   debugPrint("Position: ${selectedPosition?.value}");
  //   debugPrint("Min Age: ${selectedMinAge?.value}");
  //   debugPrint("Max Age: ${selectedMaxAge?.value}");
  //   debugPrint("Gender: ${selectedGender?.value}");
  //   debugPrint("Height: ${selectedHeight?.value}");
  //   debugPrint("Eye Color: ${selectedEyeColor?.value}");
  //   debugPrint("Hair Color: ${selectedHairColor?.value}");
  // }
}
