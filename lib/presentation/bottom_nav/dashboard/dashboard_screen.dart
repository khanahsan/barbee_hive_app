// import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
// import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
// import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
// import 'package:barbee_hive_app/infrastructure/widgets/fading_image_carousel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:my_responsive_ui/my_responsive_ui.dart';
// import '../../../infrastructure/widgets/hexagon_clipper.dart';
// import 'controller/dashboardController.dart';
//
// class DashboardScreen extends GetView<DashboardController> {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> imagePaths = [
//       AppAssets.sampleImage,
//       AppAssets.sampleImage2,
//       AppAssets.profileImage,
//     ];
//
//     return Scaffold(
//       // appBar: appBarSection(context),
//       backgroundColor: AppColors.black,
//       body: Obx(
//             () => controller.isLoading.value
//             ? Center(child: CircularProgressIndicator())
//             : controller.errorMessage.value.isNotEmpty
//             ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 controller.errorMessage.value,
//                 style: TextStyle(color: Colors.red, fontSize: 16.sp),
//               ),
//               SizedBox(height: 10.h),
//               CustomBtn(
//                 btnTitle: 'Retry',
//                 onPressed: () => controller.fetchDashboardUsers(),
//                 buttonHeight: 50,
//                 btnBackgroundColor: AppColors.primary,
//                 btnTxtColor: AppColors.white,
//               ),
//             ],
//           ),
//         )
//             : SingleChildScrollView(
//           child: Column(
//             spacing: 30.h,
//             children: [
//               B2BSection(context),
//               FadingImageCarousel(imagePaths: imagePaths),
//               hiveSection(context),
//             ],
//           ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
//         ),
//       ),
//     );
//   }
//
//   Widget hiveSection(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//       alignment: Alignment.center,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(color: AppColors.boxBorder, width: 3.w),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         spacing: 5.h,
//         children: [
//           Text(
//             'HIVE',
//             style: Theme.of(context).textTheme.titleSmall?.copyWith(
//               color: AppColors.white,
//               fontSize: 30.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Obx(
//                 () => controller.employees.isEmpty
//                 ? Text(
//               'No Hive users found',
//               style: TextStyle(color: AppColors.white, fontSize: 16.sp),
//             )
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: controller.employees.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final user = entry.value;
//                   final name = user.employee?.name ?? user.email.split('@').first;
//                   print('Hive User ID: ${user.id}, Name: $name, Employee: ${user.employee != null}, Employee experienceYears: ${user.employee?.experienceYears}');
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w),
//                     child: HexagonAvatar(
//                       imagePath: AppAssets.profileImage,
//                       width: 85.w,
//                       height: 95.h,
//                       borderColor: index % 2 == 0 ? AppColors.white : AppColors.primary,
//                       name: name.isNotEmpty ? name : 'Unknown Employee',
//                       totalMl: user.employee?.experienceYears ?? 'N/A',
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget B2BSection(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//       alignment: Alignment.center,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(color: AppColors.boxBorder, width: 3.w),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         spacing: 5.h,
//         children: [
//           Text(
//             'B2B',
//             style: Theme.of(context).textTheme.titleSmall?.copyWith(
//               color: AppColors.white,
//               fontSize: 30.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Obx(
//                 () => controller.employers.isEmpty
//                 ? Text(
//               'No B2B users found',
//               style: TextStyle(color: AppColors.white, fontSize: 16.sp),
//             )
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: controller.employers.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final user = entry.value;
//                   final name = user.employer?.businessName ?? user.email.split('@').first;
//                   print('B2B User ID: ${user.id}, Name: $name, Employer: ${user.employer != null}, Employer position seeking: ${user.employer?.positionSeeking}');
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w),
//                     child: HexagonAvatar(
//                       imagePath: AppAssets.profileImage,
//                       width: 85.w,
//                       height: 95.h,
//                       borderColor: index % 2 == 0 ? AppColors.white : AppColors.primary,
//                       name: name.isNotEmpty ? name : 'Unknown Employer',
//                       totalMl: user.employer?.positionSeeking ?? 'N/A',
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   PreferredSize appBarSection(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(100.h),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(25.r),
//           bottomRight: Radius.circular(25.r),
//         ),
//         child: AppBar(
//           backgroundColor: AppColors.color101010,
//           toolbarHeight: 100.h,
//           elevation: 0,
//           title: Row(
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildSvgPicture(
//                     iconPath: AppAssets.menuIcon,
//                     iconHeight: 20.h,
//                     iconWidth: 20.w,
//                   ),
//                   SizedBox(width: 10.w),
//                   HexagonAvatar(
//                     imagePath: AppAssets.profileImage,
//                     width: 60.w,
//                     height: 70.h,
//                   ),
//                 ],
//               ),
//               SizedBox(width: 50.w),
//               Text(
//                 'Dashboard',
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AppColors.white,
//                   fontSize: 30.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Spacer(),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildSvgPicture(
//                     iconPath: AppAssets.bellIcon,
//                     iconHeight: 26.h,
//                     iconWidth: 26.w,
//                   ),
//                   SizedBox(width: 10.w),
//                   _buildSvgPicture(
//                     iconPath: AppAssets.filterIcon,
//                     iconHeight: 26.h,
//                     iconWidth: 26.w,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSvgPicture({
//     required String iconPath,
//     required double iconHeight,
//     required double iconWidth,
//   }) {
//     return SvgPicture.asset(
//       iconPath,
//       fit: BoxFit.cover,
//       height: iconHeight,
//       width: iconWidth,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/fading_image_carousel.dart';
import '../../../infrastructure/widgets/hexagon_clipper.dart';
import 'controller/dashboardController.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      AppAssets.sampleImage,
      AppAssets.sampleImage2,
      AppAssets.profileImage,
    ];

    return Scaffold(
      // appBar: appBarSection(context),
      backgroundColor: AppColors.black,
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : controller.errorMessage.value.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                      SizedBox(height: 10.h),
                      CustomBtn(
                        btnTitle: 'Retry',
                        onPressed: () => controller.fetchDashboardUsers(),
                        buttonHeight: 50,
                        btnBackgroundColor: AppColors.primary,
                        btnTxtColor: AppColors.white,
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    spacing: 30.h,
                    children: [
                      b2bSection(context),
                      FadingImageCarousel(imagePaths: imagePaths),
                      hiveSection(context),
                    ],
                  ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
                ),
      ),
    );
  }

  Widget hiveSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.boxBorder, width: 3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5.h,
        children: [
          Text(
            'HIVE',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(
            () =>
                controller.employees.isEmpty
                    ? Text(
                      'No Hive users found',
                      style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                    )
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            controller.employees.asMap().entries.map((entry) {
                              final index = entry.key;
                              final user = entry.value;
                              final name =
                                  user.employee?.name ??
                                  user.email.split('@').first;
                              print(
                                'Hive User ID: ${user.id}, Role: ${user.role}, Name: $name, Employee: ${user.employee != null}, Experience Years: ${user.employee?.experienceYears ?? 'null'}',
                              );
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: GestureDetector(
                                  onTap:
                                      () => Get.toNamed(
                                        Routes.hiveProfileScreen,
                                        arguments: {'currentUser': entry.value},
                                      ),
                                  child: HexagonAvatar(
                                    imagePath: AppAssets.profileImage,
                                    width: 85.w,
                                    height: 95.h,
                                    borderColor:
                                        index % 2 == 0
                                            ? AppColors.white
                                            : AppColors.primary,
                                    name:
                                        name.isNotEmpty
                                            ? name
                                            : 'Unknown Employee',
                                    totalMl:
                                        user.employee?.experienceYears ?? 'N/A',
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget b2bSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.boxBorder, width: 3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5.h,
        children: [
          Text(
            'B2B',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(
            () =>
                controller.employers.isEmpty
                    ? Text(
                      'No B2B users found',
                      style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                    )
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            controller.employers.asMap().entries.map((entry) {
                              final index = entry.key;
                              final user = entry.value;
                              final name =
                                  user.employer?.businessName ??
                                  user.email.split('@').first;
                              print(
                                'B2B User ID: ${user.id}, Role: ${user.role}, Name: $name, Employer: ${user.employer != null}, Position Seeking: ${user.employer?.positionSeeking ?? 'null'}',
                              );
                              return GestureDetector(
                                onTap:
                                    () => Get.toNamed(
                                      Routes.b2bScreen,
                                      arguments: {'currentUser': entry.value},
                                    ),

                                child: HexagonAvatar(
                                  imagePath: AppAssets.profileImage,
                                  width: 85.w,
                                  height: 95.h,
                                  borderColor:
                                      index % 2 == 0
                                          ? AppColors.white
                                          : AppColors.primary,
                                  name:
                                      name.isNotEmpty
                                          ? name
                                          : 'Unknown Employer',
                                  totalMl: "aa",
                                ),
                              );
                            }).toList(),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
