/*
import 'package:barbee_hive_app/infrastructure/constants/shared_pref_keys.dart';
import 'package:barbee_hive_app/infrastructure/helpers/shared_preference_helper.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/controller/dashboardController.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/controller/job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import 'dashboard/dashboard_screen.dart';
import 'job/job_screen.dart';
import 'message/message_screen.dart';
import 'pricing_plans/pricing_plans_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentBottomIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // User data
  int? currentUserID;
  int? role;
  String? userProfileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    currentUserID = SharedPreferenceHelper.getInt(SharedPrefKeys.userId);
    role = SharedPreferenceHelper.getInt(SharedPrefKeys.userRole);

    // currentUserID = await TokenStorage.getUserId();
    // role = await TokenStorage.getRole();

    userProfileImage = SharedPreferenceHelper.getString(
      SharedPrefKeys.userProfileImage,
    );

    setState(() {}); // Update UI after loading data
  }

  String? selectedJob;
  final List<String> jobList = ['All Jobs', 'Part Time', 'Full Time', 'Remote'];

  String? selectedPosition;
  final List<String> positionList = [
    'All Jobs',
    'Part Time',
    'Full Time',
    'Remote',
  ];

  String? selectedMinAge;
  final List<String> minAgeList = List.generate(
    100,
    (index) => (index + 1).toString(),
  );

  String? selectedMaxAge;
  final List<String> maxAgeList = List.generate(
    100,
    (index) => (index + 1).toString(),
  );

  String? selectedGender;
  final List<String> genderList = ['Any', 'Male', 'Female', 'Other'];

  String? selectedHeight;
  final List<String> heightList = ['< 4ft', '4ft - 5ft', '5ft - 6ft', '> 6ft'];

  String? selectedEyeColor;
  final List<String> eyeColorList = [
    'Any',
    'Brown',
    'Blue',
    'Green',
    'Hazel',
    'Grey',
    'Black',
  ];

  String? selectedHairColor;
  final List<String> hairColorList = [
    'Any',
    'Black',
    'Brown',
    'Blonde',
    'Red',
    'Grey',
    'White',
  ];

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Messages";
      case 2:
        return role == 2 ? "Applications" : "Jobs";
      // return "Find Jobs";
      case 3:
        return "Pricing Plans";
      default:
        return "";
    }
  }

  // Getter for screens list
  List<Widget> get screens {
    return [
      DashboardScreen(onMenuPressed: widget.onMenuPressed),
      MessageScreen(onMenuPressed: widget.onMenuPressed),
      // currentUserID != null && role != null
      //     ? MessageScreen(currentUserID: currentUserID.toString(), role: role!)
      //     : Center(child: CircularProgressIndicator()), // Fallback while loading
      JobScreen(onMenuPressed: widget.onMenuPressed),
      PricingPlansScreen(onMenuPressed: widget.onMenuPressed),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      currentBottomIndex = index;
    });
    if (currentBottomIndex == 0) {
      Get.find<DashboardController>().onInit();
    } else if (currentBottomIndex == 2) {
      Get.find<JobController>().onInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("currentUserID, $currentUserID");
    print("role, $role");
    return Scaffold(
      key: _scaffoldKey,

      // appBar: customAppbar(
      //   profileImagePath: userProfileImage,
      //   context: context,
      //   leadingTapFunction: () {
      //     widget.onMenuPressed();
      //   },
      //   title: _getAppBarTitle(currentBottomIndex),
      //   showActions: true,
      //
      //   actions:
      //       currentBottomIndex != 1 && currentBottomIndex != 3
      //           ? [
      //             _buildSvgPicture(
      //               iconPath: AppAssets.bellIcon,
      //               iconHeight: 24.h,
      //               iconWidth: 24.w,
      //             ),
      //             currentBottomIndex != 2 ? SizedBox(width: 10.w) : SizedBox(),
      //             // currentBottomIndex != 2
      //             //     ? _buildSvgPicture(
      //             //       iconPath: AppAssets.filterIcon,
      //             //       iconHeight: 24.h,
      //             //       iconWidth: 24.w,
      //             //       onTap: () {
      //             //         _scaffoldKey.currentState?.openEndDrawer();
      //             //       },
      //             //     )
      //             //     : SizedBox(),
      //           ]
      //           : null,
      // ),
      endDrawer: Drawer(
        backgroundColor: AppColors.black,
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.colorFF8600,
              title: Text("Filters"),
              titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 30.h),
            _buildDropdown(
              value: selectedJob,
              hintText: "Select Job Type",
              items: jobList,
              onChanged: (val) {
                setState(() {
                  selectedJob = val;
                });
              },
            ).paddingSymmetric(horizontal: 15.w),
            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedPosition,
              hintText: "Select Position Type",
              items: positionList,
              onChanged: (val) {
                setState(() {
                  selectedPosition = val;
                });
              },
            ).paddingSymmetric(horizontal: 15.w),
            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedMinAge,
              hintText: "Min Age",
              items: minAgeList,
              onChanged: (val) => setState(() => selectedMinAge = val),
            ).paddingSymmetric(horizontal: 15.w),
            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedMaxAge,
              hintText: "Max Age",
              items: maxAgeList,
              onChanged: (val) => setState(() => selectedMaxAge = val),
            ).paddingSymmetric(horizontal: 15.w),

            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedGender,
              hintText: "Gender",
              items: genderList,
              onChanged: (val) => setState(() => selectedGender = val),
            ).paddingSymmetric(horizontal: 15.w),

            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedHeight,
              hintText: "Height",
              items: heightList,
              onChanged: (val) => setState(() => selectedHeight = val),
            ).paddingSymmetric(horizontal: 15.w),

            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedEyeColor,
              hintText: "Eye Color",
              items: eyeColorList,
              onChanged: (val) => setState(() => selectedEyeColor = val),
            ).paddingSymmetric(horizontal: 15.w),

            SizedBox(height: 25.h),
            _buildDropdown(
              value: selectedHairColor,
              hintText: "Hair Color",
              items: hairColorList,
              onChanged: (val) => setState(() => selectedHairColor = val),
            ).paddingSymmetric(horizontal: 15.w),

            SizedBox(height: 25.h),
            CustomButton(
              buttonText: "Apply Filters",
              onTap: () {},
              buttonWidth: double.infinity,
              buttonHeight: 60.h,
              buttonColor: AppColors.colorFF8600,
              borderRadius: 10.r,
            ).paddingSymmetric(horizontal: 15.w),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: screens[currentBottomIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentBottomIndex,
        onTap: onItemTapped,
      ),
    );
  }

  Widget _buildSvgPicture({
    required String iconPath,
    required double iconHeight,
    required double iconWidth,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        fit: BoxFit.cover,
        height: iconHeight,
        width: iconWidth,
      ),
    );
  }

  Widget _buildDropdown({
    String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorA3A3A3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hintText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.colorA3A3A3,
              fontSize: 16.sp,
            ),
          ),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.colorA3A3A3),
          items:
              items.map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
*/

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/dashboard/dashboard_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/job_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/message_screen.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/pricing_plans/pricing_plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'controller/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Screen list
    final List<Widget> screens = [
      DashboardScreen(onMenuPressed: onMenuPressed),
      MessageScreen(onMenuPressed: onMenuPressed),
      JobScreen(onMenuPressed: onMenuPressed),
      PricingPlansScreen(onMenuPressed: onMenuPressed, showBackButton: false),
    ];

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.black,

        // endDrawer: Drawer(
        //   backgroundColor: AppColors.black,
        //   child: Column(
        //     children: [
        //       AppBar(
        //         backgroundColor: AppColors.colorFF8600,
        //         title: const Text("Filters"),
        //         titleTextStyle: Theme.of(
        //           context,
        //         ).textTheme.titleMedium?.copyWith(
        //           fontSize: 20.sp,
        //           fontWeight: FontWeight.w500,
        //           color: AppColors.white,
        //         ),
        //         automaticallyImplyLeading: false,
        //         actions: [
        //           IconButton(
        //             icon: const Icon(Icons.close, color: AppColors.white),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: 30.h),
        //
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedJob?.value,
        //         hintText: "Select Job Type",
        //         items: controller.jobList,
        //         onChanged: (val) => controller.selectedJob?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedPosition?.value,
        //         hintText: "Select Position Type",
        //         items: controller.positionList,
        //         onChanged:
        //             (val) => controller.selectedPosition?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedMinAge?.value,
        //         hintText: "Min Age",
        //         items: controller.minAgeList,
        //         onChanged:
        //             (val) => controller.selectedMinAge?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedMaxAge?.value,
        //         hintText: "Max Age",
        //         items: controller.maxAgeList,
        //         onChanged:
        //             (val) => controller.selectedMaxAge?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedGender?.value,
        //         hintText: "Gender",
        //         items: controller.genderList,
        //         onChanged:
        //             (val) => controller.selectedGender?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedHeight?.value,
        //         hintText: "Height",
        //         items: controller.heightList,
        //         onChanged:
        //             (val) => controller.selectedHeight?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedEyeColor?.value,
        //         hintText: "Eye Color",
        //         items: controller.eyeColorList,
        //         onChanged:
        //             (val) => controller.selectedEyeColor?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       _buildDropdown(
        //         context,
        //         value: controller.selectedHairColor?.value,
        //         hintText: "Hair Color",
        //         items: controller.hairColorList,
        //         onChanged:
        //             (val) => controller.selectedHairColor?.value = val ?? '',
        //       ).paddingSymmetric(horizontal: 15.w),
        //
        //       SizedBox(height: 25.h),
        //       CustomButton(
        //         buttonText: "Apply Filters",
        //         onTap: controller.applyFilters,
        //         buttonWidth: double.infinity,
        //         buttonHeight: 60.h,
        //         buttonColor: AppColors.colorFF8600,
        //         borderRadius: 10.r,
        //       ).paddingSymmetric(horizontal: 15.w),
        //     ],
        //   ),
        // ),
        body: screens[controller.currentBottomIndex.value],

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentBottomIndex.value,
          onTap: (index) => controller.onItemTapped(index),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorA3A3A3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value!.isEmpty ? null : value,
          hint: Text(
            hintText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.colorA3A3A3,
              fontSize: 16.sp,
            ),
          ),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.colorA3A3A3),
          items:
              items
                  .map(
                    (String val) =>
                        DropdownMenuItem<String>(value: val, child: Text(val)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
