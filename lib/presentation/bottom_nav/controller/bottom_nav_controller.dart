import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:get/get.dart';

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
  void onInit() {
    super.onInit();
    _loadUserData();
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
