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

class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});
  
  var controller = Get.put(DashboardController());

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
     /* body: Obx(
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
      ),*/
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(
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
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  b2bSection(context),
                  FadingImageCarousel(imagePaths: imagePaths),
                  hiveSection(context),
                ],
              ),
            );
          }
        })
    );
  }

/*  Widget hiveSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, bottom: 5000.h, top: 15.h, right: 15.w),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.boxBorder, width: 3.w),
      ),
      child: */

  /*Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'HIVE',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Obx(() {
            if (controller.employees.isEmpty) {
              return Text(
                'No Hive users found',
                style: TextStyle(color: AppColors.white, fontSize: 16.sp),
              );
            }

            final users = controller.employees;
            List<Widget> rows = [];
            int index = 0;
            bool isFour = true;

            while (index < users.length) {
              int count = isFour ? 4 : 3;
              final rowUsers = users.skip(index).take(count).toList();
              index += count;
              isFour = !isFour;

              rows.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: rowUsers.asMap().entries.map((entry) {
                    final user = entry.value;
                    final name = user.employee?.name ?? user.email.split('@').first;

                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        Routes.hiveProfileScreen,
                        arguments: {'currentUser': user},
                      ),
                      child: ColoredBox(
                        color: Colors.red,
                        child: HexagonAvatar(
                          imagePath: AppAssets.profileImage,
                          width: 88.w,
                          height: 98.h,
                          borderColor: entry.key % 2 == 0 ? AppColors.white : AppColors.primary,
                          name: name.isNotEmpty ? name : 'Unknown Employee',
                          totalMl: user.employee?.experienceYears ?? 'N/A',
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(children: rows),
            );
          }),
        ],
      ),*//*


      *//*Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'HIVE',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.white,
            fontSize: 25.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(() {
          if (controller.employees.isEmpty) {
            return Text(
              'No Hive users found',
              style: TextStyle(color: AppColors.white, fontSize: 16.sp),
            );
          }

          final users = controller.employees;
          final double itemWidth = 88.w;
          final double itemHeight = 98.h;

          // Define the desired pattern based on the number of users
          final List<int> pattern = _getPattern(users.length);
          final int totalItemsInPattern = pattern.reduce((a, b) => a + b);
          final int rowCount = (users.length / totalItemsInPattern).ceil() + (users.length % totalItemsInPattern > 0 ? 1 : 0);
          final double totalHeight = rowCount * itemHeight * 0.75;

          return SizedBox(
            width: double.infinity,
            height: totalHeight,
            child: CustomMultiChildLayout(
              delegate: HoneycombLayoutDelegate(
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                users: users,
                pattern: pattern,
              ),
              children: List.generate(users.length, (index) {
                final user = users[index];
                final name = user.employee?.name ?? user.email.split('@').first;
                return LayoutId(
                  id: index,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.hiveProfileScreen,
                      arguments: {'currentUser': user},
                    ),
                    child: HexagonAvatar(
                      imagePath: AppAssets.profileImage,
                      width: itemWidth,
                      height: itemHeight,
                      borderColor: index % 2 == 0 ? AppColors.white : AppColors.primary,
                      name: name.isNotEmpty ? name : 'Unknown Employee',
                      totalMl: user.employee?.experienceYears ?? 'N/A',
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    ),*//*
      Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'HIVE',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.white,
            fontSize: 25.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(() {
          if (controller.employees.isEmpty) {
            return Text(
              'No Hive users found',
              style: TextStyle(color: AppColors.white, fontSize: 16.sp),
            );
          }

          final users = controller.employees;
          final double itemWidth = 88.w;
          final double itemHeight = 98.h;

          // Define the desired pattern based on the number of users
          final List<int> pattern = _getPattern(users.length);
          final int totalItemsInPattern = pattern.reduce((a, b) => a + b);
          final int rowCount = (users.length / totalItemsInPattern).ceil() + (users.length % totalItemsInPattern > 0 ? 1 : 0);
          final double totalHeight = rowCount * itemHeight * 0.75;

          return SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: totalHeight,
              child: CustomMultiChildLayout(
                delegate: HoneycombLayoutDelegate(
                  itemWidth: itemWidth,
                  itemHeight: itemHeight,
                  users: users,
                  pattern: pattern,
                ),
                children: [
                  for (int index = 0; index < users.length; index++)
                    LayoutId(
                      id: index,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.hiveProfileScreen,
                          arguments: {'currentUser': users[index]},
                        ),
                        child: HexagonAvatar(
                          imagePath: AppAssets.profileImage,
                          width: itemWidth,
                          height: itemHeight,
                          borderColor: index % 2 == 0 ? AppColors.white : AppColors.primary,
                          name: (users[index].employee?.name ?? users[index].email.split('@').first).isNotEmpty
                              ? (users[index].employee?.name ?? users[index].email.split('@').first)
                              : 'Unknown Employee',
                          totalMl: users[index].employee?.experienceYears ?? 'N/A',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
    );
  }*/

  RxDouble hOfW = 0.0.obs;
  Widget hiveSection(BuildContext context) {
    return Obx(() {
      final users = controller.employees;
      final double itemWidth = 78;
      final double itemHeight = 90;
      final List<int> pattern = _getPattern(users.length,itemHeight);
      final maxHeight = MediaQuery.of(context).size.height * 0.6;

      //print(" hOfW.value :${ hOfW.value} == ${320 / 80}");

      if (users.isEmpty) {
        return Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.boxBorder, width: 3.w),
          ),
          child: Center(
            child: Text(
              'No Hive users found',
              style: TextStyle(color: AppColors.white, fontSize: 16.sp),
            ),
          ),
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.red,
          border: Border.all(color: AppColors.boxBorder, width: 3.w),
        ),
        child: ColoredBox(
          color: Colors.yellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'HIVE',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.white,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15.h),



          Container(
            height: hOfW.value,
            child: ColoredBox(
              color: Colors.green,
              child: CustomMultiChildLayout(

                delegate: HoneycombLayoutDelegate(

                  itemWidth: itemWidth,
                  itemHeight: itemHeight,
                  users: users,
                  pattern: pattern,
                ),
                children: [
                  for (int index = 0; index < users.length; index++)
                    LayoutId(
                      id: index,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.hiveProfileScreen,
                          arguments: {'currentUser': users[index]},
                        ),
                        child: SingleChildScrollView(
                          child: /*HexagonAvatar(
                                        ///imagePath: AppAssets.profileImage,
                                        imagePath: users[index].profileImage.isNotEmpty == true
                                            ? users[index].profileImage
                                            : AppAssets.profileImage,
                                        width: itemWidth,
                                        height: itemHeight,
                                        borderColor: index % 2 == 0
                                            ? AppColors.white
                                            : AppColors.primary,
                                        name: (users[index].employee?.name ??
                                            users[index].email.split('@').first)
                                            .isNotEmpty
                                            ? (users[index].employee?.name ??
                                            users[index].email.split('@').first)
                                            : 'Unknown Employee',
                                        totalMl: users[index].employee?.experienceYears ?? 'N/A',
                                      ),*/
                          HexagonAvatar(
                            imagePath: users[index].profileImage.isNotEmpty == true
                                ? users[index].profileImage
                                : '', // Set to null to trigger name-based avatar
                            width: itemWidth,
                            height: itemHeight,
                            borderColor: index % 2 == 0
                                ? AppColors.white
                                : AppColors.primary,
                            name: (users[index].employee?.name ??
                                users[index].email.split('@').first)
                                .isNotEmpty
                                ? (users[index].employee?.name ??
                                users[index].email.split('@').first)
                                : 'Unknown Employee',
                            totalMl: users[index].employee?.experienceYears ?? 'N/A',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

            ],
          ),
        ),
      );
    });
  }

  List<int> _getPattern(int userCount,itemHeight) {
    hOfW.value  = 0.0;
    print("cehck :");
    if (userCount <= 0) return []; // Return empty list for invalid input
    if (userCount <= 4) {
      hOfW.value = 90;
      return [userCount];// Single row for 4 or fewer users
    }

    final List<int> basePattern = [4, 3]; // Base repeating pattern
    final int patternSum = basePattern.reduce((a, b) => a + b); // Sum of base pattern (7)
    final int fullCycles = userCount ~/ patternSum; // Number of complete 4-3 cycles
    int remaining = userCount % patternSum; // Remaining items after full cycles

    List<int> pattern = [];
    // Add full cycles of [4, 3]
    for (int i = 0; i < fullCycles; i++) {
      pattern.addAll(basePattern);
    }



    // Handle remaining items
    if (remaining > 0) {
      int index = 0;
      while (remaining > 0) {
        print("remain $remaining");
        final int itemsToAdd = remaining >= basePattern[index % basePattern.length]
            ? basePattern[index % basePattern.length]
            : remaining;
        print("items to add : $itemsToAdd");
        pattern.add(itemsToAdd);
        remaining -= itemsToAdd;
        index++;
      }

    }

    hOfW.value = (pattern.length  * 90).toDouble();

    print("HOW PSHLR : ${hOfW.value}");
    //var val = (82 * 0.75);
    // var val = (pattern.length - 1) * 20;
    var val = 31.5;
    // var result = (pattern.length - 1) * val;
    //print("pattern.length * 0.75 :==  ${result / 2}");
    var t = (pattern.length - 1) * val;
    // print("ttt : $t");
    // var res = t * val;
     hOfW.value -= t;

    print("HOW AFTER : ${hOfW.value}");

    //y = 1783






    print("------------------ ${pattern.length} == hOfW.value = ${hOfW.value}");

    return pattern;
  }
  // Widget hiveSection(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
  //     alignment: Alignment.center,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20.r),
  //       border: Border.all(color: AppColors.boxBorder, width: 3.w),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       spacing: 5.h,
  //       children: [
  //         Text(
  //           'HIVE',
  //           style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //             color: AppColors.white,
  //             fontSize: 25.sp,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         Obx(
  //           () =>
  //               controller.employees.isEmpty
  //                   ? Text(
  //                     'No Hive users found',
  //                     style: TextStyle(color: AppColors.white, fontSize: 16.sp),
  //                   )
  //                   : SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children:
  //                           controller.employees.asMap().entries.map((entry) {
  //                             final index = entry.key;
  //                             final user = entry.value;
  //                             final name =
  //                                 user.employee?.name ??
  //                                 user.email.split('@').first;
  //                             print(
  //                               'Hive User ID: ${user.id}, Role: ${user.role}, Name: $name, Employee: ${user.employee != null}, Experience Years: ${user.employee?.experienceYears ?? 'null'}',
  //                             );
  //                             return GestureDetector(
  //                               onTap:
  //                                   () => Get.toNamed(
  //                                     Routes.hiveProfileScreen,
  //                                     arguments: {'currentUser': entry.value},
  //                                   ),
  //                               child: HexagonAvatar(
  //                                 imagePath: AppAssets.profileImage,
  //                                 width: 88.w,
  //                                 height: 98.h,
  //                                 borderColor:
  //                                     index % 2 == 0
  //                                         ? AppColors.white
  //                                         : AppColors.primary,
  //                                 name:
  //                                     name.isNotEmpty
  //                                         ? name
  //                                         : 'Unknown Employee',
  //                                 totalMl:
  //                                     user.employee?.experienceYears ?? 'N/A',
  //                               ),
  //                             );
  //                           }).toList(),
  //                     ),
  //                   ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
              fontSize: 25.sp,
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
                              // print(
                              //   'B2B User ID: ${user.id}, Role: ${user.role}, Name: $name, Employer: ${user.employer != null}, Position Seeking: ${user.employer?.positionSeeking ?? 'null'}',
                              // );
                              return GestureDetector(
                                onTap:
                                    () => Get.toNamed(
                                      Routes.b2bScreen,
                                      arguments: {'currentUser': entry.value},
                                    ),

                                child: HexagonAvatar(
                                  imagePath: AppAssets.profileImage,
                                  width: 88.w,
                                  height: 98.h,
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
