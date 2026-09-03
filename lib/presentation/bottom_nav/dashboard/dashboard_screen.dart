import 'dart:developer';

import 'package:barbee_hive_app/data/api/profile/profile_api.dart';
import 'package:barbee_hive_app/infrastructure/helpers/ads_services.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dropdown.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_appbar.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/hexagon_clipper.dart';
import 'controller/dashboardController.dart';

class DashboardScreen extends GetView<DashboardController> {
  DashboardScreen({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     controller.getUnreadCount();
        //   },
        // ),
        key: _scaffoldKey,
        endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Drawer(
            backgroundColor: AppColors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: AppColors.colorFF8600,
                    title: const Text("Filters"),
                    titleTextStyle: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorFFFFFF,
                    ),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.colorFFFFFF,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedJob.value,
                      hintText: "Job Type",
                      items: controller.jobList,
                      onChanged: (val) => controller.selectedJob.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedPosition.value,
                      hintText: "Experience Level",
                      items: controller.positionList,
                      onChanged:
                          (val) => controller.selectedPosition.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedSkill.value,
                      hintText: "Position",
                      items: controller.skillList,
                      onChanged: (val) => controller.selectedSkill.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedMinAge.value,
                      hintText: "Min Age",
                      items: controller.minAgeList,
                      onChanged: (val) => controller.selectedMinAge.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedMaxAge.value,
                      hintText: "Max Age",
                      items: controller.maxAgeList,
                      onChanged: (val) => controller.selectedMaxAge.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedGender.value,
                      hintText: "Gender",
                      items: controller.genderList,
                      onChanged: (val) => controller.selectedGender.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedHeight.value,
                      hintText: "Height",
                      items: controller.heightList,
                      onChanged: (val) => controller.selectedHeight.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  // SizedBox(height: 25.h),
                  // Obx(
                  //   () => _buildDropdown(
                  //     context,
                  //     value: controller.selectedEyeColor.value,
                  //     hintText: "Eye Color",
                  //     items: controller.eyeColorList,
                  //     onChanged:
                  //         (val) => controller.selectedEyeColor.value = val,
                  //   ).paddingSymmetric(horizontal: 15.w),
                  // ),
                  SizedBox(height: 25.h),
                  Obx(
                    () => _buildDropdown(
                      context,
                      value: controller.selectedHairColor.value,
                      hintText: "Hair Color",
                      items: controller.hairColorList,
                      onChanged:
                          (val) => controller.selectedHairColor.value = val,
                    ).paddingSymmetric(horizontal: 15.w),
                  ),

                  SizedBox(height: 25.h),
                  CustomBtn(
                    btnTitle: "Apply Filters",
                    onPressed: controller.applyFilters,
                    buttonWidth: double.infinity,
                    buttonHeight: 60.h,
                    btnBackgroundColor: AppColors.colorFF8600,
                    borderRadius: 10.r,
                  ).paddingSymmetric(horizontal: 15.w),

                  SizedBox(height: 15.h),
                  CustomBtn(
                    btnTitle: "Reset Filters",
                    onPressed: controller.resetFilters,
                    buttonWidth: double.infinity,
                    buttonHeight: 60.h,
                    btnBackgroundColor: AppColors.colorA3A3A3,
                    borderRadius: 10.r,
                  ).paddingSymmetric(horizontal: 15.w),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
        appBar: customAppbar(
          showHexagon: true,
          hexagonTapFunction: () {
            Get.toNamed(Routes.PROFILE_SCREEN);
          },
          profileImagePath: controller.userProfileImage.value,
          // profileName: controller.userName.value,
          context: context,
          leadingTapFunction: () {
            if (onMenuPressed != null) onMenuPressed!();
          },
          showActions: true,
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await Get.toNamed(Routes.notificationsScreen);
                controller.count.value = 0;
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    AppAssets.bellIcon,
                    height: 24.h,
                    width: 24.w,
                  ),

                  // Badge
                  controller.count.value > 0
                      ? Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 16.r,
                            minWidth: 16.r,
                          ),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Obx(
                            () => Text(
                              controller.count.value.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                height: 1, // 👈 IMPORTANT
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(width: 15.w),

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: SvgPicture.asset(
                AppAssets.filterIcon,
                height: 24.h,
                width: 24.w,
              ),
            ),
          ],
          // titleWidget: RichText(
          //   text: TextSpan(
          //     style: TextStyle(fontSize: 12, color: AppColors.colorFFFFFF),
          //     children: [
          //       TextSpan(
          //         text: 'Bar',
          //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //           fontSize: 32.sp,
          //           color: AppColors.colorFFFFFF,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       TextSpan(
          //         text: 'Bee',
          //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //           fontSize: 32.sp,
          //           color: AppColors.colorFF8600,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       TextSpan(text: " "),
          //
          //       TextSpan(
          //         text: 'INC.',
          //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //           fontSize: 16.sp,
          //           color: AppColors.colorFFFFFF,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          titleWidget: Image.asset(
            AppAssets.appLogo4,
            width: 70.w,
            height: 70.h,
            fit: BoxFit.contain,
          ),
          title: '',
        ),
        backgroundColor: AppColors.black,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: const DashboardBannerAdWidget(),
          ),
        ),
        body: Obx(() {
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    title: controller.errorMessage.value,
                    fontSize: 16,
                    color: AppColors.expiredBannerColor,
                  ),
                  CustomBtn(
                    btnTitle: 'Retry',
                    onPressed: () => controller.fetchDashboardUsers(),
                    buttonHeight: 50,
                    btnBackgroundColor: AppColors.colorFF8600,
                    btnTxtColor: AppColors.colorFFFFFF,
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getUserLocationAndFetchDashboard();
                await controller.fetchUserProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // <- Important

                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 25.h,
                  children: [
                    // if(controller.userID.value == 3)
                    // GestureDetector(
                    //   onTap: () {
                    //     Clipboard.setData(
                    //       ClipboardData(text: controller.fcmToken.value),
                    //     );
                    //
                    //     Get.snackbar(
                    //       'Copied',
                    //       'FCM token copied to clipboard',
                    //       snackPosition: SnackPosition.BOTTOM,
                    //       backgroundColor: Colors.black87,
                    //       colorText: Colors.white,
                    //       margin: const EdgeInsets.all(12),
                    //       duration: const Duration(seconds: 2),
                    //     );
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(12.w),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8.r),
                    //       border: Border.all(color: AppColors.colorFF8600),
                    //     ),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Expanded(
                    //           child: CustomText(
                    //             title: controller.fcmToken.value,
                    //             fontSize: 14,
                    //             color: AppColors.colorFFFFFF,
                    //           ),
                    //         ),
                    //         SizedBox(width: 10.w),
                    //         Icon(
                    //           Icons.copy,
                    //           color: AppColors.colorFF8600,
                    //           size: 20.sp,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    //
                    // if(controller.userID.value == 3)
                    //   GestureDetector(
                    //   onTap: () {
                    //     Clipboard.setData(
                    //       ClipboardData(text: controller.testToken.value),
                    //     );
                    //
                    //     Get.snackbar(
                    //       'Copied',
                    //       'Test token copied to clipboard',
                    //       snackPosition: SnackPosition.BOTTOM,
                    //       backgroundColor: Colors.black87,
                    //       colorText: Colors.white,
                    //       margin: const EdgeInsets.all(12),
                    //       duration: const Duration(seconds: 2),
                    //     );
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(12.w),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8.r),
                    //       border: Border.all(color: AppColors.colorFF8600),
                    //     ),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Expanded(
                    //           child: CustomText(
                    //             title: controller.testToken.value,
                    //             fontSize: 14,
                    //             color: AppColors.colorFFFFFF,
                    //           ),
                    //         ),
                    //         SizedBox(width: 10.w),
                    //         Icon(
                    //           Icons.copy,
                    //           color: AppColors.colorFF8600,
                    //           size: 20.sp,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    /// B2B SECTION
                    b2bSection(context),

                    /// HIVE SECTION
                    hiveSection(context),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget hiveSection(BuildContext context) {
    return Obx(() {
      final users = controller.employees;
      final double itemWidth = 82.w;
      final double itemHeight = 92.h;
      final (List<int> pattern, double hiveHeight) = _getPattern(
        users.length,
        itemHeight,
      );

      if (controller.isLoading.value) {
        return AppShimmer(height: 450.h, width: double.infinity);
      }
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
              style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16.sp),
            ),
          ),
        );
      }

      return Container(
        width: double.infinity,
        child: Column(
          // A multi-row honeycomb can be wider than the screen (it's sized
          // to its widest row), so centering it clipped the leftmost hexagon
          // equally off both edges — left-align it in that case. A single
          // row (<=4 users) is never wider than the screen though, so it
          // should stay centered rather than being forced flush-left too.
          crossAxisAlignment:
              pattern.length <= 1
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'HIVE',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.colorFFFFFF,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),

            Container(
              height: hiveHeight,
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
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          debugPrint('userIndex: ${users[index].id}');
                          try {
                            final response = await ProfileApi.getUserProfile(
                              users[index].id,
                            );

                            if (!response.status) {
                              Utilities.showSnackBar(
                                title: 'Profile View Limit',
                                message: response.message,
                                isSuccess: false,
                              );
                              return;
                            }

                            Get.toNamed(
                              Routes.hiveProfileScreen,
                              arguments: {
                                'currentUser': users[index],
                                'viewedUserId': users[index].id,
                              },
                            );
                          } catch (e) {
                            Utilities.showSnackBar(
                              title: 'Error',
                              message: e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              ),
                              isSuccess: false,
                            );
                          }
                        },
                        child: SingleChildScrollView(
                          child: HexagonAvatar(
                            imagePath:
                                users[index].profileImage?.isNotEmpty == true
                                    ? users[index].profileImage ?? ''
                                    : '',
                            // Set to null to trigger name-based avatar
                            width: itemWidth,
                            height: itemHeight,
                            borderColor:
                                index % 2 == 0
                                    ? AppColors.colorFFFFFF
                                    : AppColors.colorFF8600,
                            name:
                                (users[index].employee?.name ??
                                            users[index].email.split('@').first)
                                        .isNotEmpty
                                    ? (users[index].employee?.name ??
                                        users[index].email.split('@').first)
                                    : 'Unknown Employee',
                            totalMl: _formatHiveDistance(users[index].distance),
                            isBoosted:
                                users[index].employee?.hasActiveBoost ?? false,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatHiveDistance(String? distance) {
    final value = distance?.trim();
    if (value == null || value.isEmpty || value.toLowerCase() == 'null') {
      return '';
    }

    return '$value MI';
  }

  (List<int>, double) _getPattern(int userCount, itemHeight) {
    double hOfW = 0.0;
    print("cehck :");
    if (userCount <= 0) {
      return (<int>[], hOfW); // Return empty list for invalid input
    }
    if (userCount <= 4) {
      hOfW = 90;
      return ([userCount], hOfW); // Single row for 4 or fewer users
    }

    final List<int> basePattern = [4, 5]; // Base repeating pattern
    final int patternSum = basePattern.reduce(
      (a, b) => a + b,
    ); // Sum of base pattern (9)
    final int fullCycles =
        userCount ~/ patternSum; // Number of complete 4-5 cycles
    int remaining = userCount % patternSum; // Remaining items after full cycles

    List<int> pattern = [];
    // Add full cycles of [4, 5]
    for (int i = 0; i < fullCycles; i++) {
      pattern.addAll(basePattern);
    }

    // Handle remaining items. Store each row's full intended slot width (4
    // or 5) rather than the truncated leftover count — otherwise a partially
    // filled last row (e.g. only 2 users left for what should be a 5-row)
    // gets centered as if it were genuinely a narrow row, throwing off its
    // honeycomb offset relative to the other rows of the same slot type.
    // The layout delegate already stops rendering once it runs out of real
    // users, so this only affects positioning, not how many hexagons show.
    if (remaining > 0) {
      int index = 0;
      while (remaining > 0) {
        final int slotWidth = basePattern[index % basePattern.length];
        print("remain $remaining, slot width $slotWidth");
        pattern.add(slotWidth);
        remaining -= slotWidth;
        index++;
      }
    }

    hOfW = (pattern.length * 90).toDouble();

    print("HOW PSHLR : $hOfW");
    //var val = (82 * 0.75);
    // var val = (pattern.length - 1) * 20;
    var val = 31.5;
    // var result = (pattern.length - 1) * val;
    //print("pattern.length * 0.75 :==  ${result / 2}");
    var t = (pattern.length - 1) * val;
    // print("ttt : $t");
    // var res = t * val;
    hOfW -= t;

    print("HOW AFTER : $hOfW");

    //y = 1783

    print("------------------ ${pattern.length} == hOfW.value = $hOfW");

    return (pattern, hOfW);
  }

  // Widget b2bSection(BuildContext context) {
  //
  //   log('controller.employers ${controller.employers.isEmpty}');
  //   if (controller.isLoading.value) {
  //     return AppShimmer(height: 250.h, width: double.infinity);
  //   }
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
  //     alignment: Alignment.center,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15.r),
  //       border: Border.all(color: AppColors.boxBorder, width: 2.5.w),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       spacing: 5.h,
  //       children: [
  //         Text(
  //           'B2B',
  //           style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //             color: AppColors.colorFFFFFF,
  //             fontSize: 25.sp,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         Obx(
  //           () =>
  //               controller.employers.isEmpty
  //                   ? Text(
  //                     'No B2B users found',
  //                     style: TextStyle(
  //                       color: AppColors.colorFFFFFF,
  //                       fontSize: 16.sp,
  //                     ),
  //                   )
  //                   : SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children:
  //                           controller.employers.asMap().entries.map((entry) {
  //                             final index = entry.key;
  //                             final user = entry.value;
  //                             final name =
  //                                 user.employer?.businessName ??
  //                                 user.email.split('@').first;
  //
  //                             return GestureDetector(
  //                               onTap:
  //                                   () => Get.toNamed(
  //                                     Routes.b2bScreen,
  //                                     arguments: {'currentUser': user},
  //                                   ),
  //
  //                               child: HexagonAvatar(
  //                                 imagePath:
  //                                     user.profileImage!.isNotEmpty == true
  //                                         ? user.profileImage!
  //                                         : '',
  //                                 width: 90.w,
  //                                 height: 100.h,
  //                                 borderColor:
  //                                     index % 2 == 0
  //                                         ? AppColors.colorFFFFFF
  //                                         : AppColors.colorFF8600,
  //                                 name: name,
  //                                 totalMl: "aa",
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
    return Obx(() {
      log('controller.employers empty? ${controller.employers.isEmpty}');
      log('isLoading: ${controller.isLoading.value}');

      if (controller.isLoading.value) {
        return AppShimmer(height: 250.h, width: double.infinity);
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.boxBorder, width: 2.5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.h,
          children: [
            Text(
              'B2B',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.colorFFFFFF,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            controller.employers.isEmpty
                ? Text(
                  'No B2B users found',
                  style: TextStyle(
                    color: AppColors.colorFFFFFF,
                    fontSize: 16.sp,
                  ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        controller.employers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final user = entry.value;

                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              try {
                                final response =
                                    await ProfileApi.getUserProfile(user.id);

                                if (!response.status) {
                                  Utilities.showSnackBar(
                                    title: 'Profile View Limit',
                                    message: response.message,
                                    isSuccess: false,
                                  );
                                  return;
                                }

                                Get.toNamed(
                                  Routes.b2bScreen,
                                  arguments: {
                                    'currentUser': user,
                                    'viewedUserId': user.id,
                                  },
                                );
                              } catch (e) {
                                Utilities.showSnackBar(
                                  title: 'Error',
                                  message: e.toString().replaceFirst(
                                    'Exception: ',
                                    '',
                                  ),
                                  isSuccess: false,
                                );
                              }
                            },
                            child: HexagonAvatar(
                              imagePath: user.profileImage ?? "",
                              width: 90.w,
                              height: 100.h,
                              borderColor:
                                  index % 2 == 0
                                      ? AppColors.colorFFFFFF
                                      : AppColors.colorFF8600,
                              name:
                                  user.employer?.businessName ??
                                  user.email.split('@').first,
                              totalMl: "aa",
                            ),
                          );
                        }).toList(),
                  ),
                ),
          ],
        ),
      );
    });
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String? value,
    required String hintText,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return CustomDropdown(
      hint: hintText,
      selectedValue: RxString(value ?? ''),
      items: items,
      onChanged: onChanged,
      fontSize: 16.0,
      iconSize: 24.0,
      borderRadius: 10.0,
      backgroundColor: AppColors.color000000,
      textColor: AppColors.colorFFFFFF,
      dropdownColor: AppColors.color4A4A4A,
      borderColor: AppColors.colorA3A3A3,
    );
  }
}

/// Separate stateful widget for banner ad to prevent rebuilds
class DashboardBannerAdWidget extends StatefulWidget {
  const DashboardBannerAdWidget({super.key});

  @override
  State<DashboardBannerAdWidget> createState() =>
      _DashboardBannerAdWidgetState();
}

class _DashboardBannerAdWidgetState extends State<DashboardBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    AdsHelper().loadBannerAd(
      onAdLoaded: (ad) {
        if (!mounted) return;
        setState(() {
          _bannerAd = ad;
          _isLoaded = true;
        });
      },
      onAdFailed: () {
        if (!mounted) return;
        setState(() {
          _isLoaded = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return AppShimmer(height: 80.h, width: double.infinity);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
